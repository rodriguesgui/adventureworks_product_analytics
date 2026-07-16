select
    "FirstName" as person_first_name,
    "LastName" as person_last_name,
    "PersonType" as person_type,
    "Demographics" as person_demographics,
    "ModifiedDate" as person_modified_date,
    "EmailPromotion" as person_email_promotion,
    "BusinessEntityID" as person_business_entity_id
from {{ source('Person', 'Person') }}
