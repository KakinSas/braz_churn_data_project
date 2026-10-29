SELECT 
  orders.order_id,
  customers.customer_unique_id,
  orders.order_status,
  orders.order_purchase_timestamp,
  orders.order_estimated_delivery_date AS estimated_delivery_date,
  orders.order_delivered_customer_date AS real_delivery_date,
  reviews.average_review_score,
  order_items.item_count,
  payments.total_payment_value,
  order_items.total_freight_value

FROM 
  `brazillian-e-commerce-510623.ecommerce_raw.raw_orders` AS orders

LEFT JOIN (
  SELECT
    order_id,
    SUM(payment_value) AS total_payment_value
  FROM
    `brazillian-e-commerce-510623.ecommerce_raw.raw_payments`
  GROUP BY order_id
) AS payments
  ON orders.order_id = payments.order_id

LEFT JOIN (
  SELECT
    order_id,
    AVG(review_score) AS average_review_score
  FROM
    `brazillian-e-commerce-510623.ecommerce_raw.raw_reviews`
  GROUP BY order_id
) AS reviews
  ON orders.order_id = reviews.order_id

LEFT JOIN `brazillian-e-commerce-510623.ecommerce_raw.raw_customers` AS customers
  ON orders.customer_id = customers.customer_id

LEFT JOIN (
  SELECT
    order_id,
    SUM(freight_value) as total_freight_value,
    COUNT(*) AS item_count
  FROM `brazillian-e-commerce-510623.ecommerce_raw.raw_order_items`
  GROUP BY order_id
) AS order_items
  ON orders.order_id = order_items.order_id

WHERE orders.order_status NOT IN ('canceled', 'unavailable', 'created')