# Medallion Architecture Reference

Last checked: 2026-06-07

Use this reference to ground Bronze/Silver/Gold information design in established lakehouse practice without copying enterprise platform details into small local workflows.

## Source Summary

- Databricks describes medallion architecture as layered lakehouse data that improves in quality through validations and transformations. Bronze, Silver, and Gold describe raw, validated, and enriched data quality levels.
- Databricks presents Bronze as raw ingestion and source fidelity, Silver as cleaning, validation, joining, and refinement, and Gold as business-facing aggregates and summaries.
- Databricks data warehousing guidance says Silver can serve as the single source of truth for data marts, while Gold is the presentation layer for data marts and specific business perspectives.
- Microsoft Fabric applies the same staged pattern in lakehouse tutorials: Bronze for raw data, Silver for validated and deduplicated data, and Gold for highly refined data.
- Azure Architecture Center summarizes the layers as Bronze raw ingestion, Silver cleansed and transformed data, and Gold business-ready data for analytics and AI.

## Practical Translation For Agent Work

- Bronze should preserve source fidelity only within policy boundaries. For personal workflows, do not keep secrets, credentials, session state, copyrighted full text, or terms-restricted content just because the data is "raw."
- Silver should make records comparable: normalize identifiers, standardize dates and labels, remove duplicates, join to ledgers, and mark invalid or unresolved records.
- Gold should answer a specific action question: what to review, what to prioritize, what to publish, what to study, what to monitor, or what to hand off.
- Do not begin with Gold when the work depends on external history or logs. First identify what Bronze evidence will support later interpretation.
- Do not overbuild. A Markdown table, CSV, JSONL file, or small directory split can express the layers when an enterprise lakehouse is unnecessary.

## Design Checklist

- Bronze: What source is observed, how is it accessed, and what is safe to retain?
- Silver: Which fields are standardized, deduplicated, validated, joined, or derived?
- Gold: Which user decision or action consumes the result?
- Lineage: Can a Gold item be traced back to a Silver record and a Bronze observation?
- Freshness: What field or note tells the agent when the data should be refreshed?
- Safety: What data is excluded even if it appears in the source?

## Sources

- Databricks, "What is the medallion lakehouse architecture?" https://learn.microsoft.com/en-us/azure/databricks/lakehouse/medallion
- Databricks, "Data warehousing architecture." https://docs.databricks.com/aws/en/sql/get-started/data-warehousing-concepts
- Microsoft Fabric, "Lakehouse end-to-end scenario: overview and architecture." https://learn.microsoft.com/en-us/fabric/data-engineering/tutorial-lakehouse-introduction
- Azure Architecture Center, "Analytics End-to-End with Microsoft Fabric." https://learn.microsoft.com/en-us/azure/architecture/example-scenario/dataplate2e/data-platform-end-to-end

Revalidation trigger: Recheck when Databricks or Microsoft substantially changes lakehouse terminology, when applying the pattern to regulated data, or when adding deterministic scripts that depend on layer definitions.
