This page lists what was publicly available for agent-assisted IG work on 18 November 2026. The field moves quickly, so check each source before you install anything.

Each entry carries one of three check levels:

- **Source read**: the project's own repository or documentation page was read for this catalogue.
- **Used**: the tool is used in this project, or was available as a connector in the agent session that wrote this guide, so it was seen first hand.
- **Listed only**: the entry was found in a directory or a meeting summary and was not confirmed at its source.

Apart from the entries marked "Used", no entry was installed and exercised end to end for this catalogue. Install commands are quoted from the project's own page unless a note says otherwise.

### Kinds of capability

| Kind | What it is | Where it lives |
|---|---|---|
| Instruction file | Project conventions that every agent session reads, in `AGENTS.md` or `CLAUDE.md` | Repository root |
| Skill | A folder with a `SKILL.md` file, references and scripts, loaded when a task needs it | `.claude/skills/`, `.agents/skills/` or a plugin |
| Plugin | An installable bundle of skills, commands, subagents and MCP configurations | A plugin marketplace, usually a GitHub repository |
| MCP server | A server that gives the agent tools such as validation or terminology lookup | Remote URL or a local process |
| Slash command | A named prompt that a user invokes explicitly | `.claude/commands/` |
| Subagent | A separately configured agent for a bounded task such as review | `.claude/agents/` |
{: .grid}

The same kinds are available as codes in the [Agent Tool Type](CodeSystem-agent-tool-type.html) code system.

### Skills and plugins for IG authoring

These are the entries aimed directly at FSH, SUSHI and the IG Publisher.

