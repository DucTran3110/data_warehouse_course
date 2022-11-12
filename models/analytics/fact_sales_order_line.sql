SELECT
  CAST(order_line_id AS INTEGER) as sales_order_line_key,
  CAST(quantity AS INTEGER) as quantity,
  CAST(unit_price AS NUMERIC) as unit_price,
  CAST(quantity*unit_price AS NUMERIC) as gross_amount,
  CAST(stock_item_id AS INTEGER) as product_key
FROM
  `vit-lam-data.wide_world_importers.sales__order_lines`
  