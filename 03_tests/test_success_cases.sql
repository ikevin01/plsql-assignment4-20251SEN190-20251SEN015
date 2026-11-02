SET SERVEROUTPUT ON;

BEGIN
    DBMS_OUTPUT.PUT_LINE('==============================================');
    DBMS_OUTPUT.PUT_LINE('       RUNNING SUCCESSFUL TEST CASES         ');
    DBMS_OUTPUT.PUT_LINE('==============================================');

    -- Test 1: Function calculate_customer_discount
    DBMS_OUTPUT.PUT_LINE('--- Test 1: Calculate Customer Discount ---');
    DBMS_OUTPUT.PUT_LINE('Discount for Customer 1 (GOLD): ' || calculate_customer_discount(1) * 100 || '%');
    DBMS_OUTPUT.PUT_LINE('Discount for Customer 4 (PLATINUM): ' || calculate_customer_discount(4) * 100 || '%');

    -- Test 2: Procedure update_product_pricing
    DBMS_OUTPUT.PUT_LINE('--- Test 2: Update Product Pricing ---');
    update_product_pricing('Electronics', 10);

    -- Test 3: Procedure process_bulk_orders
    DBMS_OUTPUT.PUT_LINE('--- Test 3: Process Bulk Orders ---');
    process_bulk_orders('PENDING');

    -- Test 4: Function get_total_customer_spend
    DBMS_OUTPUT.PUT_LINE('--- Test 4: Get Total Customer Spend ---');
    DBMS_OUTPUT.PUT_LINE('Total Spend for Customer 1: $' || get_total_customer_spend(1));

    COMMIT;
END;
/