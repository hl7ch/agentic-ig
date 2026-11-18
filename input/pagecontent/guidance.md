This page describes how to set up an IG repository for agents and how to work with them. It assumes an agent with shell access to a working copy, such as a terminal or IDE coding agent.

### Principles

1. **Give the agent a check it can run.** An agent that can run SUSHI and the IG Publisher corrects its own mistakes. An agent that only writes FSH does not.
2. **Keep modelling decisions with people.** Cardinality, must-support, binding strength and the choice of codes are agreed by a community. The agent implements the decision; it does not make it.
3. **Never accept a code from the agent's memory.** Every code and every canonical URL must come from a terminology tool, a loaded package or the specification.
4. **Do not let passing QA become the goal.** An agent asked only to remove errors may loosen a constraint, delete an example or add a suppression. Review the diff, not only the QA result.
5. **Record who did what.** Keep agent changes in separate commits or pull requests, and name a human reviewer.

### Setting up the repository

#### 1. Write an instruction file

Put an `AGENTS.md` file in the repository root. Most coding agents read it at the start of every session. Claude Code reads `CLAUDE.md`, which can contain a single line that imports `AGENTS.md`. Keep the file short and limit it to what the agent cannot work out from the repository:

- the build commands, and which one is fast and which is authoritative
- where FSH, pages and examples live
- naming rules for ids, file names and titles
- which decisions the agent must ask about
- what the agent must not do, such as editing `fsh-generated/` or adding entries to `input/ignoreWarnings.txt`

The `AGENTS.md` in this repository is a working example.

#### 2. Provide one build command

Give the agent the same build entry point a human uses. This repository has a `_build.sh` script with two modes:

```text
./_build.sh sushi      # compile FSH only, a few seconds
./_build.sh            # SUSHI and the IG Publisher, several minutes
```

The script runs the IG Publisher in the `hl7fhir/ig-publisher-base` container, so the agent does not need Ruby and Jekyll on the host.

#### 3. Install skills for the tool chain

Install the skills that match your guide from the [catalogue](catalog.html). For an FSH-based guide the `fhir-ig` plugin from cqf-skills is the closest fit. Add a project skill for anything specific to your guide; `.claude/skills/ig-qa-loop` in this repository shows the format.

Prefer skills that state which tool version they were written for, and compare that version with the one you run. A skill written for an older IG Publisher may describe parameters that have changed.

#### 4. Connect a validator and a terminology server

Add an MCP server for validation, and one for each terminology your guide binds to. With these the agent can validate an example before the full build and can look up a code instead of recalling it. A project-level `.mcp.json` keeps the configuration with the repository:

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

#### 5. Limit what the agent may do

Allow the build commands and file edits inside the repository without prompting. Keep pushing, publishing and package releases behind a human confirmation.

### The working loop

1. **State the requirement.** Give the agent the change in clinical or business terms, the affected profiles, and the decisions already made. Link the issue or ticket.
2. **Let the agent plan.** For anything larger than a single profile, ask for a plan first and correct it before any FSH is written.
3. **Author and compile.** The agent edits FSH and runs SUSHI until it reports no errors and no warnings.
4. **Validate examples.** The agent writes or updates at least one example per changed profile and validates it.
5. **Run the full build.** The agent runs the IG Publisher and reads `output/qa.json` for the counts and `output/qa.html` for the messages.
6. **Fix and repeat.** The agent fixes errors at their source in `input/` and repeats from step 3.
7. **Report.** The agent states what changed, the final error and warning counts, and any warning it could not resolve.
8. **Review.** A human reads the diff and the rendered pages, then merges.

### Example requests

A request that names the outcome and the check works better than one that describes steps.

```text
Add a profile on Observation for body weight to this guide. Bind the code to
LOINC 29463-7 and require valueQuantity in kg. Add one example. Look up the
code with the terminology tool before you use it. Finish when ./_build.sh
reports no errors, and list any new warnings.
```

```text
The build reports 4 errors in output/qa.html after the update to
hl7.fhir.uv.ips 2.0.0. Find the cause of each one and fix it in input/fsh.
Do not change cardinalities or bindings without asking me, and do not add
anything to ignoreWarnings.txt.
```

```text
Review the diff on this branch as an IG editor would. Check that each changed
profile still has a valid example, that the narrative pages describe the
change, and that no constraint was loosened. Report findings only.
```

### Reading the QA result

The IG Publisher writes a summary to `output/qa.json` with the fields `errs`, `warnings` and `hints`. An agent should read these counts after every full build and treat any value of `errs` above zero as unfinished work. The individual messages are in `output/qa.html`, grouped by source file.

Three kinds of message need a human decision before the agent acts:

- a terminology message saying a code is unknown or inactive, because the fix may be a different code
- a message about a dependency version, because the fix may change what implementers must support
- any message the agent proposes to suppress

### Review checklist

- Does the diff change only what was asked for?
- Were constraints loosened, examples removed or warnings suppressed to make the build pass?
- Was every new code looked up, and does its display match the terminology?
- Does each changed profile have an example that validates?
- Do the narrative pages and the change log describe the change?
- Does the rendered guide read correctly, beyond the QA counts?

### Using several agents

Splitting work across agents helps when the tasks are independent, for example one agent per profile family, or one agent that writes and a second that reviews without seeing the first agent's reasoning. Run one full IG Publisher build at a time per working copy, because parallel builds write to the same `output/` and `temp/` folders. Use a separate working copy or git worktree for each agent.

### Running an agent in continuous integration

An agent in a pipeline can triage a failed build, comment on a pull request with the cause of new QA errors, or open a pull request for a dependency update. Give it read access to the repository and the build output, and let it propose changes through pull requests that a human merges.

### Recording the contribution

When your project wants a formal record of agent authorship, use the [Agent Authoring Provenance](StructureDefinition-agent-authoring-provenance.html) profile described on the [next page](provenance.html). A commit trailer naming the agent is a lighter alternative and is enough for most projects.

### Limits

- An agent does not know what your community agreed in a meeting unless it is written in the repository.
- An agent's knowledge of FHIR tooling has a cut-off date. Skills and the tools' own output are more reliable than its recall.
- A build without errors shows that the guide is technically valid. It does not show that the guide is correct.
