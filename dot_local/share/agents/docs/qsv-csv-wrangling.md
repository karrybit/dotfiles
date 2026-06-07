# qsv CSV Wrangling Source Summary

Last checked: 2026-06-07

This source summary supports the `csv-wrangling-with-qsv` skill and future CSV tooling decisions.

## Source Summary

- The qsv official site presents qsv as a fast, parallel, CPU-accelerated Rust and Polars based data-wrangling toolkit for slicing, analyzing, and working with data from the command line.
- The qsv GitHub README describes qsv as a toolkit for querying, slicing, sorting, analyzing, filtering, enriching, transforming, validating, joining, formatting, converting, and documenting tabular data such as CSV and Excel-like data.
- qsv's command pages document focused CSV operations including column selection, statistics/type inference, random sampling, joins, and schema validation.
- qsv descends from xsv, whose canonical repository describes it as a fast CSV command-line toolkit for indexing, slicing, analyzing, splitting, and joining CSV files.

## Practical Implication

For local CSV/TSV tasks, use qsv before ad hoc text parsing when CSV structure matters. Keep source files unchanged, write transformations to explicit output paths, and validate output shape with qsv before summarizing or committing results.

## Sources

- qsv official site: https://qsv.dathere.com/
- qsv GitHub README: https://github.com/dathere/qsv
- qsv command pages: https://qsv.dathere.com/web
- xsv GitHub README: https://github.com/BurntSushi/xsv

Revalidation trigger: Recheck when qsv is upgraded across major/minor versions, when a task depends on specific qsv flags, or when evaluating whether qsv should remain the preferred CSV CLI.
