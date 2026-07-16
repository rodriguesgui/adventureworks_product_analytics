select 
    "Name" as product_subcategory_name,
    "ProductCategoryID" as product_category_id,
    "ModifiedDate" as product_subcategory_modified_date,
    "ProductSubcategoryID" as product_subcategory_id
from {{ source('Production', 'ProductSubcategory') }}
