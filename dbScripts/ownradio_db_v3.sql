-- Database: "ownRadioJava"

-- DROP DATABASE "ownRadioJava";

CREATE DATABASE "ownRadioJava"
  WITH OWNER = postgres
       ENCODING = 'UTF8'
       TABLESPACE = pg_default
       LC_COLLATE = 'ru_RU.UTF-8'
       LC_CTYPE = 'ru_RU.UTF-8'
       CONNECTION LIMIT = -1;
	   
	   
-- Table: public.devices

-- DROP TABLE public.devices;

CREATE TABLE public.devices
(
  recid uuid NOT NULL,
  reccreated timestamp without time zone,
  recname character varying(255),
  recupdated timestamp without time zone,
  userid uuid,
  CONSTRAINT devices_pkey PRIMARY KEY (recid),
  CONSTRAINT fk9xjj6x9ueb7id644i4ycukpug FOREIGN KEY (userid)
      REFERENCES public.users (recid) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT fkrfbri1ymrwywdydc4dgywe1bt FOREIGN KEY (userid)
      REFERENCES public.users (recid) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE,
  autovacuum_enabled=true
);
ALTER TABLE public.devices
  OWNER TO postgres;
  
  
-- Table: public.downloadtracks

-- DROP TABLE public.downloadtracks;

CREATE TABLE public.downloadtracks
(
  recid uuid NOT NULL,
  reccreated timestamp without time zone,
  recname character varying(255),
  recupdated timestamp without time zone,
  deviceid uuid,
  trackid uuid,
  CONSTRAINT download_tracks_pkey PRIMARY KEY (recid),
  CONSTRAINT fkcsqwol33buwhcijea4w2ty5k2 FOREIGN KEY (trackid)
      REFERENCES public.tracks (recid) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT fkerttthmbxldbrlonworltybaq FOREIGN KEY (deviceid)
      REFERENCES public.devices (recid) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT fkf38s60by3ys41nkrvo0wpghqu FOREIGN KEY (deviceid)
      REFERENCES public.devices (recid) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT fklkvcfwa2nxrdfs6q20x3slfsk FOREIGN KEY (trackid)
      REFERENCES public.tracks (recid) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE,
  autovacuum_enabled=true
);
ALTER TABLE public.downloadtracks
  OWNER TO postgres;
  
  
  
-- Table: public.histories

-- DROP TABLE public.histories;

CREATE TABLE public.histories
(
  recid uuid NOT NULL,
  reccreated timestamp without time zone,
  recname character varying(255),
  recupdated timestamp without time zone,
  islisten integer NOT NULL,
  lastlisten timestamp without time zone NOT NULL,
  method character varying(255),
  deviceid uuid,
  trackid uuid,
  userid uuid,
  methodid integer,
  CONSTRAINT histories_pkey PRIMARY KEY (recid),
  CONSTRAINT fk66xoney4xhu7rp7yxwye0tuw4 FOREIGN KEY (deviceid)
      REFERENCES public.devices (recid) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT fk6kk9amb55jghcg30cxstw4yw FOREIGN KEY (trackid)
      REFERENCES public.tracks (recid) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT fk8w9eva74w7t7xtf2opb33f8bq FOREIGN KEY (userid)
      REFERENCES public.users (recid) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT fkbc0htpqvevq196g2vpa9ipkci FOREIGN KEY (trackid)
      REFERENCES public.tracks (recid) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT fkbjn2i4ry8qwwp12wwbq4n96aa FOREIGN KEY (deviceid)
      REFERENCES public.devices (recid) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE,
  autovacuum_enabled=true
);
ALTER TABLE public.histories
  OWNER TO postgres;

  
-- Table: public.ratings

-- DROP TABLE public.ratings;

CREATE TABLE public.ratings
(
  recid uuid NOT NULL,
  reccreated timestamp without time zone,
  recname character varying(255),
  recupdated timestamp without time zone,
  lastlisten timestamp without time zone NOT NULL,
  ratingsum integer NOT NULL,
  trackid uuid,
  userid uuid,
  CONSTRAINT ratings_pkey PRIMARY KEY (recid),
  CONSTRAINT fk1wogw2je0eguqyvbegwgqwmku FOREIGN KEY (trackid)
      REFERENCES public.tracks (recid) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT fk9obht0874ty4owpd9a3hqa7gr FOREIGN KEY (userid)
      REFERENCES public.users (recid) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT fkb3354ee2xxvdrbyq9f42jdayd FOREIGN KEY (userid)
      REFERENCES public.users (recid) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT fkkewx1qhpt2egcdq7x92cv63p7 FOREIGN KEY (trackid)
      REFERENCES public.tracks (recid) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE,
  autovacuum_enabled=true
);
ALTER TABLE public.ratings
  OWNER TO postgres;

