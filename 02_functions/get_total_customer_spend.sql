CREATE OR REPLACE FUNCTION get_total_customer_spend (
    p_customer_id IN NUMBER
) RETURN NUMBER IS
    v_total_spend NUMBER(12,2) := 0;
    v_customer_exists NUMBER := 0;

    -- Explicit Cursor
    CURSOR c_customer_orders IS
        SELECT total_amount
        FROM orders
        WHERE customer_id = p_customer_id
          AND status = 'PROCESSED';

BEGIN
    -- Validate Customer Existence
    SELECT COUNT(*) INTO v_customer_exists
    FROM customers
    WHERE customer_id = p_customer_id;

    IF v_customer_exists = 0 THEN
        RAISE_APPLICATION_ERROR(-20008, 'Customer ID ' || p_customer_id || ' not found.');
    END IF;

    -- Process Explicit Cursor using Cursor FOR Loop
    FOR r_order IN c_customer_orders LOOP
        v_total_spend := v_total_spend + r_order.total_amount;
    END LOOP;

    RETURN v_total_spend;
END get_total_customer_spend;
/