| Name | Source | What it covers | Licence | Check |
|---|---|---|---|---|
| `fhir-ig` plugin: skills `fsh`, `ig-publisher`, `trusted-ig-template` | [cqframework/cqf-skills](https://github.com/cqframework/cqf-skills) | `fsh` writes and debugs FSH 3.0.0 for SUSHI. `ig-publisher` configures, runs and debugs the IG Publisher (pinned to 3.0.4), including `ig.ini`, parameters and reading `qa.html`. `trusted-ig-template` writes and audits IG templates. | Apache-2.0 | Source read |
| `fhir` plugin: skills `fhir`, `fhir-extensions`, `uscore`, `usqualitycore` | [cqframework/cqf-skills](https://github.com/cqframework/cqf-skills) | FHIR R4 resource guidance, finding standard extensions in the Extensions Pack 5.4.0, and applying US Core and US Quality Core profiles. | Apache-2.0 | Source read |
| `clinical-reasoning` plugin: skills `crmi`, `cpg`, `plan-definition`, `questionnaire` | [cqframework/cqf-skills](https://github.com/cqframework/cqf-skills) | Content IGs: CRMI packaging and lifecycle operations, CPG profiles, PlanDefinition and Questionnaire authoring. | Apache-2.0 | Source read |
| `cql` plugin: skills `cql`, `cql-ig`, `us-cql-ig`, `cms-qmd`, `vscode-cql`, `madie` | [cqframework/cqf-skills](https://github.com/cqframework/cqf-skills) | Writing and reviewing CQL libraries and measures for IGs that carry CQL. | Apache-2.0 | Source read |
| `fhir-developer-skills` | [PhenoML/ClaudeFHIRSkill](https://github.com/PhenoML/ClaudeFHIRSkill) | One broad skill for FHIR R4, R4B and R5: resource modelling, FSH authoring with SUSHI and GoFSH, server and client code, SMART on FHIR. | Apache-2.0 | Source read |
| Slash commands `test-cs`, `test-vs`, `test-profile`, `publish-ig`, `view-ig` | [Aidbox/examples, agentic-coding-ig-development](https://github.com/Aidbox/examples/tree/main/developer-experience/agentic-coding-ig-development) | An example repository that generates IG resources from markdown specifications and tests them against a running Aidbox server before publishing. Described in a [Health Samurai article](https://www.health-samurai.io/articles/agentic-fhir-implementation-guide-development) of August 2025. | Not checked | Source read (article only) |
| FHIR data modelling skills, seven stages from use case to published package | Presented at the Health Samurai [Agents on FHIR](https://www.health-samurai.io/events/agents-on-fhir/2026-05-28-meeting) meetups in May 2026 | Skills that encode a modelling method, with a companion skill that runs a validator so the agent can check its own output. No public repository was found. | Unknown | Listed only |
| `issue-to-pr` | This repository, `.claude/skills/issue-to-pr` | Implements a GitHub issue as a change set that a workflow turns into a pull request with a model and token report. See [contributing](contributing.html). | CC0-1.0 | Written for this guide |
| `ig-qa-loop` | This repository, `.claude/skills/ig-qa-loop` | A small demonstration skill: run SUSHI, run the IG Publisher, read `qa.json`, fix errors, repeat. | CC0-1.0 | Written for this guide |
{: .grid}

#### Installing the cqf-skills plugins

```text
/plugin marketplace add cqframework/cqf-skills
/plugin install fhir-ig@cqf-skills
/plugin install fhir@cqf-skills
```

The project's README lists install lines for the `cql`, `fhir`, `clinical-reasoning` and `cql-mcp` plugins. The `fhir-ig` line above follows the same pattern and uses the plugin name from the project's `marketplace.json`; it was not run for this catalogue. For agents other than Claude Code, clone the repository and copy the skill folders you need into `.agents/skills/` or your agent's skill directory.

#### Installing the PhenoML skill

```text
/plugin marketplace add TopologyHealth/ClaudeFHIRSkill
/plugin install fhir-developer-skills@ClaudeFHIRSkill
```

The README names the `TopologyHealth` organisation in the marketplace command although the repository was reached under `PhenoML`.

### Skills for FHIR implementation work

These do not author IGs, but they help when an agent builds a test client, a reference implementation or example data for a guide.

| Name | Source | What it covers | Check |
|---|---|---|---|
| `healthcare` plugin: skills `fhir-developer` and `fhir`, plus a bundled FHIR MCP server | [anthropics/healthcare](https://github.com/anthropics/healthcare) | `fhir-developer` is a guide for building FHIR API endpoints. `fhir` connects to a FHIR R4 server and extracts patient data. The plugin also references hosted MCP servers for ICD-10 codes, NPI Registry, CMS Coverage, Clinical Trials and PubMed. The earlier standalone `fhir-developer` plugin is a deprecated alias. | Source read |
{: .grid}

```text
/plugin marketplace add anthropics/healthcare
/plugin install healthcare@healthcare
```

### MCP servers for validation

| Name | Source | Tools | Check |
|---|---|---|---|
| Matchbox validation MCP | [ahdis/matchbox](https://github.com/ahdis/matchbox), [tutorial](https://ahdis.github.io/matchbox/validation-with-ai-tutorial/) | Validates a resource against the IGs loaded in a Matchbox server. Tools seen in the authoring session: `validate-fhir-resource`, `list-fhir-igs`, `list-fhir-profiles-to-validate-for`, `list-validation-parameters`, `get-profiles-for-document-bundle`. MCP support arrived in release 4.0.13 and was extended in 4.0.14. | Source read, Used |
| `cql-mcp` | [cqframework/cqf-skills](https://github.com/cqframework/cqf-skills), plugin `cql-mcp` | Validates and runs CQL. Needs Node.js 22+ and JDK 17+. Pinned to v0.1.0-rc.2. | Source read |
{: .grid}

Matchbox enables its MCP endpoint with `spring.ai.mcp.server.enabled: true` in `application.yaml`. The tutorial gives this client configuration for a local server:

```json
{
  "mcpServers": {
    "matchbox": {
      "command": "npx",
      "args": ["mcp-remote@latest", "http://localhost:8080/matchboxv3/mcp/message"]
    }
  }
}
```

A Matchbox server only validates against the IGs it has loaded. To validate against your own guide, load the `package.tgz` from your build into the server first.

### MCP servers for terminology

| Name | Source | What it covers | Check |
|---|---|---|---|
| SNOMED CT Terminology connector (Snowstorm) | Connector in the authoring session; its source repository was not identified | Lookup, validate-code, subsumption, hierarchy navigation and ECL expansion. Tools seen: `snomed_lookup`, `snomed_validate_code`, `snomed_expand`, `snomed_get_children`, `snowstorm_search_concepts`. | Used |
| `mcp-snomed-ct` | [eigenbau/mcp-snomed-ct](https://github.com/eigenbau/mcp-snomed-ct) | SNOMED CT concept lookup and ECL through any FHIR R4 terminology server such as Snowstorm or Ontoserver. | Listed only |
| `mcp-terminology` | [PyPI](https://pypi.org/project/mcp-terminology/) | LOINC, SNOMED CT, RxNorm and ICD-10 lookup through the public `tx.fhir.org` server. | Listed only |
| MCP-LOINC | [Kryzo/mcp-Loinc](https://github.com/Kryzo/mcp-Loinc) | Wrapper for the LOINC API. | Listed only |
| RxNorm MCP | [pipeworx-io/mcp-rxnorm](https://github.com/pipeworx-io/mcp-rxnorm) | Drug concept lookup through the NLM RxNav API. | Listed only |
{: .grid}

### MCP servers for FHIR data access

These servers read and write data on a FHIR server. They are outside IG authoring, but they are useful for testing a guide against a running system.

| Name | Source | Check |
|---|---|---|
| WSO2 FHIR MCP server | [wso2/fhir-mcp-server](https://github.com/wso2/fhir-mcp-server) | Listed only |
| AWS HealthLake MCP server | [awslabs MCP servers](https://awslabs.github.io/mcp/servers/healthlake-mcp-server) | Listed only |
| Medplum MCP server | [medplum/medplum-mcp-server](https://github.com/medplum/medplum-mcp-server) | Listed only |
| Health Record MCP | [jmandel/health-record-mcp](https://github.com/jmandel/health-record-mcp) | Listed only |
| AEHRC FHIR tools | [aehrc/mcp-fhir-tools](https://github.com/aehrc/mcp-fhir-tools) | Listed only |
{: .grid}

A maintained directory of further servers is [awesome-healthcare-mcp-servers](https://github.com/rdmgator12/awesome-healthcare-mcp-servers).

### Agents in continuous integration

| Name | Source | What it covers | Check |
|---|---|---|---|
| Claude Code GitHub Actions | [anthropics/claude-code-action](https://github.com/anthropics/claude-code-action), [documentation](https://code.claude.com/docs/en/github-actions) | Runs a coding agent in a GitHub workflow, on a mention or on any event with a prompt. It authenticates with an API key or with a token from a Claude subscription, and writes a run log with the model and token usage. This guide uses it to turn issues into pull requests and to respond to review comments; see [contributing](contributing.html). | Source read, Used |
{: .grid}

### Command line tools the agent runs directly

An agent with shell access needs no wrapper for the standard tool chain.

| Tool | Use | Source |
|---|---|---|
| SUSHI | Compiles FSH to FHIR JSON in seconds; the fast inner check | [FHIR/sushi](https://github.com/FHIR/sushi) |
| GoFSH | Converts existing FHIR JSON to FSH | [FHIR/GoFSH](https://github.com/FHIR/GoFSH) |
| IG Publisher | Full build and validation; writes `output/qa.html` and `output/qa.json` | [HL7/fhir-ig-publisher](https://github.com/HL7/fhir-ig-publisher) |
| FHIR Validator | Validates single resources against a package | [hapifhir/org.hl7.fhir.core](https://github.com/hapifhir/org.hl7.fhir.core) |
{: .grid}

### Gaps found

- No skill or MCP server was found that searches the FHIR package registry or the community chat for existing profiles, apart from the unpublished work shown at the meetups.
- No HL7 guidance on agent-authored IG content was found. HL7's current AI projects concern AI transparency in clinical data, not the authoring of specifications.
- Speakers at the meetups described the IG Publisher as hard for agents to drive because it is one long-running tool. In practice the agent copes by using SUSHI for quick checks and the Publisher for the final check, as the [guidance](guidance.html) describes.
