with source as (
    select * from {{ source('aura_retail_source', 'crm_support_tickets') }}
),

renamed as (
    select
        ticket_id,
        customer_id,
        issue_type,
        status as ticket_status,
        created_at as ticket_created_at
    from source
)

select * from renamed