CREATE OR REPLACE FUNCTION imtra_restriction_check(p_action_date IN DATE) RETURN VARCHAR2 AS
  v_day   NUMBER;
  v_is_holiday NUMBER;
BEGIN
  v_day := TO_CHAR(p_action_date, 'D'); -- beware NLS_TERRITORY; better use DY weekday check
  SELECT COUNT(*) INTO v_is_holiday FROM HOLIDAYS WHERE TRUNC(HOLIDAY_DATE) = TRUNC(p_action_date);

  -- Assume week day numbers: 2=Mon ... 6=Fri for many NLS settings; safer:
  IF TO_CHAR(p_action_date,'DY','NLS_DATE_LANGUAGE=ENGLISH') IN ('MON','TUE','WED','THU','FRI') THEN
    RETURN 'DENIED_WEEKDAY';
  ELSIF v_is_holiday > 0 THEN
    RETURN 'DENIED_HOLIDAY';
  ELSE
    RETURN 'ALLOWED';
  END IF;
END imtra_restriction_check;
/