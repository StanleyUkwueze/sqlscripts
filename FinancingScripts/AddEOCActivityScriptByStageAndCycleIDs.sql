--This script add eoc activities when you know the Stage and Cycle they belong to

BEGIN;

WITH existing_stage AS (
    SELECT
        "ID"        AS stage_id,
        "NAME"      AS stage_name
    FROM public."Stages"
    WHERE "ID" = '5088fa45-0053-4355-bcf0-b0abc2f565fb'
      AND "CYCLE_ID" = '6e92d3d2-1c8b-4012-824f-97f9faa35689'
)

INSERT INTO public."Activities"(
    "ID",
    "CYCLE_ID",
    "STAGE_ID",
    "REQUEST_ID",
    "NAME",
    "TOTAL_JOBS_COUNT",
    "TOTAL_JOBS_COMPLETED",
    "TOTAL_JOBS_FAILED",
    "DATE_CREATED",
    "TIME_CREATED",
    "STATUS",
    "DELETED_FLAG",
    "IS_DELETED",
    "STAGE_NAME",
    "SEQUENCE_ID"
)
SELECT
    gen_random_uuid(),
    '6e92d3d2-1c8b-4012-824f-97f9faa35689',
    s.stage_id,
    NULL,
    a.activity_name,
    0,
    0,
    0,
    DATE '2025-05-15',
    NOW(),
    FALSE,
    FALSE,
    FALSE,
    s.stage_name,
    a.sequence_id
FROM existing_stage s
JOIN (VALUES
    ('Investment Schedule Pay Processing', 4),
    ('Investment Contribution Processing', 4),
    ('Investment Payout Processing', 4),
    ('Investment Annuity Maturity Processing', 4)
) a(activity_name, sequence_id)
ON TRUE;

COMMIT;
