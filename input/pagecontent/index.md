### Purpose

This demo implementation guide shows how an FHIR implementation guide (IG) can be developed and maintained together with AI coding agents. It does three things:

1. It lists the skills, plugins and MCP servers that exist today for IG work, in the [catalogue](catalog.html).
2. It explains how to set them up and how to run an agent safely against an IG repository, in the [guidance](guidance.html).
3. It defines a small set of FHIR artifacts for [recording which agent authored an artifact and which human verified it](provenance.html).

The guide is a demonstration. It is not a published standard and nothing in it is normative.

### Who this is for

IG editors and authors who already know FHIR Shorthand (FSH), SUSHI and the IG Publisher, and who want to hand part of the authoring and maintenance work to an agent.

### What an agent is good at in an IG repository

An IG repository suits agents well because every change can be checked by a tool. SUSHI reports whether the FSH compiles, and the IG Publisher reports whether the result is valid, in a `qa.html` and `qa.json` file the agent can read. An agent that can run both tools can keep working on a change until the checks pass.

| Task | Fit | What the human still decides |
|---|---|---|
| Writing FSH for profiles, extensions, value sets and examples from a written requirement | Good | Whether the requirement is right, and the modelling choice between alternatives |
| Fixing SUSHI errors and IG Publisher QA errors | Good | Whether a warning may be suppressed |
| Keeping examples in step with changed profiles | Good | Whether the example is clinically plausible |
| Updating dependencies and adapting to a new package version | Good | When to take the update |
| Drafting narrative pages and change logs | Fair | Tone, accuracy and what the community agreed |
| Choosing codes from SNOMED CT, LOINC or other terminologies | Poor without a terminology tool | The final choice of code |
| Deciding cardinality, must-support and binding strength | Poor | All of it; these are consensus decisions |
{: .grid}

### How this guide was built

An AI coding agent wrote this guide in a single session on 18 November 2026, including the research for the catalogue. The agent ran SUSHI and the IG Publisher and corrected the content until the build reported no errors. The catalogue states for each entry how far it was checked. No human has reviewed the content yet, so treat the catalogue as a starting point and confirm each entry at its source before you rely on it. The model, the token usage and the prompts are on the [development](development.html) page.

The repository also contains the agent set-up that the guidance describes: an `AGENTS.md` instruction file, a project skill in `.claude/skills/ig-qa-loop`, and a `_build.sh` script that the agent and a human run in the same way.

### Contributing

Propose a catalogue entry or a feature with a GitHub issue. An agent turns accepted issues into pull requests, as the [contributing](contributing.html) page describes.

### Artifacts

The profiles, extension, terminology and examples are listed on the [artifacts](artifacts.html) page.

### Dependencies

{% include dependency-table.xhtml %}

### Cross-version analysis

{% include cross-version-analysis.xhtml %}

### Global profiles

{% include globals-table.xhtml %}

### Intellectual property

{% include ip-statements.xhtml %}
