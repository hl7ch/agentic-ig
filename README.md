# Agentic FHIR IG Authoring (Demo)

A demo FHIR R4 implementation guide about developing and maintaining an IG with AI coding agents.

- `input/pagecontent/catalog.md`: skills, plugins and MCP servers available for IG work, as of 18 November 2026
- `input/pagecontent/guidance.md`: how to set up a repository for agents and how to work with them
- `input/fsh/`: profiles for recording agent authorship, with terminology and examples
- `input/pagecontent/contributing.md`: how issues become pull requests through an agent
- `AGENTS.md`, `.claude/skills/`: the instructions and skills the agents work from
- `.github/`: issue forms and the workflows that run the agent on issues and pull request comments

## Build

Requires Node.js and Docker, or Node.js, Java, SUSHI and Jekyll without Docker.

```sh
./_build.sh sushi   # compile FSH only
./_build.sh         # SUSHI and the IG Publisher; open output/index.html afterwards
```

