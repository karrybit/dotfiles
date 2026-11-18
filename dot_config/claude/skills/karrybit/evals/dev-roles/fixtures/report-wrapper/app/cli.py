from app.report import Formatter, ReportService, Writer


def main(rows, path):
    svc = ReportService(Formatter(), Writer(path))
    svc.save(svc.build(rows))
