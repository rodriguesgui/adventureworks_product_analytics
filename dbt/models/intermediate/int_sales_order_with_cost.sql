with x as (
    select distinct on (product_id)
        product_id,
        product_standard_cost as last_known_standard_cost
    from {{ ref('stg_product_cost_history') }}
    order by product_id, start_date desc
)
select 
    sod.product_id as product_id,
    sod.sales_order_detail_id as sales_order_detail_id,
    sod.order_quantity as order_quantity,
    sod.unit_price as unit_price,
    sod.line_total as line_total,
    sod.special_offer_id as special_offer_id,
    sod.sales_order_id as sales_order_id,
    sod.unit_price_discount as unit_price_discount,
    sod.carrier_tracking_number as carrier_tracking_number,
    soh.order_date as order_date,
    soh.territory_id as territory_id,
    soh.customer_id as customer_id,
    coalesce(pch.product_standard_cost, x.last_known_standard_cost) as standard_cost,
    sso.special_offer_discount_pct as discount_pct,
    sso.special_offer_description as description,
    sso.special_offer_category as category,
    sso.special_offer_type as type,
    sc.customer_store_id as store_id
from
{{ ref('stg_sales_order_detail') }} as sod
    left join {{ ref('stg_sales_order_header') }} as soh
    on sod.sales_order_id = soh.sales_order_id
    left join {{ ref('stg_product_cost_history') }} as pch
    on sod.product_id = pch.product_id
    and soh.order_date >= pch.start_date 
    and soh.order_date <= coalesce(pch.end_date, '9999-12-31'::date)
    left join {{ ref('stg_sales_special_offer') }} as sso
    on sod.special_offer_id = sso.special_offer_id
    left join x
    on sod.product_id = x.product_id
    left join {{ ref('stg_sales_customer') }} as sc
    on soh.customer_id = sc.customer_id