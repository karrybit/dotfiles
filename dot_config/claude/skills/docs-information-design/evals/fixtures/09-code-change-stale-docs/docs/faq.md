# FAQ

**Does shipit roll back automatically?** No. Re-run shipit with the previous manifest revision.

**Can two shipit runs execute at once?** Yes, but deployments to the same service are serialized by a row lock in the database.
