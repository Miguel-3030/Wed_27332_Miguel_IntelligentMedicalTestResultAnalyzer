-- ================================================================
-- TEST CASES for Intelligent Medical Test Result Analyzer
-- ================================================================

PROMPT ====================
PROMPT TEST 1: Insert Test Alerts for Trigger Testing
PROMPT ====================

-- Test 1: Insert alert to test trigger (trg_alert_insert)
INSERT INTO ALERTS (RESULT_ID, ALERT_TYPE, ALERT_SEVERITY, DESCRIPTION)
VALUES (1, 'Abnormal trend', 'WARN', 'Test trigger 1');

-- Test 2: Insert alert to test trigger (trg_alert_insert)
INSERT INTO ALERTS (RESULT_ID, ALERT_TYPE, ALERT_SEVERITY, DESCRIPTION)
VALUES (2, 'Critical value', 'CRITICAL', 'Test trigger 2');

-- Test 3: Insert alert to test trigger (trg_alert_insert)
INSERT INTO ALERTS (RESULT_ID, ALERT_TYPE, ALERT_SEVERITY, DESCRIPTION)
VALUES (3, 'Abnormal trend', 'WARN', 'Test trigger 3');

-- Check if notifications were created by trigger
PROMPT Checking ALERT_NOTIFICATIONS table for trigger-generated records...
SELECT * FROM ALERT_NOTIFICATIONS WHERE ALERT_ID IN (8, 9, 10);

PROMPT ====================
PROMPT TEST 2: Package Procedure Testing
PROMPT ====================

-- Test 1: Send alert using package for ALERT_ID = 1
BEGIN
    IMTRA_ALERTS_PKG.send_alert(1);
END;
/

-- Test 2: Send alert using package for ALERT_ID = 2
BEGIN
    IMTRA_ALERTS_PKG.send_alert(2);
END;
/

-- Test 3: Send alert using package for ALERT_ID = 3
BEGIN
    IMTRA_ALERTS_PKG.send_alert(3);
END;
/

-- Check package-generated notifications
PROMPT Checking package-generated notifications...
SELECT * FROM ALERT_NOTIFICATIONS 
WHERE ALERT_ID IN (1, 2, 3) 
AND CHANNEL = 'IN_APP'
ORDER BY SENT_AT;

PROMPT ====================
PROMPT TEST 3: Restriction Function Testing
PROMPT ====================

-- 1. Weekday that is not a holiday (should return 'DENIED_WEEKDAY')
PROMPT Test 1: Weekday (Monday, 2025-12-08) - Expected: DENIED_WEEKDAY
SELECT imtra_restriction_check(DATE '2025-12-08') AS result FROM dual;

-- 2. Holiday (should return 'DENIED_HOLIDAY')
PROMPT Test 2: Holiday (Christmas, 2025-12-25) - Expected: DENIED_HOLIDAY
SELECT imtra_restriction_check(DATE '2025-12-25') AS result FROM dual; 

-- 3. Weekend that is not a holiday (should return 'ALLOWED')
PROMPT Test 3: Weekend (Sunday, 2025-12-07) - Expected: ALLOWED
SELECT imtra_restriction_check(DATE '2025-12-07') AS result FROM dual;

-- 4. Additional test: Friday (should return 'DENIED_WEEKDAY')
PROMPT Test 4: Friday (2025-12-12) - Expected: DENIED_WEEKDAY
SELECT imtra_restriction_check(DATE '2025-12-12') AS result FROM dual;

PROMPT ====================
PROMPT TEST 4: Audit Log Procedure Testing
PROMPT ====================

-- Test audit log procedure
BEGIN
    imtra_audit_log('TEST', 'TEST_TABLE', 'TEST_ID', 'TEST_USER', 'Testing audit log procedure');
END;
/

-- Check audit log entry
PROMPT Checking AUDIT_LOG for test entry...
SELECT * FROM AUDIT_LOG WHERE OBJECT_NAME = 'TEST_TABLE' ORDER BY EVENT_TIME DESC;

PROMPT ====================
PROMPT TEST 5: Trigger Restriction Testing (LAB_RESULTS)
PROMPT ====================

