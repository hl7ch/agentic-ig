Anyone can propose an addition to this guide with a GitHub issue. An AI agent turns an accepted issue into a pull request, and a human reviews the pull request before it is merged. This page describes the set-up so that other IG projects can copy it.

### How to contribute

1. Open an issue in the [repository](https://github.com/hl7ch/agentic-ig/issues/new/choose). Use "Add or correct a catalogue entry" for a skill, plugin, MCP server or tool, and "Feature request" for anything else.
2. A maintainer reads the issue. If it is in scope, the maintainer adds the label `agent`.
3. The agent implements the issue and a pull request appears, linked to the issue.
4. A maintainer reviews the pull request and merges it or asks for changes.

### What happens in a run

| Step | Done by | Detail |
|---|---|---|
| Start | Maintainer | Adds the label `agent`. The run is rejected unless the person who added the label has write access. |
| Prepare | Workflow | Checks out the repository and installs SUSHI, Jekyll and the IG Publisher on the runner. |
| Implement | Agent | Follows the `issue-to-pr` skill: classifies the issue, checks sources, edits the files, builds, and writes a summary. |
| Report | Workflow | Reads the model and the token counts from the agent's run log. |
| Open pull request | Workflow | Commits the changes to the branch `agent/issue-<number>` and opens the pull request with the agent's summary, the QA counts and the usage report. |
| Check | Build workflow | Builds the pull request again, independently of the agent, and fails on any IG Publisher error. |
| Review | Maintainer | Reads the diff and the rendered pages, then merges. |
{: .grid}

### Files that make up the set-up

| File | Purpose |
|---|---|
| `.github/ISSUE_TEMPLATE/` | Issue forms that collect what the agent needs |
| `.github/workflows/agent-issue-to-pr.yml` | Runs the agent on a labelled issue and opens the pull request |
| `.github/workflows/build.yml` | Builds every pull request and the main branch |
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

- **A maintainer starts every run.** Opening an issue does not start the agent, so an outsider cannot spend the project's tokens or steer the agent without a maintainer reading the issue first.
- **The agent has a narrow tool set.** It can read and edit files, search and fetch web pages, and run the two build commands. It has no general shell, so it cannot read the token from the environment or push.
- **The agent cannot change its own rules.** The skill forbids changes to workflows, skills, build scripts and instruction files, and the workflow discards any such change before it commits.
- **The build is checked twice.** The agent builds during its run, and the build workflow builds the pull request again.
- **Nothing merges without a human.** The agent opens pull requests and never merges them.

Issue text and fetched web pages are untrusted input. The safeguards reduce what a manipulated agent can do; they do not remove the need to read the diff.

### Limits

- A run handles the issue title and body. It does not read later comments on the issue.
- Labelling the same issue again starts a new run that replaces the branch and updates the pull request.
- The agent does not respond to review comments on the pull request. Push fixes to the branch yourself or refine the issue and label it again.
