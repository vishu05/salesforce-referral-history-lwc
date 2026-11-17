# Salesforce Referral History LWC

A reusable Lightning Web Component that shows a person's prior support
referrals as a filterable datatable **and** a chronological timeline, with a
prior-referral count for duplicate-awareness.

> Portfolio demo. Fictional organisation ("Harborview Community Services"),
> fictional people, synthetic data only. Built from scratch; contains no
> code or data from any employer or client.

## Scenario

Community support workers opening a new referral need to answer one question
fast: *"Have we helped this person before, and what happened?"* This component
answers it on the person record page - history table, recent-referral badges,
status filter, and a timeline view - without running a report.

## What's Inside

| Piece | Description |
|---|---|
| `referralHistory` LWC | Datatable + status filter + prior-count summary, `@wire` driven |
| `referralTimeline` LWC | Child timeline rendering the same rows chronologically |
| `ReferralHistoryController` | Thin `@AuraEnabled(cacheable=true)` controller, input validation |
| `ReferralHistoryService` | Query + row-shaping logic (days open, recent flag), bulk-safe limits |
| `ReferralTestDataFactory` | `@isTest` fictional seed data (positive / filter / negative / bulk tests) |
| Objects | `Person_Profile__c`, `Support_Referral__c` (auto-number REF-####) |

## Design Notes

- **Controller/service separation** - the controller stays thin; all shaping
  logic is testable in the service.
- **Bulk & limit safe** - row count is clamped (max 200), single SOQL query.
- **Cacheable wires** with reactive `$recordId` / `$statusFilter` parameters.
- **Non-blocking duplicate awareness** - a prior-count, not a hard stop.

## Getting Started

```bash
sf org login web --alias demo
sf project deploy start --target-org demo
```

Add the **Referral History** component to a `Person_Profile__c` record page
in Lightning App Builder, create a few `Support_Referral__c` rows, and open
the person record.

## Tests

Apex: `ReferralHistoryControllerTest` (history, status filter, missing-person
error, 200-row bulk). Run with `sf apex run test --test-level RunLocalTests`.

## License

MIT - see [LICENSE](LICENSE).
