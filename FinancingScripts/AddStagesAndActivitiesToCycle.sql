--create EndOfFiscalPeriod Cycle on CAMS_HISTORY_DB

INSERT INTO public."Cycles"(
    "ID", "LOG_ID", "NAME", "TOTAL_STAGES_COUNT", "TOTAL_STAGES_COMPLETED",
    "TOTAL_STAGES_FAILED", "CREATED_BY", "DATE_CREATED", "TIME_CREATED",
    "LAST_MODIFIED_BY", "LAST_MODIFIED_DATE", "LAST_MODIFIED_TIME",
    "APPROVED_BY", "DATE_APPROVED", "TIME_APPROVED", "STATUS",
    "HASH_VALUE", "DELETED_FLAG", "ROW_VERSION", "DELETED_BY",
    "DATE_DELETED", "TIME_DELETED", "IS_DELETED"
)
VALUES (
    'ac8cf856-4118-48e8-8b56-0dff992afd22',
    NULL,
    'EndOfFiscalPeriod',
    6,
    0,
    0,
    'System User',
    DATE '2024-05-15',
    TIMESTAMPTZ '2024-05-15 11:25:01.882488+00',
    NULL,
       NULL,
    NULL,
    NULL,
    DATE '2024-05-15',
    NULL,
    FALSE,
    NULL,
    FALSE,
    NULL,
    NULL,
    NULL,
    NULL,
    FALSE
);

--create End of fiscal period on EocRunConfiguration on on CAMS_HISTORY_DB

INSERT INTO public."EocRunConfigurations" VALUES ('a470feac-9b01-4e05-9257-bceace65e28b', 'EOC Configuration', 'be2b6072-b397-4ea1-9249-8d80c86ad236', 'EndOfFiscalPeriod', 'In-Review', 'test', 'Manual', 'test', 'parallel', 'test', 'test', '20:00', 'ac8cf856-4118-48e8-8b56-0dff992afd22', '00000000-0000-0000-0000-000000000000', 'test', 'test', 'NGN4429500002001', 'NGN4429500002001', false, false, 20, 'minutes', 'retry for a set number of times', 'test', 0, 5, 30, 'Minutes', 'Stanley', '2024-08-28', '2024-08-28 09:52:35.89415+00', NULL, '2025-06-30', '2025-12-29 23:16:23.724313+00', 'Stanley', '2025-06-30', '2025-12-09 10:27:59.954091+00', true, 'test', false, 1, NULL, NULL, NULL, false, 'Dome Admin', '001', 'd0c005ec-e192-4d60-8fba-9e64c1347c4c', 'Test');

--script to create stage and activity on on CAMS_HISTORY_DB
BEGIN;

WITH inserted_stages AS (
    INSERT INTO public."Stages"(
        "ID", "CYCLE_ID", "REQUEST_ID", "NAME",
        "TOTAL_ACTIVITIES_COUNT", "TOTAL_ACTIVITIES_COMPLETED",
        "TOTAL_ACTIVITIES_FAILED",
        "DATE_CREATED", "TIME_CREATED",
        "STATUS", "DELETED_FLAG", "IS_DELETED"
    )
    SELECT
        gen_random_uuid(),
        'ac8cf856-4118-48e8-8b56-0dff992afd22',
        NULL,
        stage_name,
        total_activities,
        0,
        0,
        DATE '2025-05-15',
        NOW(),
        FALSE,
        FALSE,
        FALSE
    FROM (VALUES
        ('Date Change', 1),     
        ('Pre-End of Cycle', 4),
        ('End of Transaction Input', 9),
        ('End of Financial Input', 2),
        ('End of Fiscal Period', 3),
        ('Beginning of New Fiscal Period', 1)
    ) v(stage_name, total_activities)
    RETURNING "ID" AS stage_id, "NAME" AS stage_name
)

INSERT INTO public."Activities"(
    "ID", "CYCLE_ID", "STAGE_ID", "REQUEST_ID", "NAME",
    "TOTAL_JOBS_COUNT", "TOTAL_JOBS_COMPLETED", "TOTAL_JOBS_FAILED",
    "DATE_CREATED", "TIME_CREATED",
    "STATUS", "DELETED_FLAG", "IS_DELETED",
    "STAGE_NAME", "SEQUENCE_ID"
)
SELECT
    gen_random_uuid(),
    'ac8cf856-4118-48e8-8b56-0dff992afd22',
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
FROM inserted_stages s
JOIN (VALUES
    ('Date Change', 'Date Change', 2),

    ('Checking Pending Transactions',   'Pre-End of Cycle', 1),
    ('Branch Tills Zerorization',        'Pre-End of Cycle', 1),
    ('Daily Exchange Rate Upload Check', 'Pre-End of Cycle', 1),
    ('Investment Maturity Processing',              'End of Transaction Input', 4),
    ('GL Balance Update Processing',                 'End of Transaction Input', 5),
    ('CASA Interest Accruals',                        'End of Transaction Input', 3),
    ('Customer Loan Accruals',                       'End of Transaction Input', 3),
    ('Loan repayments',                              'End of Transaction Input', 4),
    ('Investment Daily Interest Accrual Processing', 'End of Transaction Input', 3),
    ('Daily Operating Balance Process', 'End of Financial Input', 7),
    ('Trial Balance Generation',        'End of Financial Input', 8)
) a(activity_name, stage_name, sequence_id)
ON a.stage_name = s.stage_name;

COMMIT;



