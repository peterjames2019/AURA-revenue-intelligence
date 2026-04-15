with source as (
    select * from {{ source('aura_retail_source', 'marketing_email_stats') }}
),

renamed as (
    select
        customer_id,
        is_subscribed,
        -- If we had engagement scores or last open dates, we'd put them here
        true as is_active_marketer -- placeholder logic
    from source
)

select * from renamed