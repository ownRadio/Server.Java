CREATE OR REPLACE FUNCTION getnexttrackid(IN i_deviceid UUID)
	RETURNS SETOF UUID AS
'
DECLARE
	i_userid UUID = i_deviceid;
BEGIN
	-- Добавляем устройство, если его еще не существует
	-- Если ID устройства еще нет в БД
	IF NOT EXISTS(SELECT recid
				  FROM devices
				  WHERE recid = i_deviceid)
	THEN

		-- Добавляем нового пользователя
		INSERT INTO users (recid, recname, reccreated) SELECT
										   i_userid,
										   ''New user recname'',
										   now()
		WHERE NOT EXISTS(SELECT recid FROM users WHERE recid = i_userid);

		-- Добавляем новое устройство
		INSERT INTO devices (recid, userid, recname, reccreated) SELECT
											 i_deviceid,
											 i_userid,
											 ''New device recname'',
											 now();
	ELSE
		SELECT (SELECT userid
				FROM devices
				WHERE recid = i_deviceid
				LIMIT 1)
		INTO i_userid;
	END IF;

	RETURN QUERY
	SELECT tracks.recid
	FROM tracks
		LEFT JOIN
		ratings
			ON tracks.recid = ratings.trackid AND ratings.userid = i_userid
	WHERE ratings.ratingsum >= 0 OR ratings.ratingsum IS NULL
	ORDER BY RANDOM()
	LIMIT 1;
END;
'
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION getnexttrackid_string(i_deviceid UUID)
	RETURNS SETOF CHARACTER VARYING AS
'
BEGIN
	RETURN QUERY SELECT CAST(getnexttrackid(i_deviceid) AS CHARACTER VARYING);
END;
'
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION registertrack(
	i_trackid               UUID,
	i_localdevicepathupload CHARACTER VARYING,
	i_path                  CHARACTER VARYING,
	i_deviceid              UUID)
	RETURNS BOOLEAN AS
'
DECLARE
	i_userid    UUID = i_deviceid;
	i_historyid UUID;
	i_ratingid  UUID;
BEGIN
	CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
	SELECT uuid_generate_v4()
	INTO i_historyid;
	SELECT uuid_generate_v4()
	INTO i_ratingid;

	--
	-- Функция добавляет запись о треке в таблицу треков и делает сопутствующие записи в
	-- таблицу статистики прослушивания и рейтингов. Если пользователя, загружающего трек
	-- нет в базе, то он добавляется в таблицу пользователей.
	--

	-- Добавляем устройство, если его еще не существует
	-- Если ID устройства еще нет в БД
	IF NOT EXISTS(SELECT recid
				  FROM devices
				  WHERE recid = i_deviceid)
	THEN

		-- Добавляем нового пользователя
		INSERT INTO users (recid, recname, reccreated) SELECT
						   i_userid,
						   ''New user recname'',
						   now()
		WHERE NOT EXISTS(SELECT recid FROM users WHERE recid = i_userid);

		-- Добавляем новое устройство
		INSERT INTO devices (recid, userid, recname, reccreated) SELECT
							 i_deviceid,
							 i_userid,
							 ''New device recname'',
							 now();
	ELSE
		SELECT (SELECT userid
				FROM devices
				WHERE recid = i_deviceid
				LIMIT 1)
		INTO i_userid;
	END IF;

	-- Добавляем трек в базу данных
	INSERT INTO tracks (recid, localdevicepathupload, path, deviceid, reccreated, iscensorial, isexist)
	VALUES (i_trackid, i_localdevicepathupload, i_path, i_deviceid, now(), 2, 1);

	-- Добавляем запись о прослушивании трека в таблицу истории прослушивания
	INSERT INTO histories (recid, deviceid, trackid, isListen, lastListen, methodid, reccreated)
	VALUES (i_historyid, i_deviceid, i_trackid, 1, now(), 2, now());

	-- Добавляем запись в таблицу рейтингов
	INSERT INTO ratings (recid, userid, trackid, lastListen, ratingsum, reccreated)
	VALUES (i_ratingid, i_userid, i_trackid, now(), 1, now());

	RETURN TRUE;
END;
'
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION getnexttrackid_v2(i_deviceid UUID)
	RETURNS TABLE(track UUID, methodid INTEGER)
AS
'
DECLARE
	i_userid   UUID = i_deviceid;
	rnd        INTEGER = (SELECT trunc(random() * 10)); -- получаем случайное число от 0 до 9
	o_methodid INTEGER; -- id метода выбора трека
