CREATE OR REPLACE FUNCTION getnexttrackid(IN i_deviceid UUID)
  RETURNS SETOF UUID AS
'
BEGIN
  RETURN QUERY
  SELECT id
  FROM tracks
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
  i_userid    UUID;
  i_historyid UUID;
  i_ratingid  UUID;
BEGIN
  CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
  SELECT uuid_generate_v1()
  INTO i_userid;
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
  IF NOT EXISTS(SELECT id
                FROM devices
                WHERE id = i_deviceid)
  THEN

    -- Добавляем нового пользователя
    INSERT INTO users (id, name, created_at) SELECT
                                               i_userid,
                                               ''New user name'',
                                               now();

    -- Добавляем новое устройство
    INSERT INTO devices (id, user_id, name, created_at) SELECT
                                                          i_deviceid,
                                                          i_userid,
                                                          ''New device name'',
                                                          now();
  ELSE
    SELECT (SELECT user_id
     FROM devices
     WHERE id = i_deviceid
     LIMIT 1)
     INTO i_userid;
  END IF;

  -- Добавляем трек в базу данных
  INSERT INTO tracks (id, local_device_path_upload, path, device_id, created_at)
  VALUES (i_trackid, i_localdevicepathupload, i_path, i_deviceid, now());

  -- Добавляем запись о прослушивании трека в таблицу истории прослушивания
  INSERT INTO histories (id, device_id, track_id, is_listen, last_listen, method, created_at)
  VALUES (i_historyid, i_deviceid, i_trackid, 1, now(), ''method'', now());

  -- Добавляем запись в таблицу рейтингов
  INSERT INTO ratings (id, user_id, track_id, last_listen, rating_sum, created_at)
  VALUES (i_ratingid, i_userid, i_trackid, now(), 1, now());

  RETURN TRUE;
END;
'
LANGUAGE plpgsql;
