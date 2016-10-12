CREATE OR REPLACE FUNCTION public.random_track(
  IN user_id VARCHAR)
  RETURNS TABLE(
    id                       CHARACTER VARYING
  , created_at               TIMESTAMP
  , updated_at               TIMESTAMP
  , version                  INTEGER
  , local_device_path_upload CHARACTER VARYING
  , path                     CHARACTER VARYING
  , upload_user_id           CHARACTER VARYING
  ) AS
'
BEGIN
  RETURN QUERY
  SELECT *
  FROM tracks
  WHERE tracks.upload_user_id = user_id
  ORDER BY RANDOM()
  LIMIT 1;
END;
'
LANGUAGE plpgsql;