BEGIN

	-- Выбираем следующий трек

	-- В 9/10 случаях выбираем трек из треков пользователя (добавленных им или прослушанных до конца)
	-- с положительным рейтингом, за исключением прослушанных за последние сутки
	IF (rnd > 1)
	THEN
		o_methodid = 2;
		RETURN QUERY
		SELECT
			trackid,
			o_methodid
		FROM ratings
		WHERE userid = i_userid
			  AND lastlisten < localtimestamp - INTERVAL ''1 day''
			  AND ratingsum >= 0
			  AND (SELECT isexist
				   FROM tracks
				   WHERE recid = trackid) = 1
		ORDER BY RANDOM()
		LIMIT 1;

		-- Если такой трек найден - выход из функции, возврат найденного значения
		IF FOUND
		THEN RETURN;
		END IF;
	END IF;

	-- В 1/10 случае выбираем случайный трек из ни разу не прослушанных пользователем треков
	o_methodid = 3;
	RETURN QUERY
	SELECT
		recid,
		o_methodid
	FROM tracks
	WHERE recid NOT IN
		  (SELECT trackid
		   FROM ratings
		   WHERE userid = i_userid)
		  AND isexist = 1
	ORDER BY RANDOM()
	LIMIT 1;

	-- Если такой трек найден - выход из функции, возврат найденного значения
	IF FOUND
	THEN RETURN;
	END IF;

	-- Если предыдущие запросы вернули null, выбираем случайный трек
	o_methodid = 1;
	RETURN QUERY
	SELECT
		recid,
		o_methodid
	FROM tracks
	WHERE isexist = 1
	ORDER BY RANDOM()
	LIMIT 1;
	RETURN;
END;
'
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION getnexttrackid_v3(IN i_deviceid UUID)
	RETURNS TABLE(track UUID, methodid INTEGER) AS
'
DECLARE
	i_userid   UUID = i_deviceid;
	rnd        INTEGER = (SELECT trunc(random() * 1001));
	o_methodid INTEGER; -- id метода выбора трека
	owntracks  INTEGER; -- количество "своих" треков пользователя (обрезаем на 900 шт)
BEGIN
	-- Выбираем следующий трек

	-- Определяем количество "своих" треков пользователя, ограничивая его 900
	owntracks = (SELECT COUNT(*)
			 FROM (
				  SELECT *
				  FROM ratings
				  WHERE userid = i_userid
						AND ratingsum >= 0
				  LIMIT 900) AS count);

	-- Если rnd меньше количества "своих" треков, выбираем трек из треков пользователя (добавленных им или прослушанных до конца)
	-- с положительным рейтингом, за исключением прослушанных за последние сутки

	IF (rnd < owntracks)
	THEN
		o_methodid = 2; -- метод выбора из своих треков
		RETURN QUERY
		SELECT
			trackid,
			o_methodid
		FROM ratings
		WHERE userid = i_userid
			  AND lastlisten < localtimestamp - INTERVAL ''1 day''
			  AND ratingsum >= 0
			  AND (SELECT isexist
				   FROM tracks
				   WHERE recid = trackid) = 1
		ORDER BY RANDOM()
		LIMIT 1;

		-- Если такой трек найден - выход из функции, возврат найденного значения
		IF FOUND
		THEN RETURN;
		END IF;
	END IF;

	-- В 1/10 случае выбираем случайный трек из ни разу не прослушанных пользователем треков
	o_methodid = 3; -- метод выбора из непрослушанных треков
	RETURN QUERY
	SELECT
		recid,
		o_methodid
	FROM tracks
	WHERE recid NOT IN
		  (SELECT trackid
		   FROM ratings
		   WHERE userid = i_userid)
		  AND isexist = 1
	ORDER BY RANDOM()
	LIMIT 1;

	-- Если такой трек найден - выход из функции, возврат найденного значения
	IF FOUND
	THEN RETURN;
	END IF;

	-- Если предыдущие запросы вернули null, выбираем случайный трек
	o_methodid = 1; -- метод выбора случайного трека
	RETURN QUERY
	SELECT
		recid,
		o_methodid
	FROM tracks
	WHERE isexist = 1
	ORDER BY RANDOM()
	LIMIT 1;
	RETURN;
END;
'
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION getnexttrackid_v5(IN i_deviceid UUID)
	RETURNS TABLE(track UUID, methodid INTEGER) AS
