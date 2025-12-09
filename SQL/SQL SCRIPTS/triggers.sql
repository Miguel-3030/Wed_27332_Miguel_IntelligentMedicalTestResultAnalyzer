CREATE OR REPLACE TRIGGER trg_lab_results_before_row
  BEFORE INSERT OR UPDATE ON LAB_RESULTS
  FOR EACH ROW
DECLARE
  v_check VARCHAR2(20);
  v_low  TEST_TYPES.NORMAL_LOW%TYPE;
  v_high TEST_TYPES.NORMAL_HIGH%TYPE;
BEGIN
  -- Restriction check (use RESULT_AT if present, otherwise now)
  v_check := imtra_restriction_check(:NEW.RESULT_AT);

  IF v_check LIKE 'DENIED%' THEN
    -- Audit the denied attempt (we record a string; do not commit)
    imtra_audit_log('DENIED_ATTEMPT','LAB_RESULTS', NVL(TO_CHAR(:NEW.RESULT_ID), '(new)'), SYS_CONTEXT('USERENV','SESSION_USER'),
                    'Attempt to DML on restricted day: ' || v_check);
    RAISE_APPLICATION_ERROR(-20001, 'Operations on LAB_RESULTS are not permitted on weekdays or configured holidays: ' || v_check);
  END IF;

  -- Set interpretation based on normal range if a value exists
  IF :NEW.RESULT_VALUE IS NOT NULL THEN
    BEGIN
      SELECT NORMAL_LOW, NORMAL_HIGH INTO v_low, v_high
      FROM TEST_TYPES
      WHERE TEST_TYPE_ID = :NEW.TEST_TYPE_ID;

      IF v_low IS NOT NULL AND v_high IS NOT NULL THEN
        IF :NEW.RESULT_VALUE < v_low OR :NEW.RESULT_VALUE > v_high THEN
          :NEW.INTERPRETATION := 'Abnormal';
        ELSE
          :NEW.INTERPRETATION := 'Normal';
        END IF;
      ELSE
        :NEW.INTERPRETATION := 'Unknown';
      END IF;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        :NEW.INTERPRETATION := 'Unknown';
      WHEN OTHERS THEN
        :NEW.INTERPRETATION := 'Unknown';
    END;
  END IF;
END trg_lab_results_before_row;
/

---===================================================

CREATE OR REPLACE TRIGGER trg_alert_insert
AFTER INSERT ON ALERTS
FOR EACH ROW
BEGIN
    INSERT INTO ALERT_NOTIFICATIONS(ALERT_ID, SENT_TO, STATUS)
    SELECT :NEW.ALERT_ID, USER_ID, 'PENDING'
    FROM USERS
    WHERE ROLE = 'PHYSICIAN';
END;
/


-- Test 1
INSERT INTO ALERTS (RESULT_ID, ALERT_TYPE, ALERT_SEVERITY, DESCRIPTION)
VALUES (1, 'Abnormal trend', 'WARN', 'Test trigger 1');

-- Test 2
INSERT INTO ALERTS (RESULT_ID, ALERT_TYPE, ALERT_SEVERITY, DESCRIPTION)
VALUES (2, 'Critical value', 'CRITICAL', 'Test trigger 2');

-- Test 3
INSERT INTO ALERTS (RESULT_ID, ALERT_TYPE, ALERT_SEVERITY, DESCRIPTION)
VALUES (3, 'Abnormal trend', 'WARN', 'Test trigger 3');

-- Check if notifications were created
SELECT * FROM ALERT_NOTIFICATIONS;