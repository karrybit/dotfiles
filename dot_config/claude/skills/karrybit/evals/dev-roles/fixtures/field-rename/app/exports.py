def export_summary(export):
    """Body of GET /exports/{id}."""
    return {"id": export["id"], "status": export["status"], "created_at": export["created_at"]}