-- Index: public.idx_lastlisten

-- DROP INDEX public.idx_lastlisten;

CREATE INDEX idx_lastlisten
  ON public.ratings
  USING btree
  (lastlisten);

-- Index: public.idx_trackid

-- DROP INDEX public.idx_trackid;

CREATE INDEX idx_trackid
  ON public.ratings
  USING btree
  (trackid);

-- Index: public.idx_userid

-- DROP INDEX public.idx_userid;

CREATE INDEX idx_userid
  ON public.ratings
  USING btree
  (userid);
  
  
-- Table: public.tracks

-- DROP TABLE public.tracks;

CREATE TABLE public.tracks
(
  recid uuid NOT NULL,
  reccreated timestamp without time zone,
  recname character varying(255),
  recupdated timestamp without time zone,
  localdevicepathupload character varying(255) NOT NULL,
  path character varying(255),
  deviceid uuid,
  uploaduserid uuid,
  artist character varying(255),
  iscensorial integer,
  iscorrect integer,
  isfilledinfo integer,
  length integer,
  size integer,
  CONSTRAINT tracks_pkey PRIMARY KEY (recid),
  CONSTRAINT fk4n44h9fs1to11otqj5ek7xtus FOREIGN KEY (deviceid)
      REFERENCES public.devices (recid) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT fk7901v2785f03qrr9ruiwy7nd FOREIGN KEY (deviceid)
      REFERENCES public.devices (recid) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT fkfp7ki0smfcrvbvfjdnddxi1fb FOREIGN KEY (uploaduserid)
      REFERENCES public.users (recid) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE,
  autovacuum_enabled=true
);
ALTER TABLE public.tracks
  OWNER TO postgres;

  
-- Table: public.users

-- DROP TABLE public.users;

CREATE TABLE public.users
(
  recid uuid NOT NULL,
  reccreated timestamp without time zone,
  recname character varying(255),
  recupdated timestamp without time zone,
  CONSTRAINT users_pkey PRIMARY KEY (recid)
)
WITH (
  OIDS=FALSE,
  autovacuum_enabled=true
);
ALTER TABLE public.users
  OWNER TO postgres;
  
-- Table: public.ratios

-- DROP TABLE public.ratios;

