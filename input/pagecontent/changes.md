### 0.1.0 (18 November 2026)

- First draft, written by an AI coding agent and not yet reviewed by a human.
- Catalogue of skills, plugins and MCP servers for IG work.
- Guidance for setting up an IG repository for agents and for the working loop.
- Profiles AI Agent Device and Agent Authoring Provenance, extension Agent Tool Used, and two code systems with value sets.
- Added the issue-to-pull-request set-up: issue forms, agent workflow, `issue-to-pr` skill and the contributing page.
- Comments and reviews on a pull request start a follow-up run.
- The agent workflows announce a run and its ci-build address at the start and notify the people involved at the end.
- Every new issue starts the agent until 25 November 2026; afterwards a maintainer approves an issue with the label `agent`.
- Added the development page with model, token usage and prompts.
- The agent now learns who is a maintainer from the write access to the repository, not from GitHub's role label on a comment.
- Follow-up runs merge the main branch into the pull request branch, and the agent resolves conflicts, so that pull requests stay mergeable.
- Rule added: every issue a pull request covers gets its own change log line with a link to the issue.
- Updated the home, guidance, catalogue and development pages to describe the issue and pull request workflows; added Claude Code GitHub Actions to the catalogue.
- The profiles now conform to [HL7 AI Transparency on FHIR](https://build.fhir.org/ig/HL7/aitransparency-ig/): the guide depends on the current HL7 build (`hl7.fhir.uv.aitransparency#current`), AI Agent Device derives from AI Device and states the kind of agent in the extension AI Kind, and Agent Authoring Provenance derives from AI Provenance and so takes over its reason `AIAST`, the AI agent role, the input prompt entity and its must-support flags. The verifier stays required and is a Practitioner or PractitionerRole, never an Organization. All artifacts and examples carry the `AIAST` label, and the provenance page compares the two models ([#1](https://github.com/hl7ch/agentic-ig/issues/1)).
- Added Firely's `fhir-validation` skill, built by Ardon Toonstra, to the catalogue, with install lines for its plugin ([#4](https://github.com/hl7ch/agentic-ig/issues/4)).
- Catalogue: added the HL7 Europe Imaging Manifest AI implementer by bvdh, a working set of Copilot-layout skills and agents for spec extraction, build, QA, content and research, with notes on reusing it; the gap on chat search now mentions its Zulip agent ([#6](https://github.com/hl7ch/agentic-ig/issues/6)).
- Catalogue: added a table with the estimated popularity of the listed MCP servers, from GitHub stars and forks and PyPI downloads on 19 November 2026, with notes where the count covers a whole repository or the repository is archived ([#8](https://github.com/hl7ch/agentic-ig/issues/8)).
- Catalogue: added `medical-terminologies-mcp`, an MCP server for read-only lookup in ICD-11, LOINC, RxNorm, MeSH, ATC and the Brazilian ICD-10 with ICD-10 to ICD-11 mapping and provenance on every answer, with its install notes and popularity figures ([#14](https://github.com/hl7ch/agentic-ig/issues/14)).
