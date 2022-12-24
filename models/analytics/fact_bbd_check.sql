SELECT
  product_key
  ,unit_sales_epos
  ,week_num
  ,month_num
  ,retailer_epos
  ,COALESCE(retailer_ea,'Error') as retailer_ea
  ,unit_sales_ea
FROM
  {{ref('stg_fact_bbd_order_line_epos')}} as fact_epos
LEFT JOIN
  {{ref('stg_fact_bbd_order_line_ea')}} as fact_ea
USING (product_key,week_num,month_num)