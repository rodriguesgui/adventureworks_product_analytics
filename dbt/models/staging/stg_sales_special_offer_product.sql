select
    "ProductID" as product_id,
    "ModifiedDate" as product_modified_date,
    "SpecialOfferID" as product_special_offer_id
from {{ source('Sales', 'SpecialOfferProduct') }}
