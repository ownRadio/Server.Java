CREATE OR REPLACE FUNCTION getnexttrackid(IN i_deviceid UUID)
  RETURNS SETOF UUID AS
'
DECLARE
  i_userid uuid = i_deviceid;
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
                                                     now();

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
  WHERE ratings.ratingsum >=0 OR ratings.ratingsum is null
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
  SELECT uuid_generate_v1()
  INTO i_historyid;
  SELECT uuid_generate_v1()
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
                                               now();

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
  INSERT INTO tracks (recid, localdevicepathupload, path, deviceid, reccreated)
  VALUES (i_trackid, i_localdevicepathupload, i_path, i_deviceid, now());

  -- Добавляем запись о прослушивании трека в таблицу истории прослушивания
  INSERT INTO histories (recid, deviceid, trackid, isListen, lastListen, method, reccreated)
  VALUES (i_historyid, i_deviceid, i_trackid, 1, now(), ''method'', now());

  -- Добавляем запись в таблицу рейтингов
  INSERT INTO ratings (recid, userid, trackid, lastListen, ratingsum, reccreated)
  VALUES (i_ratingid, i_userid, i_trackid, now(), 1, now());

  RETURN TRUE;
END;
'
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION getnexttrackid_v2(i_deviceid uuid, OUT o_methodid integer, OUT o_trackid uuid)
 AS
'
DECLARE
	i_userid uuid = i_deviceid;
	rnd integer = (select trunc(random() * 10));
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
														now();

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

  -- Выбираем следующий трек

  -- В 9/10 случаях выбираем трек из треков пользователя (добавленных им или прослушанных до конца)
  -- с положительным рейтингом, за исключением прослушанных за последние сутки
	IF (rnd > 1)
	THEN
		o_methodid = 2;
		o_trackid=(SELECT trackid
		FROM ratings
		WHERE userid = i_userid
			AND lastlisten < localtimestamp - interval ''1 day''
			AND ratingsum >= 0
		ORDER BY RANDOM()
		LIMIT 1);

		-- Если такой трек найден - выход из функции, возврат найденного значения
		IF FOUND
		THEN RETURN;
		END IF;
	END IF;

	-- В 1/10 случае выбираем случайный трек из ни разу не прослушанных пользователем треков
	o_methodid = 3;
	o_trackid=(SELECT recid
	FROM tracks
	WHERE recid NOT IN
		(SELECT trackid
		FROM ratings
		WHERE userid = i_userid)
	ORDER BY RANDOM()
	LIMIT 1);

  -- Если такой трек найден - выход из функции, возврат найденного значения
	IF FOUND
	THEN RETURN;
	END IF;

	-- Если предыдущие запросы вернули null, выбираем случайный трек
	o_methodid = 1;
	o_trackid=(SELECT recid
	FROM tracks
	ORDER BY RANDOM()
	LIMIT 1);
	RETURN;
END;
'
LANGUAGE plpgsql;

-- CREATE TYPE myintuuid AS (
--   methodid INTEGER,
--   trackid CHARACTER VARYING
-- );


-- CREATE TYPE myintstring AS (
--   methodid INTEGER,
--   trackid CHARACTER VARYING
-- );
--
CREATE OR REPLACE FUNCTION public.getnexttrack_string(i_deviceid uuid)
  RETURNS CHARACTER VARYING AS
'
DECLARE
  tmpres myintuuid;
  res myintstring;
BEGIN
  tmpres = getnexttrackid_v2(i_deviceid);
  res.methodid = tmpres.methodid;
  res.trackid = CAST ((tmpres.trackid) AS CHARACTER VARYING);
  RETURN res.trackid;
END;
'
LANGUAGE plpgsql;