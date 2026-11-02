SET SERVEROUTPUT ON;

BEGIN
    DBMS_OUTPUT.PUT_LINE('==============================================');
    DBMS_OUTPUT.PUT_LINE('        RUNNING ERROR TEST CASES             ');
    DBMS_OUTPUT.PUT_LINE('==============================================');

    -- Test Error 1: Invalid Discount (Non-existent Customer)
    BEGIN
        DBMS_OUTPUT.PUT_LINE('--- Test Error 1: Non-Existent Customer ---');
        DBMS_OUTPUT.PUT_LINE('Discount: ' || calculate_customer_discount(9999));
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Handled Expected Error: ' || SQLERRM);
    END;

    -- Test Error 2: Invalid Price Percentage
    BEGIN
        DBMS_OUTPUT.PUT_LINE('--- Test Error 2: Invalid Price Increase Percentage ---');
        update_product_pricing('Electronics', -15);
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Handled Expected Error: ' || SQLERRM);
    END;

    -- Test Error 3: Non-existent Category
    BEGIN
        DBMS_OUTPUT.PUT_LINE('--- Test Error 3: Non-existent Product Category ---');
        update_product_pricing('NonExistentCategory', 10);
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Handled Expected Error: ' || SQLERRM);
    END;
END;
/