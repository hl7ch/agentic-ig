Anyone can propose an addition to this guide with a GitHub issue. An AI agent turns an accepted issue into a pull request, and a human reviews the pull request before it is merged. This page describes the set-up so that other IG projects can copy it.

### How to contribute

1. Open an issue in the [repository](https://github.com/hl7ch/agentic-ig/issues/new/choose). Use "Add or correct a catalogue entry" for a skill, plugin, MCP server or tool, and "Feature request" for anything else.
2. The agent starts at once, implements the issue, and a pull request appears, linked to the issue. If the agent finds the issue unclear or out of scope, it makes no change and says why in a comment.
3. A maintainer reviews the pull request and merges it or asks for changes.

### What happens in a run

| Step | Done by | Detail |
|---|---|---|
| Start | Contributor | Opens an issue. Every new issue starts a run. A maintainer can start a further run by adding the label `agent`. |
| Prepare | Workflow | Checks out the repository, installs SUSHI, Jekyll and the IG Publisher on the runner, and writes the issue with all its comments to a file for the agent. |
| Implement | Agent | Follows the `issue-to-pr` skill: classifies the issue, checks sources, edits the files, builds, and writes a summary. |
| Report | Workflow | Reads the model and the token counts from the agent's run log. |
| Open pull request | Workflow | Commits the changes to the branch `agent-issue-<number>` and opens the pull request with the agent's summary, the QA counts and the usage report. |
| Check | HL7 ci-build | Builds the branch on build.fhir.org after the push. The pull request links to the rendered guide and the QA report of the branch. |
| Review | Maintainer | Reads the diff and the rendered pages, then merges. |
{: .grid}

### Files that make up the set-up

| File | Purpose |
|---|---|
| `.github/ISSUE_TEMPLATE/` | Issue forms that collect what the agent needs |
| `.github/workflows/agent-issue-to-pr.yml` | Runs the agent on every new issue and opens the pull request |
| `.github/scripts/install-toolchain.sh` | Installs the build tools on the runner |
| `.github/scripts/agent-usage.py` | Turns the agent's run log into the usage report |
| `.claude/skills/issue-to-pr/SKILL.md` | Tells the agent how to implement an issue |
| `.claude/skills/ig-qa-loop/SKILL.md` | Tells the agent how to build and fix QA errors |
| `AGENTS.md` | Build commands, layout, conventions and limits for every agent |
{: .grid}

### What the agent knows

The agent starts with no memory of earlier runs. Everything it knows about this guide comes from three files in the repository: `AGENTS.md` for the build commands and conventions, the `ig-qa-loop` skill for the build loop, and the `issue-to-pr` skill for this workflow. When a run goes wrong because the agent lacked knowledge, the fix is a change to one of these files.

### Model and token report

Every pull request the agent opens ends with a usage report: the model, the input, cache and output tokens, the number of turns and the duration. The workflow computes it from the run log, so the figures do not depend on what the agent says about itself. The same report is posted on the issue, also when the agent made no change.

### Authentication

The agent runs with [Claude Code GitHub Actions](https://code.claude.com/docs/en/github-actions). It needs one repository secret:

- `CLAUDE_CODE_OAUTH_TOKEN`: a token tied to a Claude subscription, created with `claude setup-token`. Runs then count against that person's subscription and no API key is needed.
- `ANTHROPIC_API_KEY`: an API key, billed per token. Use this, or workload identity federation, when the set-up should not depend on one person.

The model is the Claude Code default. Set the repository variable `AGENT_MODEL` to a model id to choose another one.

### Safeguards

- **Runs are bounded.** Each run is limited to 120 agent turns and 60 minutes, and runs for the same issue do not overlap.
- **The agent has a narrow tool set.** It can read and edit files, search and fetch web pages, and run the two build commands. It has no general shell, so it cannot read the token from the environment or push.
- **The agent cannot change its own rules.** The skill forbids changes to workflows, skills, build scripts and instruction files, and the workflow discards any such change before it commits.
- **The build is checked twice.** The agent builds during its run, and the HL7 ci-build builds the branch again. The ci-build does not set a status on the pull request, so the reviewer opens the linked QA report.
- **Nothing merges without a human.** The agent opens pull requests and never merges them.

Issue text and fetched web pages are untrusted input. The safeguards reduce what a manipulated agent can do; they do not remove the need to read the diff.

This project starts the agent on every new issue, without a maintainer reading it first. That is the shortest path for contributors, and it has a cost: anyone with a GitHub account can start runs on the project's Claude account, and the first reader of an issue is the agent. A project that cannot accept this should start runs from a label that only maintainers can add; the workflow file says which two lines to change.

### Limits

- A run reads the issue and the comments that exist when it starts. To add information afterwards, comment on the issue and ask a maintainer to add the label `agent`, which starts a new run. If the label is already there, the maintainer removes it and adds it again.
- Labelling the same issue again starts a new run that replaces the branch and updates the pull request.
- The agent does not respond to review comments on the pull request. Push fixes to the branch yourself or refine the issue and start a new run with the label.
