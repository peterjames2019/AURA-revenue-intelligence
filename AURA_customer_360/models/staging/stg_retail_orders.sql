with source as (
    select * from {{ source('aura_retail_source', 'raw_retail_data') }}
),

renamed as (
    select
        invoice_no as invoice_id,
        stock_code as product_id,
        description as product_description,
        quantity,
        invoice_date as order_date,
        unit_price,
        customer_id,
        country
    from source
    where customer_id is not null
)

select 
    *,
    -- Create a flag for cancelled orders (returns)
    case 
        when invoice_id like 'C%' then True 
        else False 
    end as is_cancelled,
    -- Calculate total line item value
    (quantity * unit_price) as total_order_value
from renamed