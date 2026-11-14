---
type: regex
target: { source: file, path: README.md }
pattern: '## Authentication(?=(?:(?!\n## )[\s\S])*?(?:one hour|1 hour|60 minutes))(?=(?:(?!\n## )[\s\S])*?(?:60 seconds|sixty seconds|60 s\b|60-second))(?=(?:(?!\n## )[\s\S])*?auto_refresh=False)(?=(?:(?!\n## )[\s\S])*?client\.refresh\(\))(?=(?:(?!\n## )[\s\S])*?AuthError)'
flags: i
---
