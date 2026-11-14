# csvcheck

## Introduction

Welcome to csvcheck! In today's data-driven world, data quality is more important than ever. Organizations of all sizes rely on data to make decisions, and bad data can lead to bad decisions. That is why we built csvcheck.

## A Brief History of CSV

CSV (Comma-Separated Values) is one of the oldest data interchange formats. It predates personal computers, and was supported by IBM Fortran compilers as early as 1972. RFC 4180, published in 2005, attempted to standardize the format, but many variations still exist today. Because of this, CSV files from different sources often behave differently, which is exactly why validation tools are so valuable.

## What is csvcheck?

csvcheck is a command-line tool that validates CSV files. It checks that your CSV files are well-formed and, optionally, that they match a schema you define. In other words, csvcheck makes sure your CSV files are valid.

## Features

- Validates CSV structure (consistent column counts, quoting)
- Optional JSON schema for column types
- Custom delimiters
- Text or JSON output
- Fast and lightweight
- Easy to use
- Zero dependencies

## Why Use csvcheck?

There are many reasons to use csvcheck. First, it validates the structure of your CSV files, making sure every row has the same number of columns. Second, it can check column types against a JSON schema. Third, it supports custom delimiters. Fourth, it can output results as text or JSON. Finally, it has zero dependencies, so it is easy to install.

## Installation

To install csvcheck, you will need Python. Python is a popular programming language that runs on Windows, macOS and Linux. If you do not have Python installed, you can download it from python.org.

Once you have Python installed, you can install csvcheck using pip, the Python package manager:

```
pip install csvcheck
```

csvcheck requires Python 3.10 or newer.

## Getting Started

Getting started with csvcheck is easy! Simply run csvcheck followed by the path to your CSV file:

```
csvcheck data.csv
```

You can also pass multiple files:

```
csvcheck a.csv b.csv
```

## Usage

The basic usage of csvcheck is `csvcheck [options] FILE...`. Here are the available options:

| Option | Description |
| --- | --- |
| `--schema FILE` | JSON schema describing columns |
| `--delimiter CHAR` | Field delimiter (default `,`) |
| `--strict` | Treat a trailing empty line and a UTF-8 BOM as errors |
| `--max-errors N` | Stop after N errors per file (default 50; `0` means unlimited) |
| `--format text\|json` | Output format |

For example, to validate a tab-separated file against a schema:

```
csvcheck --delimiter $'\t' --schema columns.json export.tsv
```

## Exit Codes

| Code | Meaning |
| --- | --- |
| 0 | All files valid |
| 1 | At least one file has errors |
| 2 | Invalid command-line usage |

Note: `--strict` is off by default because many spreadsheet exports end with an empty line and would otherwise fail. Turn it on in CI when you control the producer.

## Best Practices for Data Quality

Data quality is a journey, not a destination. Here are some general best practices:

1. Validate data as early as possible in your pipeline.
2. Document your data formats.
3. Use version control for your schemas.
4. Automate validation in CI.
5. Communicate with data producers.

Following these best practices will help you keep your data clean and your stakeholders happy.

## Summary

In summary, csvcheck is a simple, fast, dependency-free tool for validating CSV files. Install it with pip, run it on your files, and enjoy cleaner data!

## License

MIT
