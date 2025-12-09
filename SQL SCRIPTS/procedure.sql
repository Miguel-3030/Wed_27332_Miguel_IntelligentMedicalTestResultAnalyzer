CREATE OR REPLACE PROCEDURE imtra_audit_log(
  p_event_type  IN VARCHAR2,
  p_object      IN VARCHAR2,
  p_object_id   IN VARCHAR2,
  p_user        IN VARCHAR2,
  p_details     IN VARCHAR2
) AS
BEGIN
  INSERT INTO AUDIT_LOG(EVENT_TYPE, OBJECT_NAME, OBJECT_ID, USER_NAME, EVENT_TIME, DETAILS)
  VALUES (p_event_type, p_object, p_object_id, p_user, SYSDATE, SUBSTR(p_details,1,4000));
  COMMIT;
EXCEPTION
  WHEN OTHERS THEN
    NULL; -- avoid raising during audit
END imtra_audit_log;
/