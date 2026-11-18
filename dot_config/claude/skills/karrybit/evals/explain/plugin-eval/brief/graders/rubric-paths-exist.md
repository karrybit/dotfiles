---
type: regex
target: trace
pattern: 'Base directory for this skill: (([^"\\]+?)/skills(?:/[^"\\/]+)?)/explain\\n(?=[\s\S]*"name":"Agent"[^\n]*\1/organize/rubric\.md)(?=[\s\S]*"name":"Agent"[^\n]*\1/visualize/rubric\.md)(?![\s\S]*"name":"Agent"[^\n]*\2/skills/[^\s"`\\]*(?<!\1/organize|\1/visualize)/rubric\.md)'
---
