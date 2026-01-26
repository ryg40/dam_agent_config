# Data Migration Workflow

This workflow automates the process of migrating data from MongoDB to a web application via form submission.

## Prerequisites

- Atlassian MCP server configured with Jira access
- MongoDB MCP server or connection configured
- Playwright MCP server available
- Valid credentials for target web application

## Workflow Steps

### Step 1: Create Jira Ticket

Use the Atlassian MCP server to create a tracking ticket for this data migration task.

```task
Use the Atlassian MCP server to create a Jira ticket using the template from `templates/data-migration-ticket.md`.

Required fields:
- Project key: [PROJECT_KEY]
- Issue type: Task
- Summary: Data Migration - [COLLECTION_NAME] to [TARGET_SYSTEM]
- Description: Use the template content
- Labels: data-migration, automated

Capture the ticket key (e.g., PROJ-123) for documentation.
```

### Step 2: Query MongoDB Collection

Query the source MongoDB collection to retrieve records for migration.

```task
Connect to MongoDB and query the collection specified in the Jira ticket.

1. Parse the Jira ticket description to identify:
   - Database name
   - Collection name
   - Query filter (if specified)
   - Field mappings

2. Execute the query:
   ```javascript
   db.getCollection("[COLLECTION_NAME]").find({
     // Apply filters from ticket
     status: "pending_migration"
   }).toArray()
   ```

3. Store the results for the next step.
4. Log the record count retrieved.
```

### Step 3: Navigate Web Form with Playwright

Use Playwright to automate data entry into the target web application.

```task
Use Playwright MCP server to perform the following automation:

1. Launch browser and navigate to [TARGET_URL]

2. Authenticate if required:
   - Navigate to login page
   - Enter credentials
   - Submit and wait for redirect

3. For each record from MongoDB:
   a. Navigate to the data entry form
   b. Map and fill form fields:
      - Map MongoDB fields to form input selectors
      - Handle different input types (text, select, checkbox, date)
   c. Submit the form
   d. Verify submission success
   e. Capture confirmation/reference number
   f. Log result (success/failure)

4. Handle errors gracefully:
   - Screenshot on failure
   - Continue with next record
   - Track failed records for retry

Example Playwright actions:
```javascript
await page.goto('[TARGET_URL]');
await page.fill('#field_name', record.fieldValue);
await page.selectOption('#dropdown', record.optionValue);
await page.click('button[type="submit"]');
await page.waitForSelector('.success-message');
```
```

### Step 4: Generate Documentation

Create a markdown report documenting the migration process.

```task
Generate a markdown file at `output/migration-report-[TIMESTAMP].md` with the following content:

# Migration Report

## Summary
- Jira Ticket: [TICKET_KEY]
- Date: [TIMESTAMP]
- Source: [DATABASE].[COLLECTION]
- Target: [TARGET_SYSTEM]

## Statistics
- Total Records: [COUNT]
- Successfully Migrated: [SUCCESS_COUNT]
- Failed: [FAILURE_COUNT]

## Record Details

| Record ID | Status | Target Reference | Notes |
|-----------|--------|------------------|-------|
| [ID]      | Success/Failed | [REF] | [NOTES] |

## Errors
List any errors encountered during the process.

## Screenshots
Link to any captured screenshots from failures.
```

## Configuration

### Environment Variables

```yaml
JIRA_PROJECT_KEY: "DAM"
MONGODB_URI: "mongodb://localhost:27017"
MONGODB_DATABASE: "audit_logs"
TARGET_URL: "https://target-application.example.com"
```

### Field Mapping Configuration

Define field mappings in `config/field-mappings.yaml`:

```yaml
mappings:
  - source: "user_id"
    target: "#form_user_id"
    type: "text"
  - source: "event_type"
    target: "#form_event_type"
    type: "select"
  - source: "timestamp"
    target: "#form_date"
    type: "date"
    transform: "ISO8601"
```

## Error Handling

- Network failures: Retry up to 3 times with exponential backoff
- Form validation errors: Log and skip record, continue processing
- Authentication failures: Halt workflow, update Jira ticket with error
- MongoDB connection issues: Halt workflow, create incident ticket

## Post-Workflow Actions

1. Update Jira ticket with migration report
2. Attach output documentation to ticket
3. Transition ticket to "Done" if successful, "Blocked" if failures occurred
4. Notify stakeholders via configured channels
