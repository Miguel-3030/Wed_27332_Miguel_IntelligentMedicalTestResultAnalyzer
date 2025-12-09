CREATE OR REPLACE PACKAGE BODY imtra_alerts_pkg AS

  PROCEDURE send_alert(p_alert_id IN NUMBER) IS
    v_alert ALERTS%ROWTYPE;

    CURSOR c_recipients IS
      SELECT USER_ID
      FROM USERS
      WHERE ROLE = 'PHYSICIAN'
        AND IS_ACTIVE = 'Y';
  BEGIN
    -- Load alert information
    SELECT *
    INTO v_alert
    FROM ALERTS
    WHERE ALERT_ID = p_alert_id;

    -- Insert a notification for each physician
    FOR rec IN c_recipients LOOP
      INSERT INTO ALERT_NOTIFICATIONS (
        ALERT_ID,
        SENT_TO,
        SENT_AT,
        STATUS,
        CHANNEL
      ) VALUES (
        p_alert_id,
        rec.USER_ID,
        SYSTIMESTAMP,
        'SENT',
        'IN_APP'
      );
    END LOOP;

    COMMIT;
  END send_alert;

END imtra_alerts_pkg;
/