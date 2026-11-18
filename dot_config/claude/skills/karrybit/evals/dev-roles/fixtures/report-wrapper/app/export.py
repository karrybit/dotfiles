from app.report import Formatter, ReportService, Writer


def export_daily(rows, path):
    svc = ReportService(Formatter(), Writer(path))
    text = svc.build(rows)
    svc.save(text)
    return len(text)
