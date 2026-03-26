# Decision Body Template

Structure every decision body with these sections. Each section should be concise — a few sentences, not paragraphs.

```markdown
## Context

[What situation led to this decision — the trigger, not the solution. What problem
needed solving or what question needed answering.]

## Decision

[The choice made, stated as a clear assertion. "We will use X" not "We considered X".]

## Alternatives Considered

### [Alternative name]

[What it is. Why it was rejected — specific technical or practical reasons.]

### [Alternative name]

[Same structure. Include at least one alternative for non-trivial decisions.]

## Consequences

[Known trade-offs: what we gain, what we give up, risks accepted.
Be specific — "faster builds but larger bundle" not "some trade-offs exist".]

## Related Decisions

[Reference by number: "Depends on #1 (Vitest adoption)", "Supersedes #3 (old auth)".
Use mcp__reckon__link_decisions to formalize these as dependency links.]
```

## Examples

### Good: Technical Decision

```markdown
## Context

The monorepo needs a test framework. Apps use ES modules throughout with
"type": "module" in package.json and Node16 module resolution.

## Decision

Adopt Vitest as the test runner across the entire monorepo, with supertest
for HTTP integration testing of the Express-based MCP server.

## Alternatives Considered

### Jest

Most widely used JS test framework. Rejected because ESM support is still
experimental and requires transform workarounds. Module mocking has known
friction with ESM imports.

### Node.js built-in test runner

Zero-dependency option. Rejected because no built-in module mocking, less
mature snapshot/coverage ecosystem, and SvelteKit path aliases require
custom loader hooks.

## Consequences

Gain: native ESM support, fast startup, Jest-compatible API for easy adoption.
Give up: Jest's larger ecosystem of plugins and community support.

## Related Decisions

None yet — this is a foundational choice.
```

### Good: Product Decision

```markdown
## Context

Users need to authenticate to access their repos. We need to decide
the authentication method for the MVP.

## Decision

Users authenticate exclusively via GitHub OAuth. No email/password,
no magic links, no other OAuth providers.

## Alternatives Considered

### Email/password with GitHub as secondary

Would reach users without GitHub accounts. Rejected because our target
users are developers who all have GitHub, and adding password auth
increases security surface area for the MVP.

### Multiple OAuth providers (Google, GitLab)

Would broaden access. Rejected for MVP — we can add providers later,
and GitHub aligns with our repo-centric model.

## Consequences

Gain: simple auth flow, no password storage, direct access to GitHub
repos and installations.
Give up: users without GitHub accounts cannot use the product.

## Related Decisions

Depends on #4 (GitHub App installation model).
```