'
DECLARE
	i_userid   UUID = i_deviceid;
	rnd        INTEGER = (SELECT trunc(random() * 1001));
	o_methodid INTEGER; -- id метода выбора трека
	owntracks  INTEGER; -- количество "своих" треков пользователя (обрезаем на 900 шт)
BEGIN
	-- Выбираем следующий трек

	-- Определяем количество "своих" треков пользователя, ограничивая его 900
	owntracks = (SELECT COUNT(*)
		 FROM (
				  SELECT *
				  FROM ratings
				  WHERE userid = i_userid
						AND ratingsum >= 0
				  LIMIT 900) AS count);

	-- Если rnd меньше количества "своих" треков, выбираем трек из треков пользователя (добавленных им или прослушанных до конца)
	-- с положительным рейтингом, за исключением прослушанных за последние сутки

	IF (rnd < owntracks)
	THEN
		o_methodid = 2; -- метод выбора из своих треков
		RETURN QUERY
		SELECT
			trackid,
			o_methodid
		FROM ratings
		WHERE userid = i_userid
			  AND lastlisten < localtimestamp - INTERVAL ''1 day''
			  AND ratingsum >= 0
			  AND (SELECT isexist
				   FROM tracks
				   WHERE recid = trackid) = 1
			  AND ((SELECT length
					FROM tracks
					WHERE recid = trackid) >= 120
				   OR (SELECT length
					   FROM tracks
					   WHERE recid = trackid) IS NULL)
			  AND ((SELECT iscensorial
					FROM tracks
					WHERE recid = trackid) IS NULL
				   OR (SELECT iscensorial
					   FROM tracks
					   WHERE recid = trackid) != 0)
			  AND trackid NOT IN (SELECT trackid
						  FROM downloadtracks
						  WHERE reccreated > localtimestamp - INTERVAL ''1 day'')
		ORDER BY RANDOM()
		LIMIT 1;

		-- Если такой трек найден - выход из функции, возврат найденного значения
		IF FOUND
		THEN RETURN;
		END IF;
	END IF;

	-- В 1/10 случае выбираем случайный трек из ни разу не прослушанных пользователем треков
	o_methodid = 3; -- метод выбора из непрослушанных треков
	RETURN QUERY
	SELECT
		recid,
		o_methodid
	FROM tracks
	WHERE recid NOT IN
		  (SELECT trackid
		   FROM ratings
		   WHERE userid = i_userid)
		  AND isexist = 1
		  AND (iscensorial IS NULL OR iscensorial != 0)
		  AND (length > 120 OR length IS NULL)
		  AND recid NOT IN (SELECT trackid
				FROM downloadtracks
				WHERE reccreated > localtimestamp - INTERVAL ''1 day'')
	ORDER BY RANDOM()
	LIMIT 1;

	-- Если такой трек найден - выход из функции, возврат найденного значения
	IF FOUND
	THEN RETURN;
	END IF;

	-- Если предыдущие запросы вернули null, выбираем случайный трек
	o_methodid = 1; -- метод выбора случайного трека
	RETURN QUERY
	SELECT
		recid,
		o_methodid
	FROM tracks
	WHERE isexist = 1
		  AND (iscensorial IS NULL OR iscensorial != 0)
		  AND (length > 120 OR length IS NULL)
	ORDER BY RANDOM()
	LIMIT 1;
	RETURN;
END;
'
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION getnexttrack(i_deviceid UUID)
	RETURNS TABLE(
		track    CHARACTER VARYING
	,   methodid INTEGER)
AS
'
DECLARE
	i_userid UUID = i_deviceid; -- в дальнейшем заменить получением userid по deviceid
BEGIN
	-- Добавляем устройство, если его еще не существует
	-- Если ID устройства еще нет в БД
	IF NOT EXISTS(SELECT recid
		  FROM devices
		  WHERE recid = i_deviceid)
	THEN

		-- Добавляем нового пользователя
		INSERT INTO users (recid, recname, reccreated) SELECT
						   i_userid,
						   ''New user recname'',
						   now()
		WHERE NOT EXISTS(SELECT recid FROM users WHERE recid = i_userid);

		-- Добавляем новое устройство
		INSERT INTO devices (recid, userid, recname, reccreated) SELECT
							 i_deviceid,
							 i_userid,
							 ''New device recname'',
							 now();
	ELSE
		SELECT (SELECT userid
				FROM devices
				WHERE recid = i_deviceid
				LIMIT 1)
		INTO i_userid;
	END IF;

	-- Возвращаем trackid, конвертируя его в character varying и methodid
	RETURN QUERY SELECT
					 CAST((nexttrack.track) AS CHARACTER VARYING),
					 nexttrack.methodid
				 FROM getnexttrackid_v6(i_deviceid) AS nexttrack;