CREATE TABLE public.ratios
(
  recid uuid NOT NULL DEFAULT uuid_generate_v4(),
  userid1 uuid NOT NULL,
  userid2 uuid NOT NULL,
  ratio integer,
  CONSTRAINT ratios_pkey PRIMARY KEY (recid)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.ratios
  OWNER TO postgres;
  
-- Function: public.getnexttrack(uuid)

-- DROP FUNCTION public.getnexttrack(uuid);

CREATE OR REPLACE FUNCTION public.getnexttrack(IN i_deviceid uuid)
  RETURNS TABLE(track character varying, methodid integer) AS
$BODY$
DECLARE
  i_userid   uuid = i_deviceid; -- в дальнейшем заменить получением userid по deviceid
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
				'New user recname',
				now()
		WHERE NOT EXISTS(SELECT recid FROM users WHERE recid = i_userid);

		-- Добавляем новое устройство
		INSERT INTO devices (recid, userid, recname, reccreated) SELECT
				i_deviceid,
				i_userid,
				'New device recname',
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
				 FROM getnexttrackid_v7(i_deviceid) AS nexttrack;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION public.getnexttrack(uuid)
  OWNER TO "postgres";

  
-- Function: public.getnexttrackid(uuid)

-- DROP FUNCTION public.getnexttrackid(uuid);

CREATE OR REPLACE FUNCTION public.getnexttrackid(i_deviceid uuid)
  RETURNS SETOF uuid AS
$BODY$
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
                                                     'New user recname',
                                                     now()
	WHERE NOT EXISTS(SELECT recid FROM users WHERE recid = i_userid);

    -- Добавляем новое устройство
    INSERT INTO devices (recid, userid, recname, reccreated) SELECT
                                                               i_deviceid,
                                                               i_userid,
                                                               'New device recname',
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
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION public.getnexttrackid(uuid)
  OWNER TO postgres;

  
-- Function: public.getnexttrackid_string(uuid)

-- DROP FUNCTION public.getnexttrackid_string(uuid);

CREATE OR REPLACE FUNCTION public.getnexttrackid_string(i_deviceid uuid)
  RETURNS SETOF character varying AS
$BODY$
BEGIN
  RETURN QUERY SELECT CAST(getnexttrackid(i_deviceid) AS CHARACTER VARYING);
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION public.getnexttrackid_string(uuid)
  OWNER TO postgres;

  
-- Function: public.getnexttrackid_v2(uuid)

-- DROP FUNCTION public.getnexttrackid_v2(uuid);

CREATE OR REPLACE FUNCTION public.getnexttrackid_v2(IN i_deviceid uuid)
  RETURNS TABLE(track uuid, methodid integer) AS
$BODY$
DECLARE
	i_userid uuid = i_deviceid;
	rnd integer = (select trunc(random() * 10)); -- получаем случайное число от 0 до 9
    o_methodid integer; -- id метода выбора трека
BEGIN

  -- Выбираем следующий трек

  -- В 9/10 случаях выбираем трек из треков пользователя (добавленных им или прослушанных до конца)
  -- с положительным рейтингом, за исключением прослушанных за последние сутки
	IF (rnd > 1)
	THEN
		o_methodid = 2;
		RETURN QUERY
		SELECT trackid, o_methodid
          FROM ratings
          WHERE userid = i_userid
            AND lastlisten < localtimestamp - interval '1 day'
            AND ratingsum >= 0
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
	SELECT recid, o_methodid
      FROM tracks
      WHERE recid NOT IN
		(SELECT trackid
		FROM ratings
		WHERE userid = i_userid)
      ORDER BY RANDOM()
      LIMIT 1;

  -- Если такой трек найден - выход из функции, возврат найденного значения
	IF FOUND
	THEN RETURN;
	END IF;

	-- Если предыдущие запросы вернули null, выбираем случайный трек
	o_methodid = 1;
	RETURN QUERY
	SELECT recid, o_methodid
	  FROM tracks
      ORDER BY RANDOM()
      LIMIT 1;
	RETURN;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION public.getnexttrackid_v2(uuid)
  OWNER TO postgres;

  
-- Function: public.getnexttrackid_v3(uuid)

-- DROP FUNCTION public.getnexttrackid_v3(uuid);

CREATE OR REPLACE FUNCTION public.getnexttrackid_v3(IN i_deviceid uuid)
  RETURNS TABLE(track uuid, methodid integer) AS
$BODY$
DECLARE
	i_userid   uuid = i_deviceid;
	rnd        integer = (select trunc(random() * 1001));
	o_methodid integer; -- id метода выбора трека
    owntracks integer; -- количество "своих" треков пользователя (обрезаем на 900 шт)
BEGIN
	-- Выбираем следующий трек

	-- Определяем количество "своих" треков пользователя, ограничивая его 900
	owntracks = (SELECT COUNT(*) FROM (
		SELECT * FROM ratings
			WHERE userid = i_userid
					AND ratingsum >=0
			LIMIT 900) AS count) ;

	-- Если rnd меньше количества "своих" треков, выбираем трек из треков пользователя (добавленных им или прослушанных до конца)
	-- с положительным рейтингом, за исключением прослушанных за последние сутки

	IF (rnd < owntracks)
	THEN
		o_methodid = 2; -- метод выбора из своих треков
		RETURN QUERY
		SELECT trackid, o_methodid
          FROM ratings
          WHERE userid = i_userid
                AND lastlisten < localtimestamp - interval '1 day'
                AND ratingsum >= 0
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
	SELECT recid, o_methodid
      FROM tracks
      WHERE recid NOT IN
            (SELECT trackid
             FROM ratings
             WHERE userid = i_userid)
    ORDER BY RANDOM()
	LIMIT 1;

	-- Если такой трек найден - выход из функции, возврат найденного значения
	IF FOUND
	  THEN RETURN;
	END IF;

	-- Если предыдущие запросы вернули null, выбираем случайный трек
	o_methodid = 1; -- метод выбора случайного трека
	RETURN QUERY
	SELECT recid, o_methodid
      FROM tracks
      ORDER BY RANDOM()
    LIMIT 1;
    RETURN;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION public.getnexttrackid_v3(uuid)
  OWNER TO postgres;


-- Function: public.getnexttrackid_v5(uuid)

-- DROP FUNCTION public.getnexttrackid_v5(uuid);

CREATE OR REPLACE FUNCTION public.getnexttrackid_v5(IN i_deviceid uuid)
  RETURNS TABLE(track uuid, methodid integer) AS
$BODY$
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
			  AND lastlisten < localtimestamp - INTERVAL '1 day'
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
								  WHERE reccreated > localtimestamp - INTERVAL '1 day')
		ORDER BY RANDOM()
		LIMIT 1;

		-- Если такой трек найден - выход из функции, возврат найденного значения
		IF FOUND
		THEN RETURN;
		END IF;
	END IF;

	-- Если rnd больше количества "своих" треков - выбираем случайный трек из ни разу не прослушанных пользователем треков
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
							WHERE reccreated > localtimestamp - INTERVAL '1 day')
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
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION public.getnexttrackid_v5(uuid)
  OWNER TO postgres;
  
  
  
