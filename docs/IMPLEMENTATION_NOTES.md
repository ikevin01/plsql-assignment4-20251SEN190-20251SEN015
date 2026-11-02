# Implementation & Performance Analysis

## Concept Mapping Matrix

| Requirement | Implementation File | Explanation |
| :--- | :--- | :--- |
| **User-Defined Record** | `01_procedures/process_bulk_orders.sql` | `t_order_summary` stores selected order attributes. |
| **%ROWTYPE Record** | `02_functions/calculate_customer_discount.sql` | `v_customer customers%ROWTYPE` fetches entire row structure dynamically. |
| **Nested Table Collection** | `01_procedures/process_bulk_orders.sql` | `t_order_list` stores multiple `t_order_summary` records. |
| **Associative Array** | `02_functions/calculate_customer_discount.sql` | `t_tier_map` maps tier string keys (`GOLD`) to discount rates. |
| **Implicit Cursor Attributes** | `01_procedures/update_product_pricing.sql` | Checks `SQL%FOUND`, `SQL%NOTFOUND`, and `SQL%ROWCOUNT`. |
| **Explicit Cursor** | `01_procedures/process_bulk_orders.sql`, `02_functions/get_total_customer_spend.sql` | Cursors declared and processed via `BULK COLLECT` and Cursor `FOR` loop. |
| **Bulk Processing** | `01_procedures/process_bulk_orders.sql` | `BULK COLLECT INTO` and `FORALL ... SAVE EXCEPTIONS`. |
| **Exception Handling** | All Procedures & Functions | Handled `NO_DATA_FOUND`, `TOO_MANY_ROWS`, user-defined exceptions, and `RAISE_APPLICATION_ERROR`. |

---

## Bulk Processing Performance Analysis

### Context
In traditional PL/SQL processing, executing DML statements inside standard loops causes context switching between the **PL/SQL Engine** and the **SQL Engine** for every single row (row-by-row / "slow-by-slow" processing).

### Performance Optimization
In `process_bulk_orders.sql`:
1. `BULK COLLECT` fetches all candidate order rows from the SQL engine into memory array buffers in a single context switch.
2. `FORALL` sends array-bound variables back to the SQL engine in a single batch DML execution rather than executing $N$ distinct SQL statements.

### Benchmark Impact
When updating batch volumes (e.g., 100,000 orders):
* **Row-by-Row (`LOOP ... UPDATE ... END LOOP`):** Requires 100,000 SQL context switches $\approx$ High CPU execution time and undo/redo log overhead.
* **Bulk Processing (`BULK COLLECT + FORALL`):** Performs 2 context switches $\approx$ Up to **10x–20x execution time reduction**.