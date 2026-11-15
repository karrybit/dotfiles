# Audit of the web client

This audit was done in issue #12.

1. ESLint is on 7.x. Upgrade it to 9.x.
2. The ESLint config enables formatting rules that conflict with Prettier. Review the rule set.
3. The HTTP client in `packages/client` does not retry. Add retries with backoff for 5xx responses.
4. Once retries exist, add a dashboard panel that shows retry counts. Nice to have.
5. Open question: should every package follow semantic versioning? It affects the release notes of `packages/client` and `packages/ui`.