END;
'
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION calculateratios()
	RETURNS boolean AS
'
-- Функция рассчитывает таблицу коэффициентов схожести интересов для пар пользователей
DECLARE
	-- объявляем курсор и запрос для него
		curs1 CURSOR FOR SELECT * FROM(
				-- рассчитываем матрицу коэффициентов схожести интересов для каждой пары пользователей
				SELECT r.userid as userid01, r2.userid as userid02, SUM(r.ratingsum * r2.ratingsum) as s
				FROM ratings r
					  INNER JOIN ratings r2 ON r.trackid = r2.trackid
							 AND r.userid != r2.userid
				GROUP BY r.userid, r2.userid
				) AS cursor1;
	cuser1 uuid;
	cuser2 uuid;
	cratio integer;
BEGIN
	DROP TABLE IF EXISTS temp_ratio;
	CREATE TEMP TABLE temp_ratio(userid1 uuid, userid2 uuid, ratio integer);

	OPEN curs1; -- открываем курсор
	LOOP -- в цикле проходим по строкам результата запроса курсора
		FETCH curs1 INTO cuser1, cuser2, cratio;

		IF NOT FOUND THEN EXIT; -- если данных нет - выходим
		END IF;
		-- если для данной пары пользователей уже записан коэффициент - пропускаем, иначе - записываем во временную таблицу
		IF NOT EXISTS (SELECT * FROM temp_ratio WHERE userid1 = cuser2 AND userid2 = cuser1) THEN
			INSERT INTO temp_ratio(userid1, userid2, ratio)
			VALUES (cuser1, cuser2, cratio);
		END IF;
	END LOOP;
	CLOSE curs1; -- закрываем курсор

	-- обновляем имеющиеся коэффициенты в таблице ratios
	UPDATE ratios SET ratio = temp_ratio.ratio FROM temp_ratio
	WHERE (ratios.userid1 = temp_ratio.userid1 AND ratios.userid2 = temp_ratio.userid2)
		  OR (ratios.userid1 = temp_ratio.userid2 AND ratios.userid2 = temp_ratio.userid1);

	-- если в ratios меньше пар пользователей, чем во временной таблице - вставляем недостающие записи
	IF (SELECT COUNT(*) FROM ratios) < (SELECT COUNT(*) FROM temp_ratio) THEN
		INSERT INTO ratios (userid1, userid2, ratio)
			(SELECT tr.userid1, tr.userid2, tr.ratio FROM temp_ratio AS tr
				LEFT OUTER JOIN ratios AS rr ON tr.userid1 = rr.userid1 AND tr.userid2 = rr.userid2
			WHERE rr.userid1 IS NULL OR rr.userid2 IS NULL
			);
	END IF;
	RETURN TRUE;
END;
'
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION updateratios(i_userid uuid)
	RETURNS boolean AS
'
-- Функция обновляет таблицу коэффициентов схожести интересов для выбранного пользователя
DECLARE
	-- объявляем курсор и запрос для него
		curs1 CURSOR FOR SELECT * FROM(
				-- рассчитываем матрицу коэффициентов схожести интересов для каждой пары пользователей
				SELECT r.userid as userid01, r2.userid as userid02, SUM(r.ratingsum * r2.ratingsum) as s
				FROM ratings r
				 	INNER JOIN ratings r2 ON r.trackid = r2.trackid
						   AND r.userid != r2.userid
						   AND (r.userid = i_userid OR r2.userid = i_userid)
				GROUP BY r.userid, r2.userid
				) AS cursor1;
	cuser1 uuid;
	cuser2 uuid;
	cratio integer;
