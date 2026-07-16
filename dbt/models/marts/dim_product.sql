select
    p.product_name as product_name,
    p.product_size as product_size,
    p.product_class as product_class,
    p.product_color as product_color,
    p.product_style as product_style,
    p.product_weight as product_weight,
    p.product_id as product_id,
    p.product_number as product_number,
    p.product_model_id as product_model_id,
    p.product_safety_stock_level as product_safety_stock_level,
    p.product_days_to_manufacture as product_days_to_manufacture,
    p.product_subcategory_id as product_subcategory_id,
    p.product_subcategory_name as product_subcategory_name,
    p.product_category_id as product_category_id,
    p.product_category_name as product_category_name,
    p.product_sell_end_date as product_sell_end_date
from {{ ref('int_product') }} as p
    