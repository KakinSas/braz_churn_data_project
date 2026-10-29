SELECT 
  TRIM(customers.customer_unique_id) AS unique_id,
  TRIM(customers.customer_city) AS city,
  TRIM(customers.customer_state) AS state,
  customers.customer_zip_code_prefix AS zip_code_prefix
FROM 
  `brazillian-e-commerce-510623.ecommerce_raw.raw_customers` AS customers
LEFT JOIN
  `brazillian-e-commerce-510623.ecommerce_raw.raw_orders` AS orders
ON
  customers.customer_id = orders.customer_id
WHERE customers.customer_zip_code_prefix > 0
QUALIFY ROW_NUMBER() OVER(
  PARTITION BY customers.customer_unique_id
  ORDER BY orders.order_purchase_timestamp DESC
) = 1
ORDER BY
  customers.customer_unique_id