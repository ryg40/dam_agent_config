# Migration Report

## Execution Summary

| Field | Value |
|-------|-------|
| **Jira Ticket** | {{TICKET_KEY}} |
| **Execution Date** | {{EXECUTION_TIMESTAMP}} |
| **Duration** | {{DURATION}} |
| **Executed By** | Automated Workflow |

## Source Configuration

| Field | Value |
|-------|-------|
| **Database** | {{DATABASE_NAME}} |
| **Collection** | {{COLLECTION_NAME}} |
| **Query Filter** | `{{QUERY_FILTER}}` |

## Target Configuration

| Field | Value |
|-------|-------|
| **System** | {{TARGET_SYSTEM}} |
| **URL** | {{TARGET_URL}} |
| **Form Path** | {{FORM_PATH}} |

## Migration Statistics

| Metric | Count |
|--------|-------|
| **Total Records Queried** | {{TOTAL_RECORDS}} |
| **Successfully Migrated** | {{SUCCESS_COUNT}} |
| **Failed** | {{FAILURE_COUNT}} |
| **Skipped** | {{SKIPPED_COUNT}} |
| **Success Rate** | {{SUCCESS_RATE}}% |

## Record Details

### Successfully Migrated Records

| Source ID | Target Reference | Migrated At |
|-----------|------------------|-------------|
{{#SUCCESSFUL_RECORDS}}
| {{SOURCE_ID}} | {{TARGET_REF}} | {{TIMESTAMP}} |
{{/SUCCESSFUL_RECORDS}}

### Failed Records

| Source ID | Error Type | Error Message | Screenshot |
|-----------|------------|---------------|------------|
{{#FAILED_RECORDS}}
| {{SOURCE_ID}} | {{ERROR_TYPE}} | {{ERROR_MESSAGE}} | [View]({{SCREENSHOT_PATH}}) |
{{/FAILED_RECORDS}}

### Skipped Records

| Source ID | Reason |
|-----------|--------|
{{#SKIPPED_RECORDS}}
| {{SOURCE_ID}} | {{SKIP_REASON}} |
{{/SKIPPED_RECORDS}}

## Error Analysis

{{#HAS_ERRORS}}
### Error Summary

| Error Type | Count | Percentage |
|------------|-------|------------|
{{#ERROR_SUMMARY}}
| {{ERROR_TYPE}} | {{COUNT}} | {{PERCENTAGE}}% |
{{/ERROR_SUMMARY}}

### Common Issues

{{#COMMON_ISSUES}}
- **{{ISSUE_TYPE}}**: {{DESCRIPTION}}
  - Affected Records: {{AFFECTED_COUNT}}
  - Recommended Action: {{RECOMMENDATION}}
{{/COMMON_ISSUES}}
{{/HAS_ERRORS}}

{{^HAS_ERRORS}}
No errors encountered during migration.
{{/HAS_ERRORS}}

## Workflow Execution Log

```
{{EXECUTION_LOG}}
```

## Artifacts

| Artifact | Location |
|----------|----------|
| Screenshots | `output/screenshots/{{TICKET_KEY}}/` |
| Raw Data Export | `output/data/{{TICKET_KEY}}-source.json` |
| Error Log | `output/logs/{{TICKET_KEY}}-errors.log` |

## Next Steps

{{#HAS_FAILURES}}
- [ ] Review failed records and determine root cause
- [ ] Fix data issues or form mapping problems
- [ ] Re-run migration for failed records only
- [ ] Update Jira ticket with resolution
{{/HAS_FAILURES}}

{{^HAS_FAILURES}}
- [x] Migration completed successfully
- [ ] Verify data in target system
- [ ] Close Jira ticket
- [ ] Archive migration artifacts
{{/HAS_FAILURES}}

---

*Report generated automatically by Data Migration Workflow*
