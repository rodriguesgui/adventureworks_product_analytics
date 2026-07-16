select
    s.product_id as product_id,
    s.sales_order_detail_id as sales_order_detail_id,
    s.sales_order_id as sales_order_id,
    s.order_quantity as order_quantity,
    s.unit_price as unit_price,
    s.line_total as line_total,
    s.unit_price_discount as unit_price_discount,
    s.order_date as order_date,
    s.standard_cost as standard_cost,
    s.carrier_tracking_number as carrier_tracking_number,
    s.discount_pct as discount_pct,
    s.description as description,
    COALESCE(s.store_id, -1) as store_id,
    s.category as category,
    {{ net_revenue('s.unit_price', 's.order_quantity', 's.unit_price_discount') }} as net_revenue,
    s.standard_cost * s.order_quantity as total_cost,
    {{ net_revenue('s.unit_price', 's.order_quantity', 's.unit_price_discount') }} - s.standard_cost * s.order_quantity as profit,
    ({{ net_revenue('s.unit_price', 's.order_quantity', 's.unit_price_discount') }} - s.standard_cost * s.order_quantity) 
    / nullif({{ net_revenue('s.unit_price', 's.order_quantity', 's.unit_price_discount') }}, 0) as gross_margin_pct
from {{ ref('int_sales_order_with_cost') }} as s

    