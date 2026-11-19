"""Render a template and send it through the email provider."""

from pathlib import Path

from .oldmail_client import OldmailClient

TEMPLATE_DIR = Path(__file__).resolve().parents[2] / "templates"


def render(template_id, params):
    text = (TEMPLATE_DIR / f"{template_id}.txt").read_text()
    subject, _, body = text.partition("\n\n")
    return subject.removeprefix("Subject: "), body.format(**params)


def send(client: OldmailClient, template_id, to, params):
    subject, body = render(template_id, params)
    return client.send(to, subject, body)