-- Function: public.getnexttrackid_v6(uuid)

-- DROP FUNCTION public.getnexttrackid_v6(uuid);

CREATE OR REPLACE FUNCTION public.getnexttrackid_v6(IN i_deviceid uuid)
  RETURNS TABLE(track uuid, methodid integer) AS
$BODY$
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
			  AND lastlisten < localtimestamp - INTERVAL '1 day'
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
							WHERE reccreated > localtimestamp - INTERVAL '1 day')
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
							WHERE deviceid = i_deviceid
								AND reccreated > localtimestamp - INTERVAL '1 day')
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
							WHERE reccreated > localtimestamp - INTERVAL '1 day')
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
							WHERE reccreated > localtimestamp - INTERVAL '1 day')
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
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION public.getnexttrackid_v6(uuid)
  OWNER TO postgres;

  
-- Function: public.registertrack(uuid, character varying, character varying, uuid)

-- DROP FUNCTION public.registertrack(uuid, character varying, character varying, uuid);

CREATE OR REPLACE FUNCTION public.registertrack(
    i_trackid uuid,
    i_localdevicepathupload character varying,
    i_path character varying,
    i_deviceid uuid)
  RETURNS boolean AS
$BODY$
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
                                               'New user recname',
                                               now()
	WHERE NOT EXISTS(SELECT recid FROM users WHERE recid = i_userid)
	ON CONFLICT (recid) DO NOTHING;

    -- Добавляем новое устройство
    INSERT INTO devices (recid, userid, recname, reccreated) SELECT
                                                          i_deviceid,
                                                          i_userid,
                                                          'New device recname',
                                                          now()
	ON CONFLICT (recid) DO NOTHING;
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
  INSERT INTO histories (recid, deviceid, trackid, isListen, lastListen, methodid, reccreated)
  VALUES (i_historyid, i_deviceid, i_trackid, 1, now(), 2, now());

  -- Добавляем запись в таблицу рейтингов
  INSERT INTO ratings (recid, userid, trackid, lastListen, ratingsum, reccreated)
  VALUES (i_ratingid, i_userid, i_trackid, now(), 1, now());

  RETURN TRUE;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.registertrack(uuid, character varying, character varying, uuid)
  OWNER TO postgres;

  
-- Function: public.selectdownloadhistory(uuid)

-- DROP FUNCTION public.selectdownloadhistory(uuid);

CREATE OR REPLACE FUNCTION public.selectdownloadhistory(IN i_deviceid uuid)
  RETURNS TABLE(recid uuid, reccreated timestamp without time zone, recname character varying, recupdated timestamp without time zone, deviceid uuid, trackid uuid, isstatisticback integer) AS
$BODY$
	BEGIN
		-- Выводит список треков по которым не была отдана история прослушивания для данного устройства
		RETURN QUERY  SELECT * FROM downloadtracks
		WHERE 
			downloadtracks.trackid NOT IN
				(SELECT histories.trackid FROM histories WHERE histories.deviceid = i_deviceid)
				AND downloadtracks.deviceid = i_deviceid;

	END;
	$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION public.selectdownloadhistory(uuid)
  OWNER TO postgres;
  
