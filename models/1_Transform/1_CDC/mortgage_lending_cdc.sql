{{
  config(
    materialized='incremental',
    unique_key='id',
    on_schema_change='fail',
    incremental_strategy='merge'
  )
}}

select *
from {{ ref('Mortgage_Lending') }}

{% if execute %}
  {% if flags.FULL_REFRESH %}
    -- Full refresh: process all records
  {% else %}
    -- Incremental: only process records updated after last run
    where updated_at > (select max(updated_at) from {{ this }})
  {% endif %}
{% endif %}
