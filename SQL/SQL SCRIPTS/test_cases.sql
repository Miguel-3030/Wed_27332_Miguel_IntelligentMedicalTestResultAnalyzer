-- Test 1: Send alert for ALERT_ID = 1
BEGIN
    IMTRA_ALERTS_PKG.send_alert(1);
END;
/

-- Test 2: Send alert for ALERT_ID = 2
BEGIN
    IMTRA_ALERTS_PKG.send_alert(2);
END;
/

-- Test 3: Send alert for ALERT_ID = 3
BEGIN
    IMTRA_ALERTS_PKG.send_alert(3);
END;
/