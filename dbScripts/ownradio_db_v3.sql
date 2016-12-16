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
				now();

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
				 FROM getnexttrackid_v3(i_deviceid) AS nexttrack;
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
                                                     now();

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
                                               now();

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