-- Function: public.calculateratios()

-- DROP FUNCTION public.calculateratios();

CREATE OR REPLACE FUNCTION public.calculateratios()
  RETURNS boolean AS
$BODY$
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

$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.calculateratios()
  OWNER TO postgres;

  
-- Function: public.updateratios(uuid)

-- DROP FUNCTION public.updateratios(uuid);

CREATE OR REPLACE FUNCTION public.updateratios(i_userid uuid)
  RETURNS boolean AS
$BODY$

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

$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.calculateratios()
  OWNER TO postgres;

  
  -- Function: getnexttrackid_v7(uuid)

-- DROP FUNCTION getnexttrackid_v7(uuid);

CREATE OR REPLACE FUNCTION getnexttrackid_v7(IN i_deviceid uuid)
  RETURNS TABLE(track uuid, methodid integer) AS
$BODY$

-- Функция выдачи следующего трека пользователю
-- С учетом рекомендаций от других пользователей

DECLARE
	i_userid   UUID = i_deviceid;
	rnd        INTEGER = (SELECT trunc(random() * 1001));
	o_methodid INTEGER; -- id метода выбора трека
	owntracks  INTEGER; -- количество "своих" треков пользователя (обрезаем на 900 шт)
	arrusers uuid ARRAY; -- массив пользователей для i_userid с неотрицательнымм коэффициентами схожести интересов
	exceptusers uuid ARRAY; -- массив пользователей для i_userid с котороми не было пересечений по трекам
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
			  AND lastlisten < localtimestamp - INTERVAL '1 day'
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
							WHERE reccreated > localtimestamp - INTERVAL '1 day')
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
							WHERE deviceid = i_deviceid 
								AND reccreated > localtimestamp - INTERVAL '1 day')
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
	-- рейтингом среди пользователей с которыми не было пересечений по трекам.
	exceptusers = (SELECT ARRAY (
				SELECT * FROM (
					SELECT recid FROM users WHERE recid != i_userid
						EXCEPT
						(SELECT CASE WHEN userid1 = i_userid THEN userid2
							 WHEN userid2 = i_userid THEN userid1
							 ELSE NULL
							 END
							FROM ratios WHERE userid1 = i_userid OR userid2 = i_userid)
				) AS us
			ORDER BY RANDOM()
			)
		);
	FOR i IN 1.. (SELECT COUNT (*) FROM unnest(exceptusers)) LOOP
		o_methodid = 6; -- метод выбора из непрослушанных треков с неотрицательным рейтингом среди пользователей с которыми не было пересечений
		RETURN QUERY 
		SELECT
			recid,
			o_methodid
		FROM tracks
		WHERE recid IN (SELECT trackid FROM ratings WHERE userid = exceptusers[i] AND ratingsum >= 0)
			  AND recid NOT IN (SELECT trackid FROM ratings WHERE userid = i_userid)
			  AND isexist = 1
			  AND (iscensorial IS NULL OR iscensorial != 0)
			  AND (length > 120 OR length IS NULL)
			  AND recid NOT IN (SELECT trackid
					FROM downloadtracks
					WHERE reccreated > localtimestamp - INTERVAL '1 day')
		ORDER BY RANDOM()
		LIMIT 1;
		-- Если нашли что рекомендовать - выходим из функции
		IF found THEN
			RETURN;
		ELSE 
		
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
							WHERE reccreated > localtimestamp - INTERVAL '1 day')
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
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION getnexttrackid_v7(uuid)
  OWNER TO "postgres";

 -- Function: public.getnexttrackid_v17(uuid)

-- DROP FUNCTION public.getnexttrackid_v17(uuid);

CREATE OR REPLACE FUNCTION public.getnexttrackid_v17(IN i_deviceid uuid)
  RETURNS TABLE(track uuid, methodid integer, useridrecommended uuid, txtrecommendedinfo character varying) AS
$BODY$