BEGIN
	DROP TABLE IF EXISTS temp_ratio;
	CREATE TEMP TABLE temp_ratio(userid1 uuid, userid2 uuid, ratio integer);

	OPEN curs1; -- открываем курсор
	LOOP -- в цикле проходим по строкам результата запроса курсора
		FETCH curs1 INTO cuser1, cuser2, cratio;

		IF NOT FOUND THEN EXIT; -- если данных нет - выходим
		END IF;
		-- если для данной пары пользователей уже записан коэффициент - пропускаем, иначе - записываем во временную таблицу
		IF NOT EXISTS (SELECT * FROM temp_ratio WHERE userid1 = cuser2 AND userid2 = cuser1) THEN
			INSERT INTO temp_ratio(userid1, userid2, ratio)
			VALUES (cuser1, cuser2, cratio);
		END IF;
	END LOOP;
	CLOSE curs1; -- закрываем курсор

	-- обновляем имеющиеся коэффициенты в таблице ratios
	UPDATE ratios SET ratio = temp_ratio.ratio FROM temp_ratio
	WHERE (ratios.userid1 = temp_ratio.userid1 AND ratios.userid2 = temp_ratio.userid2)
		  OR (ratios.userid1 = temp_ratio.userid2 AND ratios.userid2 = temp_ratio.userid1);

	-- если в ratios меньше пар пользователей, чем во временной таблице - вставляем недостающие записи
	IF (SELECT COUNT(*) FROM ratios WHERE userid1 = i_userid or userid2 = i_userid) < (SELECT COUNT(*) FROM temp_ratio) THEN
		INSERT INTO ratios (userid1, userid2, ratio)
			(SELECT tr.userid1, tr.userid2, tr.ratio FROM temp_ratio AS tr
				LEFT OUTER JOIN ratios AS rr ON tr.userid1 = rr.userid1 AND tr.userid2 = rr.userid2
			WHERE rr.userid1 IS NULL OR rr.userid2 IS NULL
			);
	END IF;
RETURN TRUE;
END;
'
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION public.getnexttrackid_v6(IN i_deviceid uuid)
	RETURNS TABLE(track uuid, methodid integer) AS
'
DECLARE
	i_userid   UUID = i_deviceid;
	rnd        INTEGER = (SELECT trunc(random() * 1001));
	o_methodid INTEGER; -- id метода выбора трека
	owntracks  INTEGER; -- количество "своих" треков пользователя (обрезаем на 900 шт)
	arrusers uuid ARRAY; -- массив пользователей для i_userid с неотрицательнымм коэффициентами схожести интересов
