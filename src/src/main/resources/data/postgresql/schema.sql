CREATE OR REPLACE FUNCTION getnexttrackid(IN i_deviceid UUID)
    RETURNS TABLE(
      id                       UUID
    , created_at               TIMESTAMP
    , updated_at               TIMESTAMP
    , version                  INTEGER
    , local_device_path_upload CHARACTER VARYING
    , path                     CHARACTER VARYING
    , upload_user_id           UUID
    ) AS
'
BEGIN
    RETURN QUERY
    SELECT *
    FROM tracks
    ORDER BY RANDOM()
    LIMIT 1;
END;
'
LANGUAGE plpgsql;