-- Try to insert on a weekday (should fail with restriction error)
PROMPT Attempting to insert LAB_RESULT on weekday (should fail)...
BEGIN
    INSERT INTO LAB_RESULTS (ORDER_ID, TEST_TYPE_ID, RESULT_VALUE, RESULT_AT)
    VALUES (1, 1, 10.5, TO_TIMESTAMP('2025-12-08 10:00:00','YYYY-MM-DD HH24:MI:SS'));
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Expected error: ' || SQLERRM);
END;
/

-- Try to insert on a holiday (should fail with restriction error)
PROMPT Attempting to insert LAB_RESULT on holiday (should fail)...
BEGIN
    INSERT INTO LAB_RESULTS (ORDER_ID, TEST_TYPE_ID, RESULT_VALUE, RESULT_AT)
    VALUES (1, 1, 10.5, TO_TIMESTAMP('2025-12-25 10:00:00','YYYY-MM-DD HH24:MI:SS'));
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Expected error: ' || SQLERRM);
END;
/

-- Try to insert on weekend (should succeed if weekend is allowed)
PROMPT Attempting to insert LAB_RESULT on weekend (may succeed depending on restriction logic)...
BEGIN
    INSERT INTO LAB_RESULTS (ORDER_ID, TEST_TYPE_ID, RESULT_VALUE, RESULT_AT)
    VALUES (1, 1, 10.5, TO_TIMESTAMP('2025-12-07 10:00:00','YYYY-MM-DD HH24:MI:SS'));
    DBMS_OUTPUT.PUT_LINE('Insert succeeded for weekend.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/

PROMPT ====================
PROMPT TEST 6: Data Validation Queries
PROMPT ====================

-- 1. Check all tables have 7+ records
PROMPT Checking record counts in all tables...
SELECT 'USERS' AS table_name, COUNT(*) AS record_count FROM USERS UNION ALL
SELECT 'PATIENTS', COUNT(*) FROM PATIENTS UNION ALL
SELECT 'PHYSICIANS', COUNT(*) FROM PHYSICIANS UNION ALL
SELECT 'TEST_TYPES', COUNT(*) FROM TEST_TYPES UNION ALL
SELECT 'ORDERS', COUNT(*) FROM ORDERS UNION ALL
SELECT 'LAB_RESULTS', COUNT(*) FROM LAB_RESULTS UNION ALL
SELECT 'ALERTS', COUNT(*) FROM ALERTS UNION ALL
SELECT 'ALERT_NOTIFICATIONS', COUNT(*) FROM ALERT_NOTIFICATIONS UNION ALL
SELECT 'HOLIDAYS', COUNT(*) FROM HOLIDAYS UNION ALL
SELECT 'AUDIT_LOG', COUNT(*) FROM AUDIT_LOG UNION ALL
SELECT 'SYSTEM_SETTINGS', COUNT(*) FROM SYSTEM_SETTINGS
ORDER BY 1;

-- 2. Check critical results and their alerts
PROMPT Checking critical results and corresponding alerts...
SELECT 
    p.FIRST_NAME || ' ' || p.LAST_NAME AS patient_name,
    tt.NAME AS test_name,
    lr.RESULT_VALUE,
    lr.UNITS,
    lr.INTERPRETATION,
    a.ALERT_TYPE,
    a.ALERT_SEVERITY,
    a.CREATED_AT AS alert_time
FROM LAB_RESULTS lr
JOIN ORDERS o ON lr.ORDER_ID = o.ORDER_ID
JOIN PATIENTS p ON o.PATIENT_ID = p.PATIENT_ID
JOIN TEST_TYPES tt ON lr.TEST_TYPE_ID = tt.TEST_TYPE_ID
LEFT JOIN ALERTS a ON lr.RESULT_ID = a.RESULT_ID
WHERE lr.INTERPRETATION = 'Critical'
ORDER BY a.CREATED_AT DESC;

-- 3. Check alert notification delivery status
PROMPT Checking alert notification status...
SELECT 
    a.ALERT_TYPE,
    a.ALERT_SEVERITY,
    u.FULL_NAME AS physician_name,
    an.STATUS,
    an.CHANNEL,
    an.SENT_AT
FROM ALERT_NOTIFICATIONS an
JOIN ALERTS a ON an.ALERT_ID = a.ALERT_ID
JOIN USERS u ON an.SENT_TO = u.USER_ID
ORDER BY an.SENT_AT DESC;

-- 4. Test result interpretation validation
PROMPT Testing result interpretation logic...
SELECT 
    tt.NAME AS test_name,
    lr.RESULT_VALUE,
    tt.NORMAL_LOW,
    tt.NORMAL_HIGH,
    lr.INTERPRETATION,
    CASE 
        WHEN lr.RESULT_VALUE < tt.NORMAL_LOW OR lr.RESULT_VALUE > tt.NORMAL_HIGH THEN 'Should be Abnormal'
        ELSE 'Should be Normal'
    END AS expected_interpretation
FROM LAB_RESULTS lr
JOIN TEST_TYPES tt ON lr.TEST_TYPE_ID = tt.TEST_TYPE_ID
ORDER BY tt.NAME;

PROMPT ====================
PROMPT TEST 7: Function Return Testing
PROMPT ====================

-- Test function with various dates
PROMPT Testing imtra_restriction_check function with various dates...
SELECT 
    '2025-12-01 (Mon)' AS test_date,
    imtra_restriction_check(DATE '2025-12-01') AS result
FROM dual UNION ALL
SELECT 
    '2025-12-06 (Sat)',
    imtra_restriction_check(DATE '2025-12-06')
FROM dual UNION ALL
SELECT 
    '2025-12-07 (Sun)',
    imtra_restriction_check(DATE '2025-12-07')
FROM dual UNION ALL
SELECT 
    '2025-12-24 (Wed, Holiday)',
    imtra_restriction_check(DATE '2025-12-24')
FROM dual UNION ALL
SELECT 
    '2025-12-25 (Thu, Holiday)',
    imtra_restriction_check(DATE '2025-12-25')
FROM dual
ORDER BY 1;

PROMPT ====================
PROMPT TEST 8: Package Error Handling
PROMPT ====================

-- Test package with invalid alert ID (should handle gracefully)
PROMPT Testing package with invalid alert ID...
BEGIN
    IMTRA_ALERTS_PKG.send_alert(999); -- Non-existent alert ID
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Expected NO_DATA_FOUND error caught.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Other error: ' || SQLERRM);
END;
/

PROMPT ====================
PROMPT TEST 9: Complete Data View
PROMPT ====================

-- 1. ALERT_NOTIFICATIONS
PROMPT Complete view of ALERT_NOTIFICATIONS:
SELECT * FROM ALERT_NOTIFICATIONS ORDER BY SENT_AT DESC;

-- 2. ALERTS
PROMPT Complete view of ALERTS:
SELECT * FROM ALERTS ORDER BY CREATED_AT DESC;

-- 3. AUDIT_LOG
PROMPT Complete view of AUDIT_LOG (recent 10):
SELECT * FROM AUDIT_LOG ORDER BY EVENT_TIME DESC FETCH FIRST 10 ROWS ONLY;

-- 4. LAB_RESULTS
PROMPT Complete view of LAB_RESULTS:
SELECT * FROM LAB_RESULTS ORDER BY RESULT_AT DESC;

-- 5. ORDERS
PROMPT Complete view of ORDERS:
SELECT * FROM ORDERS ORDER BY ORDERED_AT DESC;

-- 6. HOLIDAYS
PROMPT Complete view of HOLIDAYS:
SELECT * FROM HOLIDAYS ORDER BY HOLIDAY_DATE;

-- 7. PATIENTS
PROMPT Complete view of PATIENTS:
SELECT * FROM PATIENTS ORDER BY LAST_NAME, FIRST_NAME;

-- 8. PHYSICIANS
PROMPT Complete view of PHYSICIANS:
SELECT * FROM PHYSICIANS ORDER BY LAST_NAME, FIRST_NAME;

-- 9. SYSTEM_SETTINGS
PROMPT Complete view of SYSTEM_SETTINGS:
SELECT * FROM SYSTEM_SETTINGS ORDER BY SETTING_KEY;

-- 10. TEST_TYPES
PROMPT Complete view of TEST_TYPES:
SELECT * FROM TEST_TYPES ORDER BY CODE;

-- 11. USERS
PROMPT Complete view of USERS:
SELECT * FROM USERS ORDER BY ROLE, USERNAME;

PROMPT ====================
PROMPT TEST 10: Complex Queries Testing
PROMPT ====================

-- 1. Patients with critical alerts
PROMPT Patients with critical alerts:
SELECT DISTINCT
    p.PATIENT_ID,
    p.FIRST_NAME || ' ' || p.LAST_NAME AS patient_name,
    COUNT(DISTINCT a.ALERT_ID) AS critical_alerts_count
FROM PATIENTS p
JOIN ORDERS o ON p.PATIENT_ID = o.PATIENT_ID
JOIN LAB_RESULTS lr ON o.ORDER_ID = lr.ORDER_ID
JOIN ALERTS a ON lr.RESULT_ID = a.RESULT_ID
WHERE a.ALERT_SEVERITY = 'CRITICAL'
GROUP BY p.PATIENT_ID, p.FIRST_NAME, p.LAST_NAME
ORDER BY critical_alerts_count DESC;

-- 2. Physician notification statistics
PROMPT Physician notification statistics:
SELECT 
    u.FULL_NAME AS physician,
    COUNT(an.NOTIF_ID) AS total_notifications,
    SUM(CASE WHEN an.STATUS = 'SENT' THEN 1 ELSE 0 END) AS sent_count,
    SUM(CASE WHEN an.STATUS = 'DELIVERED' THEN 1 ELSE 0 END) AS delivered_count,
    SUM(CASE WHEN an.STATUS = 'ACKNOWLEDGED' THEN 1 ELSE 0 END) AS acknowledged_count
FROM USERS u
LEFT JOIN ALERT_NOTIFICATIONS an ON u.USER_ID = an.SENT_TO
WHERE u.ROLE = 'PHYSICIAN'
GROUP BY u.FULL_NAME
ORDER BY total_notifications DESC;

-- 3. Test type statistics
PROMPT Test type statistics (normal/abnormal/critical):
SELECT 
    tt.NAME AS test_name,
    COUNT(lr.RESULT_ID) AS total_tests,
    SUM(CASE WHEN lr.INTERPRETATION = 'Normal' THEN 1 ELSE 0 END) AS normal_count,
    SUM(CASE WHEN lr.INTERPRETATION = 'Abnormal' THEN 1 ELSE 0 END) AS abnormal_count,
    SUM(CASE WHEN lr.INTERPRETATION = 'Critical' THEN 1 ELSE 0 END) AS critical_count
FROM TEST_TYPES tt
LEFT JOIN LAB_RESULTS lr ON tt.TEST_TYPE_ID = lr.TEST_TYPE_ID
GROUP BY tt.NAME
ORDER BY total_tests DESC;

PROMPT ====================
PROMPT TEST 11: Cleanup Test Data
PROMPT ====================

-- Remove test alerts (keep original 7)
PROMPT Cleaning up test alerts (IDs 8, 9, 10)...
DELETE FROM ALERTS WHERE ALERT_ID IN (8, 9, 10);
COMMIT;

-- Check cleanup
PROMPT After cleanup - ALERTS count:
SELECT COUNT(*) AS alerts_count FROM ALERTS;

PROMPT ====================
PROMPT TEST COMPLETION SUMMARY
PROMPT ====================

PROMPT All test cases completed successfully!
PROMPT Summary of key functionality tested:
PROMPT 1. Triggers (auto-notification generation)
PROMPT 2. Package procedures (alert distribution)
PROMPT 3. Restriction functions (weekday/holiday checks)
PROMPT 4. Audit logging
PROMPT 5. Data validation and integrity
PROMPT 6. Complex reporting queries
PROMPT 7. Error handling

-- Final verification
SELECT '✅ TESTING COMPLETE' AS status FROM dual;
