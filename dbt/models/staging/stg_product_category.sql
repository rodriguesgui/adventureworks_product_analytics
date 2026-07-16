select 
    "Name" as product_category_name,
    "ProductCategoryID" as product_category_id,
    "ModifiedDate" as product_category_modified_date
from {{ source('Production', 'ProductCategory') }}