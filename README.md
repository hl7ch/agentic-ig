# Agentic FHIR IG Authoring (Demo)

A demo FHIR R4 implementation guide about developing and maintaining an IG with AI coding agents.

- `input/pagecontent/catalog.md`: skills, plugins and MCP servers available for IG work, as of 18 November 2026
- `input/pagecontent/guidance.md`: how to set up a repository for agents and how to work with them
- `input/fsh/`: profiles for recording agent authorship, with terminology and examples
- `AGENTS.md`, `.claude/skills/ig-qa-loop/`: the agent set-up this guide describes

## Build

Requires Node.js and Docker.

```sh
./_build.sh sushi   # compile FSH only
./_build.sh         # SUSHI and the IG Publisher; open output/index.html afterwards
```

