CREATE OR REPLACE PROCEDURE process_bulk_orders (
    p_status_filter IN VARCHAR2
) IS
    -- User-defined record type
    TYPE t_order_summary IS RECORD (
        order_id     orders.order_id%TYPE,
        customer_id  orders.customer_id%TYPE,
        total_amount orders.total_amount%TYPE
    );

    -- Collection type (Nested Table)
    TYPE t_order_list IS TABLE OF t_order_summary;
    v_pending_orders t_order_list;

    -- Explicit Cursor
    CURSOR c_orders IS
        SELECT order_id, customer_id, total_amount
        FROM orders
        WHERE status = p_status_filter;

    -- Bulk DML exception capture
    bulk_errors EXCEPTION;
    PRAGMA EXCEPTION_INIT(bulk_errors, -24381);
    v_error_count NUMBER;

BEGIN
    -- Open, Bulk Fetch into Collection
    OPEN c_orders;
    FETCH c_orders BULK COLLECT INTO v_pending_orders;
    CLOSE c_orders;

    IF v_pending_orders.COUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('No orders found matching status: ' || p_status_filter);
        RETURN;
    END IF;

    DBMS_OUTPUT.PUT_LINE('Processing ' || v_pending_orders.COUNT || ' order(s)...');

    -- BULK Processing with FORALL and SAVE EXCEPTIONS
    FORALL i IN 1..v_pending_orders.COUNT SAVE EXCEPTIONS
        UPDATE orders
        SET status = 'PROCESSED'
        WHERE order_id = v_pending_orders(i).order_id;

    DBMS_OUTPUT.PUT_LINE('Bulk processing completed successfully.');

EXCEPTION
    WHEN bulk_errors THEN
        v_error_count := SQL%BULK_EXCEPTIONS.COUNT;
        DBMS_OUTPUT.PUT_LINE('Bulk update completed with ' || v_error_count || ' error(s).');
        FOR i IN 1..v_error_count LOOP
            DBMS_OUTPUT.PUT_LINE('Error #' || i || ' at index ' || 
                                 SQL%BULK_EXCEPTIONS(i).ERROR_INDEX || 
                                 ': ' || SQLERRM(-SQL%BULK_EXCEPTIONS(i).ERROR_CODE));
        END LOOP;
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20001, 'Unexpected error in process_bulk_orders: ' || SQLERRM);
END process_bulk_orders;
/