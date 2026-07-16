select
    p.product_name,
    p.product_size,
    p.product_class,
    p.product_color,
    p.product_style,
    p.product_weight,
    p.product_make_flag,
    p.product_list_price,
    p.product_id,
    p.product_line,
    p.product_sell_end_date,
    p.product_modified_date,
    p.product_reorder_point,
    p.product_standard_cost,
    p.product_number,
    p.product_sell_start_date,
    p.product_model_id,
    p.product_discontinued_date,
    p.product_safety_stock_level,
    p.product_days_to_manufacture,
    p.product_finished_goods_flag,
    p.product_size_unit_measure_code,
    p.product_weight_unit_measure_code,
    ps.product_subcategory_name as product_subcategory_name,
    ps.product_subcategory_id as product_subcategory_id,
    pc.product_category_name as product_category_name,
    pc.product_category_id as product_category_id
from
{{ ref('stg_product') }} as p
    left join {{ ref('stg_product_subcategory') }} as  ps
        on p.product_subcategory_id = ps.product_subcategory_id
    left join {{ ref('stg_product_category') }} as pc
        on ps.product_category_id = pc.product_category_id
    