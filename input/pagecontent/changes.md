### 0.1.0 (18 November 2026)

- First draft, written by an AI coding agent and not yet reviewed by a human.
- Catalogue of skills, plugins and MCP servers for IG work.
- Guidance for setting up an IG repository for agents and for the working loop.
- Profiles AI Agent Device and Agent Authoring Provenance, extension Agent Tool Used, and two code systems with value sets.
- Added the issue-to-pull-request set-up: issue forms, agent workflow, `issue-to-pr` skill and the contributing page.
- Comments and reviews on an agent pull request start a follow-up run.
- Every new issue starts the agent until 25 November 2026; afterwards a maintainer approves an issue with the label `agent`.
- Added the development page with model, token usage and prompts.
- Added the rules of [HL7 AI Transparency on FHIR](https://build.fhir.org/ig/HL7/aitransparency-ig/) to the provenance model (issue 1): `AIAST` label on all artifacts and examples, `reason` `AIAST` required in Agent Authoring Provenance, an input prompt entity, and no Organization as verifier. The profiles follow these rules but do not yet derive from the HL7 profiles, so a validator does not check conformance with them.
