select
    "Type" as special_offer_type,
    "MaxQty" as special_offer_max_qty,
    "MinQty" as special_offer_min_qty,
    "EndDate" as special_offer_end_date,
    "Category" as special_offer_category,
    "StartDate" as special_offer_start_date,
    "Description" as special_offer_description,
    "DiscountPct" as special_offer_discount_pct,
    "ModifiedDate" as special_offer_modified_date,
    "SpecialOfferID" as special_offer_id
from {{ source('Sales', 'SpecialOffer') }}
