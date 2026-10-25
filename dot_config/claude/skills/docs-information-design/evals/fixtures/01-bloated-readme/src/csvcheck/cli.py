import argparse
import sys

from .validate import validate_file

EXIT_OK = 0
EXIT_INVALID = 1
EXIT_USAGE = 2


def main(argv=None):
    p = argparse.ArgumentParser(prog="csvcheck")
    p.add_argument("path", nargs="+", help="CSV files to validate")
    p.add_argument("--schema", help="JSON schema file describing columns")
    p.add_argument("--delimiter", default=",", help="field delimiter (default: ,)")
    p.add_argument("--strict", action="store_true",
                   help="treat a trailing empty line and BOM as errors")
    p.add_argument("--max-errors", type=int, default=50,
                   help="stop after N errors per file (default: 50, 0 = unlimited)")
    p.add_argument("--format", choices=["text", "json"], default="text")
    try:
        args = p.parse_args(argv)
    except SystemExit:
        return EXIT_USAGE

    failed = False
    for path in args.path:
        errors = validate_file(path, schema=args.schema, delimiter=args.delimiter,
                               strict=args.strict, max_errors=args.max_errors)
        if errors:
            failed = True
            for e in errors:
                print(e.render(args.format))
    return EXIT_INVALID if failed else EXIT_OK


if __name__ == "__main__":
    sys.exit(main())
