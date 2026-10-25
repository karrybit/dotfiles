.PHONY: setup migrate run test

setup:
	uv sync

migrate:
	uv run alembic upgrade head

run:
	uv run uvicorn app.main:app --reload

test:
	uv run pytest
