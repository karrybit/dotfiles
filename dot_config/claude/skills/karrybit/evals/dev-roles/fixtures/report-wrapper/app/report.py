class Formatter:
    def format(self, rows):
        return "\n".join(",".join(str(c) for c in row) for row in rows)


class Writer:
    def __init__(self, path):
        self.path = path

    def write(self, text):
        with open(self.path, "w") as f:
            f.write(text)


class ReportService:
    def __init__(self, formatter, writer):
        self.formatter = formatter
        self.writer = writer

    def build(self, rows):
        return self.formatter.format(rows)

    def save(self, text):
        self.writer.write(text)
