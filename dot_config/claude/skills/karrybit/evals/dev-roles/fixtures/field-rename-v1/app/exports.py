def export_summary(export):
    """Body of GET /exports/{id}."""
    return {"id": export["id"], "status": export["status"], "created_on": export["created_at"]}
