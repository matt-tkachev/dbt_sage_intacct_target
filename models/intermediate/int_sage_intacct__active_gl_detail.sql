{{ config(materialized='ephemeral') }}

with gl_detail as (
    select * 
    from {{ var('gl_detail') }} 

), gl_batch as (
    select * 
    from {{ var('gl_batch') }} 

), final as (
    select
        gl_detail.*,
        gl_batch.is_batch_deleted
    from gl_detail
    left join gl_batch 
        on gl_batch.record_no = gl_detail.batch_key
    where not coalesce(gl_batch.is_batch_deleted, false) 
        and not coalesce(gl_detail.is_detail_deleted, false) 
)

select *
from final