-- Функция выдачи треков пользователю
DECLARE
	i_userid   UUID = i_deviceid; -- На случай, если устройство еще не зарегистрировано и пользователь не существует
	rnd        INTEGER = (SELECT trunc(random() * 1001)); -- генерируем случайное целое число в диапазоне от 1 до 1000
	o_methodid INTEGER; -- id метода выбора трека
	owntracks  INTEGER; -- количество "своих" треков пользователя (обрезаем на 900 шт)
	arrusers uuid ARRAY; -- массив пользователей для i_userid с неотрицательнымм коэффициентами схожести интересов
	exceptusers uuid ARRAY; -- массив пользователей для i_userid с котороми не было пересечений по трекам
	temp_trackid uuid; 
	tmp_txtrecommendinfo text;
BEGIN
	-- temp_track - временная таблица для промежуточного результата (понадобилась чтобы найденные данные сначала сохранять в таблицу downloadtracks, а потом возвращать
	DROP TABLE IF EXISTS temp_track; 
	CREATE TEMP TABLE temp_track(track uuid, methodid integer, useridrecommended uuid, txtrecommendedinfo character varying);

	--Если устройство не было зарегистрировано ранее - регистрируем его
	IF NOT EXISTS(SELECT recid
		  FROM devices
		  WHERE recid = i_deviceid)
	THEN

		-- Добавляем нового пользователя
		INSERT INTO users (recid, recname, reccreated) SELECT
						   i_userid,
						   'New user recname',
						   now()
		WHERE NOT EXISTS(SELECT recid FROM users WHERE recid = i_userid);

		-- Добавляем новое устройство
		INSERT INTO devices (recid, userid, recname, reccreated) SELECT
							 i_deviceid,
							 i_userid,
							 'New device recname',
							 now();
	ELSE
	-- Если устройство зарегистрировано - ищем соответствующего ему пользователя
		SELECT (SELECT userid
				FROM devices
				WHERE recid = i_deviceid
				LIMIT 1)
		INTO i_userid;
	END IF;


	-- Выбираем следующий трек

	-- Определяем количество "своих" треков пользователя
	owntracks = (SELECT COUNT(*)
				FROM ratings
					WHERE userid = i_userid
						AND ratingsum >= 0);

	-- Если количество "своих" треков = 0 - выполняем процедуру предрекомендации
	IF (owntracks = 0) THEN
		o_methodid = 8; -- метод выбора из рекомендованных треков
		SELECT o_trackid, o_textinfo INTO temp_trackid, tmp_txtrecommendinfo FROM populartracksrecommend_v1(i_userid);
		-- Если такой трек найден - запись информацию о нем в downloadtracks, выход из функции, возврат найденного значения
		IF temp_trackid IS NOT null THEN
			INSERT INTO downloadtracks (SELECT uuid_generate_v4(),
							now(),
							null,
							null, 
							i_deviceid,
							temp_trackid,
							o_methodid,
							(SELECT CAST((
								tmp_txtrecommendinfo
								) AS CHARACTER VARYING)),
							(SELECT CAST((null) AS UUID)) );
		RETURN QUERY 
			SELECT temp_trackid,
			o_methodid,
			(SELECT CAST((null) AS UUID)),
			(SELECT CAST((
				tmp_txtrecommendinfo
				) AS CHARACTER VARYING));
		RETURN;
		END IF;
	END IF;
-- 	IF (rnd < owntracks)
-- 	THEN
-- 		o_methodid = 2; -- метод выбора из своих треков
-- 		INSERT INTO temp_track (
-- 		SELECT
-- 			trackid, -- выбираем id трека
-- 			o_methodid,
-- 			(SELECT CAST((null) AS UUID)),
-- 			(SELECT CAST(('случайный трек из своих') AS CHARACTER VARYING))
-- 		FROM ratings -- из треков, имеющих рейтинг для данного пользователя
-- 		WHERE userid = i_userid
-- 			  AND lastlisten < localtimestamp - INTERVAL '1 day' -- для которого последнее прослушивание было ранее, чем за сутки до выдачи
-- 			  AND ratingsum >= 0 -- рейтинг трека неотрицательный
-- 			  AND (SELECT isexist
-- 				   FROM tracks
-- 				   WHERE recid = trackid) = 1 -- трек существует на сервере
-- 			  AND ((SELECT length
-- 					FROM tracks
-- 					WHERE recid = trackid) >= 120 -- продолжительность трека больше двух минут
-- 				   OR (SELECT length
-- 					   FROM tracks
-- 					   WHERE recid = trackid) IS NULL) -- или длина трека не известна
-- 			  AND ((SELECT iscensorial
-- 					FROM tracks
-- 					WHERE recid = trackid) IS NULL -- трек должен быть цензурный или непроверенный
-- 				   OR (SELECT iscensorial
-- 					   FROM tracks
-- 					   WHERE recid = trackid) != 0)
-- 			  AND trackid NOT IN (SELECT trackid
-- 								  FROM downloadtracks
-- 								  WHERE reccreated > localtimestamp - INTERVAL '1 week' AND deviceid = i_deviceid) -- трек недолжен быть выдан в последнюю неделю
-- 		ORDER BY RANDOM()
-- 		LIMIT 1);

-- 		-- Если такой трек найден - запись информацию о нем в downloadtracks, выход из функции, возврат найденного значения
-- 		IF FOUND THEN
-- 			INSERT INTO downloadtracks (SELECT uuid_generate_v4(),now(),null, null, i_userid, temp_track.track AS trackid, temp_track.methodid AS methodid, temp_track.txtrecommendedinfo AS txtrecommendinfo, temp_track.useridrecommended AS userrecommend FROM temp_track);
-- 			RETURN QUERY SELECT * FROM temp_track;
-- 			RETURN;
-- 		END IF;
-- 	END IF;

	-- Если rnd больше количества "своих" треков - используем алгоритм рекоммендаций

	-- Если положительный коэффициент схожести интересов больше чем с пятью пользователями,
-- 	IF (SELECT COUNT (*) FROM ratios WHERE (userid1 = i_userid OR userid2 = i_userid) AND ratio >=0) > 5 THEN
	-- рекомендуем трек с максимальным рейтингом среди пользователей, с которыми были пересечения
		o_methodid = 7; -- метод выбора из рекомендованных треков
		SELECT rn_trackid, rn_txtrecommendinfo INTO temp_trackid, tmp_txtrecommendinfo FROM getrecommendedtrackid_v5(i_userid);
		-- Если такой трек найден - запись информацию о нем в downloadtracks, выход из функции, возврат найденного значения
		IF temp_trackid IS NOT null THEN
			INSERT INTO downloadtracks (SELECT uuid_generate_v4(),
							now(),
							null,
							null, 
							i_deviceid,
							temp_trackid,
							o_methodid,
							(SELECT CAST((
								tmp_txtrecommendinfo
								) AS CHARACTER VARYING)),
							(SELECT CAST((null) AS UUID)) );
		RETURN QUERY 
			SELECT temp_trackid,
			o_methodid,
			(SELECT CAST((null) AS UUID)),
			(SELECT CAST((
				tmp_txtrecommendinfo
				) AS CHARACTER VARYING));
		RETURN;
		END IF;
-- 	END IF;

	-- Если таких треков нет - выбираем популярный трек из ни разу не прослушанных пользователем треков
	o_methodid = 3; -- метод выбора популярных из непрослушанных треков
	INSERT INTO temp_track (
	SELECT
		trackid,
		o_methodid,
		(SELECT CAST((null) AS UUID)),
		(SELECT CAST(('популярный трек из непрослушанных пользователем') AS CHARACTER VARYING))
		FROM ratings
			WHERE userid IN (SELECT recid FROM users WHERE experience >= 10)
				AND userid != i_userid
				AND (SELECT recid FROM tracks 
						WHERE recid = trackid
							AND isexist = 1 -- трек существует на сервере
							AND (length >= 120 OR length IS NULL) -- продолжительность трека больше двух минут или длина трека не известна
							AND (iscensorial != 0 OR iscensorial IS NULL)) IS NOT NULL --трек должен быть цензурный или непроверенный
				AND trackid NOT IN (SELECT trackid
							FROM downloadtracks
							WHERE deviceid = i_deviceid)


		GROUP BY trackid
		ORDER BY sum(ratingsum) DESC, RANDOM()
		LIMIT 1);

	-- Если такой трек найден - запись информацию о нем в downloadtracks, выход из функции, возврат найденного значения
	IF FOUND THEN
		INSERT INTO downloadtracks (SELECT uuid_generate_v4(),now(),null, null, i_userid, temp_track.track AS trackid, temp_track.methodid AS methodid, temp_track.txtrecommendedinfo AS txtrecommendinfo, temp_track.useridrecommended AS userrecommend FROM temp_track);
		RETURN QUERY SELECT * FROM temp_track;
		RETURN;
	END IF;

	-- Если предыдущие запросы вернули null, выбираем случайный трек
	o_methodid = 1; -- метод выбора случайного трека
	INSERT INTO temp_track (
	SELECT
		recid,
		o_methodid,
		(SELECT CAST((null) AS UUID)),
		(SELECT CAST(('случайный трек из всех') AS CHARACTER VARYING))
	FROM tracks
	WHERE isexist = 1 -- существующий на сервере 
		  AND (iscensorial IS NULL OR iscensorial != 0) -- цензурный
		  AND (length > 120 OR length IS NULL) -- продолжительностью более 2х минут
	ORDER BY RANDOM()
	LIMIT 1);
	INSERT INTO downloadtracks (SELECT uuid_generate_v4(),now(),null, null, i_userid, temp_track.track AS trackid, temp_track.methodid AS methodid, temp_track.txtrecommendedinfo AS txtrecommendinfo, temp_track.useridrecommended AS userrecommend FROM temp_track);
	RETURN QUERY SELECT * FROM temp_track;
	RETURN;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION public.getnexttrackid_v17(uuid)
  OWNER TO "a.polunina";


  -- Function: public.getnexttrack_v2(uuid)

-- DROP FUNCTION public.getnexttrack_v2(uuid);

CREATE OR REPLACE FUNCTION public.getnexttrack_v2(IN i_deviceid uuid)
  RETURNS TABLE(track character varying, method integer, useridrecommended character varying, txtrecommendedinfo character varying, timeexecute character varying) AS
$BODY$
DECLARE
		declare t timestamptz := clock_timestamp(); -- запоминаем начальное время выполнения процедуры
		i_userid UUID = i_deviceid; -- в дальнейшем заменить получением userid по deviceid
BEGIN
	-- Добавляем устройство, если его еще не существует
	PERFORM registerdevice(i_deviceid, 'New device');

	-- Возвращаем trackid, конвертируя его в character varying, и methodid
	RETURN QUERY SELECT
					 CAST((nexttrack.track) AS CHARACTER VARYING),
					 nexttrack.methodid,
					 CAST((nexttrack.useridrecommended) AS CHARACTER VARYING),
					 nexttrack.txtrecommendedinfo,
					 CAST((clock_timestamp() - t ) AS CHARACTER VARYING) -- возвращаем время выполнения процедуры
				 FROM getnexttrackid_v17(i_deviceid) AS nexttrack;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION public.getnexttrack_v2(uuid)
  OWNER TO postgres;

  
  -- Function: public.populartracksrecommend_v1(uuid)

-- DROP FUNCTION public.populartracksrecommend_v1(uuid);

CREATE OR REPLACE FUNCTION public.populartracksrecommend_v1(
    IN i_userid uuid,
    OUT o_trackid uuid,
    OUT o_textinfo character varying)
  RETURNS record AS
$BODY$

-- Функция выдачи треков пользователю, не имеющему пользователей со схожим вкусом
BEGIN

	WITH exclude_users AS (
		SELECT r.userid 
			FROM downloadtracks d
				INNER JOIN ratings r
					ON d.trackid = r.trackid
			WHERE d.deviceid = i_userid
				AND r.userid IN (SELECT recid FROM users WHERE experience >= 10)
			GROUP BY r.userid)
	SELECT recid, 'предрекомендация, суммарный рейтинг трека ' || rate INTO o_trackid, o_textinfo 
		FROM (
		SELECT t.recid, SUM(r.ratingsum) AS rate
			FROM tracks t
				INNER JOIN ratings r
					ON t.recid = r.trackid    
						AND r.userid IN (SELECT recid FROM users WHERE experience >= 10)
			WHERE t.recid NOT IN (SELECT trackid FROM ratings WHERE userid IN (SELECT * FROM exclude_users) GROUP BY trackid)
				AND isexist = 1
				AND (iscensorial IS NULL OR iscensorial != 0)
				AND (length > 120 OR length IS NULL)
			GROUP BY t.recid
			ORDER BY rate DESC) AS res
		WHERE rate > 0
		LIMIT 1;
END;

$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.populartracksrecommend_v1(uuid)
  OWNER TO postgres;
