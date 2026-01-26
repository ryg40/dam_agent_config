# Data Migration Request

## Summary
Data Migration - {{COLLECTION_NAME}} to {{TARGET_SYSTEM}}

## Description

### Migration Details

| Field | Value |
|-------|-------|
| **Source Database** | {{DATABASE_NAME}} |
| **Source Collection** | {{COLLECTION_NAME}} |
| **Target System** | {{TARGET_SYSTEM}} |
| **Target URL** | {{TARGET_URL}} |
| **Requested By** | {{REQUESTER}} |
| **Requested Date** | {{REQUEST_DATE}} |

### Query Filter

```json
{
  "status": "pending_migration",
  "created_at": {
    "$gte": "{{START_DATE}}",
    "$lte": "{{END_DATE}}"
  }
}
```

### Field Mappings

| Source Field | Target Form Field | Transform |
|--------------|-------------------|-----------|
| `user_id` | User ID | None |
| `event_type` | Event Type | None |
| `timestamp` | Event Date | ISO8601 to date |
| `details` | Description | JSON stringify |
| `severity` | Priority Level | Map to dropdown |

### Acceptance Criteria

- [ ] All records matching the query filter are processed
- [ ] Successfully migrated records are marked in source collection
- [ ] Failed records are logged with error details
- [ ] Migration report is generated and attached
- [ ] No data loss or corruption during transfer

### Rollback Plan

If migration fails:
1. Identify failed records from migration report
2. Revert any partial entries in target system
3. Reset source record status to original state
4. Document issues and notify stakeholders

## Labels
- data-migration
- automated
- {{PRIORITY}}

## Components
- Database Activity Monitoring
- Audit Logging

## Story Points
{{ESTIMATED_POINTS}}
