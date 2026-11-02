CREATE OR REPLACE FUNCTION calculate_customer_discount (
    p_customer_id IN NUMBER
) RETURN NUMBER IS
    v_customer customers%ROWTYPE; -- %ROWTYPE record
    v_discount_rate NUMBER(5,2) := 0.00;

    -- Associative Array for Tier Discounts
    TYPE t_tier_map IS TABLE OF NUMBER INDEX BY VARCHAR2(20);
    v_discounts t_tier_map;
BEGIN
    -- Populate Associative Array
    v_discounts('BRONZE')   := 0.00;
    v_discounts('SILVER')   := 0.05;
    v_discounts('GOLD')     := 0.10;
    v_discounts('PLATINUM') := 0.15;

    -- Retrieve customer details
    SELECT * INTO v_customer
    FROM customers
    WHERE customer_id = p_customer_id;

    -- Fetch discount from collection
    IF v_discounts.EXISTS(v_customer.loyalty_tier) THEN
        v_discount_rate := v_discounts(v_customer.loyalty_tier);
    END IF;

    RETURN v_discount_rate;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20005, 'Customer ID ' || p_customer_id || ' does not exist.');
    WHEN TOO_MANY_ROWS THEN
        RAISE_APPLICATION_ERROR(-20006, 'Multiple records found for Customer ID ' || p_customer_id);
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20007, 'Error in calculate_customer_discount: ' || SQLERRM);
END calculate_customer_discount;
/