BEGIN
	-- Выбираем следующий трек

	-- Определяем количество "своих" треков пользователя, ограничивая его 900
	owntracks = (SELECT COUNT(*)
		 FROM (
			  SELECT *
			  FROM ratings
			  WHERE userid = i_userid
					AND ratingsum >= 0
			  LIMIT 900) AS count);

	-- Если rnd меньше количества "своих" треков, выбираем трек из треков пользователя (добавленных им или прослушанных до конца)
	-- с положительным рейтингом, за исключением прослушанных за последние сутки

	IF (rnd < owntracks)
	THEN
		o_methodid = 2; -- метод выбора из своих треков
		RETURN QUERY
		SELECT
			trackid,
			o_methodid
		FROM ratings
		WHERE userid = i_userid
			  AND lastlisten < localtimestamp - INTERVAL ''1 day''
			  AND ratingsum >= 0
			  AND (SELECT isexist
				   FROM tracks
				   WHERE recid = trackid) = 1
			  AND ((SELECT length
					FROM tracks
					WHERE recid = trackid) >= 120
				   OR (SELECT length
					   FROM tracks
					   WHERE recid = trackid) IS NULL)
			  AND ((SELECT iscensorial
					FROM tracks
					WHERE recid = trackid) IS NULL
				   OR (SELECT iscensorial
					   FROM tracks
					   WHERE recid = trackid) != 0)
			  AND trackid NOT IN (SELECT trackid
						  FROM downloadtracks
						  WHERE reccreated > localtimestamp - INTERVAL ''1 day'')
		ORDER BY RANDOM()
		LIMIT 1;

		-- Если такой трек найден - выход из функции, возврат найденного значения
		IF FOUND
		THEN RETURN;
		END IF;
	END IF;

	-- Если rnd больше количества "своих" треков - рекомендуем трек из треков пользователя с наибольшим
	-- коэффициентом схожести интересов и наибольшим рейтингом прослушивания

	-- Выберем всех пользователей с неотрицательным коэффициентом схожести интересов для i_userid
	-- отсортировав по убыванию коэффициентов
	arrusers = (SELECT ARRAY (SELECT CASE WHEN userid1 = i_userid THEN userid2
				 WHEN userid2 = i_userid THEN userid1
				 ELSE NULL
				 END
		  FROM ratios
		  WHERE userid1 = i_userid OR userid2 = i_userid
				  AND ratio >= 0
		  ORDER BY ratio DESC
	));
	-- Выбираем пользователя i, с которым у него максимальный коэффициент. Среди его треков ищем трек
	-- с максимальным рейтингом прослушивания, за исключением уже прослушанных пользователем i_userid.
	-- Если рекомендовать нечего - берем следующего пользователя с наибольшим коэффициентом из оставшихся.
	FOR i IN 1.. (SELECT COUNT (*) FROM unnest(arrusers)) LOOP
		o_methodid = 4; -- метод выбора из рекомендованных треков
		RETURN QUERY
		SELECT
			trackid,
			o_methodid
		FROM ratings
		WHERE userid = arrusers[i]
			  AND ratingsum > 0
			  AND trackid NOT IN (SELECT trackid FROM ratings WHERE userid = i_userid)
			  AND trackid NOT IN (SELECT trackid
				  FROM downloadtracks
				  WHERE deviceid = i_userid
						AND reccreated > localtimestamp - INTERVAL ''1 day'')
			  AND (SELECT isexist
				   FROM tracks
				   WHERE recid = trackid) = 1
			  AND ((SELECT length
					FROM tracks
					WHERE recid = trackid) >= 120
				   OR (SELECT length
					   FROM tracks
					   WHERE recid = trackid) IS NULL)
			  AND ((SELECT iscensorial
					FROM tracks
					WHERE recid = trackid) IS NULL
				   OR (SELECT iscensorial
					   FROM tracks
					   WHERE recid = trackid) != 0)
		ORDER BY ratingsum DESC
		LIMIT 1;
		-- Если нашли что рекомендовать - выходим из функции
		IF found THEN
			RETURN;
		END IF;
	END LOOP;

	-- При отсутствии рекомендаций, выдавать случайный трек из непрослушанных треков с неотрицательным
	-- рейтингом среди пользователей со схожим вкусом.
	FOR i IN 1.. (SELECT COUNT (*) FROM unnest(arrusers)) LOOP
		o_methodid = 5; -- метод выбора из непрослушанных треков с неотрицательным рейтингом среди пользователей со схожим вкусом
		RETURN QUERY
		SELECT
			recid,
			o_methodid
		FROM tracks
		WHERE recid NOT IN (SELECT trackid FROM ratings WHERE userid = arrusers[i] AND ratingsum < 0)
			  AND recid NOT IN (SELECT trackid FROM ratings WHERE userid = i_userid)
			  AND isexist = 1
			  AND (iscensorial IS NULL OR iscensorial != 0)
			  AND (length > 120 OR length IS NULL)
			  AND recid NOT IN (SELECT trackid
					FROM downloadtracks
					WHERE reccreated > localtimestamp - INTERVAL ''1 day'')
		ORDER BY RANDOM()
		LIMIT 1;
		-- Если нашли что рекомендовать - выходим из функции
		IF found THEN
			RETURN;
		END IF;
	END LOOP;

	-- Если таких треков нет - выбираем случайный трек из ни разу не прослушанных пользователем треков
	o_methodid = 3; -- метод выбора из непрослушанных треков
	RETURN QUERY
	SELECT
		recid,
		o_methodid
	FROM tracks
	WHERE recid NOT IN
		  (SELECT trackid
		   FROM ratings
		   WHERE userid = i_userid)
		  AND isexist = 1
		  AND (iscensorial IS NULL OR iscensorial != 0)
		  AND (length > 120 OR length IS NULL)
		  AND recid NOT IN (SELECT trackid
				FROM downloadtracks
				WHERE reccreated > localtimestamp - INTERVAL ''1 day'')
	ORDER BY RANDOM()
	LIMIT 1;

	-- Если такой трек найден - выход из функции, возврат найденного значения
	IF FOUND
	THEN RETURN;
	END IF;

	-- Если предыдущие запросы вернули null, выбираем случайный трек
	o_methodid = 1; -- метод выбора случайного трека
	RETURN QUERY
	SELECT
		recid,
		o_methodid
	FROM tracks
	WHERE isexist = 1
		  AND (iscensorial IS NULL OR iscensorial != 0)
		  AND (length > 120 OR length IS NULL)
	ORDER BY RANDOM()
	LIMIT 1;
	RETURN;
END;
'
LANGUAGE plpgsql;