CREATE OR REPLACE PROCEDURE update_product_pricing (
    p_category         IN VARCHAR2,
    p_percentage_increase IN NUMBER
) IS
    e_invalid_percentage EXCEPTION;
    e_no_products_found EXCEPTION;
BEGIN
    -- Validate parameter
    IF p_percentage_increase <= 0 OR p_percentage_increase > 100 THEN
        RAISE e_invalid_percentage;
    END IF;

    -- Implicit Cursor operation
    UPDATE products
    SET unit_price = unit_price + (unit_price * (p_percentage_increase / 100))
    WHERE category = p_category;

    -- Demonstrate Implicit Cursor Attributes
    IF SQL%NOTFOUND THEN
        RAISE e_no_products_found;
    ELSE
        DBMS_OUTPUT.PUT_LINE('SQL%FOUND: True');
        DBMS_OUTPUT.PUT_LINE('SQL%ROWCOUNT: Updated ' || SQL%ROWCOUNT || ' products in category ' || p_category);
    END IF;

EXCEPTION
    WHEN e_invalid_percentage THEN
        RAISE_APPLICATION_ERROR(-20002, 'Percentage increase must be between 0.01 and 100.');
    WHEN e_no_products_found THEN
        RAISE_APPLICATION_ERROR(-20003, 'No products found under category: ' || p_category);
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20004, 'Error updating product prices: ' || SQLERRM);
END update_product_pricing;
/