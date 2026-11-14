---
type: regex
target: { source: file, path: docs/faq.md }
pattern: "^# FAQ\\n\\n\\*\\*Does shipit roll back automatically\\?\\*\\* No\\. Re-run shipit with the previous manifest revision\\.\\n\\n\\*\\*Can two shipit runs execute at once\\?\\*\\* Yes, but deployments to the same service are serialized by a row lock in the database\\.\\n*$"
---
