CREATE OR REPLACE PROCEDURE loop_test_2_calls()
LANGUAGE plpgsql
AS $$
DECLARE
    v_start_date DATE;
    v_prev_start_date DATE := '2025-01-28';
    v_loop_start DATE := '2025-02-06';
    v_loop_end DATE := '2025-07-03';
    v_interval INTERVAL := '7 days';
    v_param2_date DATE;
BEGIN
    FOR v_start_date IN SELECT generate_series(
                                v_loop_start,
                                v_loop_end,
                                v_interval
                            )::DATE
    LOOP
        v_param2_date := v_start_date + interval '6 days';
        CALL test_2(v_start_date, v_param2_date::timestamp, v_prev_start_date);
        v_prev_start_date := v_start_date;
    END LOOP;
END;
$$;

-- CALL loop_test_2_calls();

CREATE OR REPLACE PROCEDURE loop_test_2_calls()
RETURNS VARCHAR 
LANGUAGE SQL
AS
$$
DECLARE
    current_start_date DATE;
    previous_start_date DATE DEFAULT '2025-01-28';
    loop_start DATE DEFAULT '2025-02-06';
    loop_end DATE DEFAULT '2025-07-03';
    interval_days INTEGER DEFAULT 7;
    param2_date DATE;
BEGIN
    current_start_date := loop_start;

    WHILE (current_start_date <= loop_end) DO
        param2_date := DATEADD(day, 6, current_start_date);
        CALL test_2(:current_start_date, :param2_date::TIMESTAMP, :previous_start_date);
        previous_start_date := current_start_date;
        current_start_date := DATEADD(day, interval_days, current_start_date);
    END WHILE;

    RETURN 'Loop completed.';
END;
$$;

-- CALL loop_test_2_calls();