---
type: regex
target: { source: file, path: README.md }
pattern: '^# orbit-client\n\nPython client for the Orbit REST API\. Supports Python 3\.8\+\.\n\n## Install\n\n```\npip install orbit-client\n```\n\n## Quick start\n\n```python\nfrom orbit import Client\n\nclient = Client\(api_key="\.\.\."\)\nfor project in client\.projects\.list\(\):\n    print\(project\.name\)\n```\n\n## Authentication\n[\s\S]*?\n## Pagination\n\n`list\(\)` methods return an iterator that fetches pages lazily\. Pass `page_size` \(max 100\) to control the page size\.\n\n## Pagination\n\nList methods return lazy iterators\. The maximum `page_size` is 100\.\n\n## Errors\n\nAll errors derive from `orbit\.OrbitError`\. Rate limiting raises `RateLimitError` with a `retry_after` attribute in seconds\.\n*$'
---
