# Step 1: database setup

Same pattern as Project 5. The 8 Olist CSVs are loaded into a local MySQL
database called `olist`, one table per file, using pandas' `to_sql` rather
than a `LOAD DATA INFILE` script (there was no ready-made `.sql` dump for
this dataset, only raw CSVs, so a short Python loader was the simplest
route). The `analyst` user (read-only, same as Project 5) has `SELECT` on
this database too.

Tables: `customers`, `orders`, `order_items`, `order_payments`,
`order_reviews`, `products`, `sellers`, `product_category_translation`.

Connection string (same shape as Project 5, different database name):

```
mysql+pymysql://analyst:analyst@localhost:3306/olist
```
