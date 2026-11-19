Anyone can propose an addition to this guide with a GitHub issue. An AI agent turns the issue into a pull request and responds to comments on it, and a human reviews the pull request before it is merged. This page describes the set-up so that other IG projects can copy it.

### How to contribute

1. Open an issue in the [repository](https://github.com/hl7ch/agentic-ig/issues/new/choose). Use "Add or correct a catalogue entry" for a skill, plugin, MCP server or tool, and "Feature request" for anything else.
2. Until 25 November 2026, the agent starts at once. From 26 November 2026, a maintainer reads the issue first and approves it with the label `agent`.
3. The agent implements the issue, and a pull request appears, linked to the issue. If the agent finds the issue unclear or out of scope, it makes no change and says why in a comment.
4. A maintainer reviews the pull request. A comment or a review on the pull request starts the agent again, and it pushes a further commit in response.
5. The maintainer merges the pull request.

### What happens in a run

| Step | Done by | Detail |
|---|---|---|
| Start | Contributor or maintainer | Until 25 November 2026 every new issue starts a run. Afterwards a maintainer starts the run by adding the label `agent`, and the run is rejected unless that person has write access. The label also starts a further run at any time. |
| Prepare | Workflow | Checks out the repository, installs SUSHI, Jekyll and the IG Publisher on the runner, and writes the issue with all its comments to a file for the agent. |
| Announce | Workflow | Comments on the issue that an agent has picked it up, with the model and the address where the ci-build will publish the branch. |
| Implement | Agent | Follows the `issue-to-pr` skill: classifies the issue, checks sources, edits the files, builds, and writes a summary. |
| Report | Workflow | Reads the model and the token counts from the agent's run log. |
| Open pull request | Workflow | Commits the changes to the branch `agent-issue-<number>` and opens the pull request with the agent's summary, the QA counts and the usage report. |
| Check | HL7 ci-build | Builds the branch on build.fhir.org after the push. The pull request links to the rendered guide and the QA report of the branch. |
| Review | Maintainer | Reads the diff and the rendered pages, then merges or comments. |
| Follow-up | Agent and workflow | Every comment and every review on the pull request starts a further run. The workflow first merges the main branch into the branch, and the agent resolves any conflict. The agent then reads all comments, the workflow pushes one more commit to the branch and posts the agent's response, with the usage report, on the pull request. |
{: .grid}

### Files that make up the set-up

| File | Purpose |
|---|---|
| `.github/ISSUE_TEMPLATE/` | Issue forms that collect what the agent needs |
| `.github/workflows/agent-issue-to-pr.yml` | Decides whether a run starts, runs the agent and opens the pull request |
| `.github/workflows/agent-pr-follow-up.yml` | Runs the agent on every comment or review of a pull request |
| `.github/scripts/agent-pr-context.sh` | Collects the issue and all pull request comments for a follow-up run |
| `.github/scripts/install-toolchain.sh` | Installs the build tools on the runner |
| `.github/scripts/agent-roles.sh` | Tells the agent who is a maintainer, from the write access to the repository |
| `.github/scripts/agent-usage.py` | Turns the agent's run log into the usage report |
| `.claude/skills/issue-to-pr/SKILL.md` | Tells the agent how to implement an issue and how to respond to pull request comments |
| `.claude/skills/ig-qa-loop/SKILL.md` | Tells the agent how to build and fix QA errors |
| `AGENTS.md` | Build commands, layout, conventions and limits for every agent |
{: .grid}

### What the agent knows

The agent starts with no memory of earlier runs. Everything it knows about this guide comes from three files in the repository: `AGENTS.md` for the build commands and conventions, the `ig-qa-loop` skill for the build loop, and the `issue-to-pr` skill for this workflow. When a run goes wrong because the agent lacked knowledge, the fix is a change to one of these files.

### Who counts as a maintainer

The agent treats a person as a maintainer when that person has write access to the repository. The workflow looks this up for everyone who wrote on the issue or the pull request and gives the agent the list. It does not use the role label that GitHub attaches to a comment: for a person whose organisation membership is private, a workflow sees that label as "contributor", and the agent then wrongly reported that no maintainer had commented.

### Notifications

The workflow posts two comments per run, on the issue for a first run and on the pull request for a follow-up run:

- at the start, that an agent has picked up the work, with the model and the ci-build address of the branch
- at the end, the result, with the pull request or commit, the ci-build links and the usage report

The closing comment mentions the person who opened the issue and the person who started the run, so GitHub notifies them in the way they have configured, by e-mail or in the web interface.

These comments cannot start another agent run. They are posted with the workflow's own token, and GitHub starts no workflow for events from that token. The follow-up workflow also ignores every comment from a bot account.

### Model and token report

Every pull request the agent opens ends with a usage report: the model, the input, cache and output tokens, the number of turns and the duration. The workflow computes it from the run log, so the figures do not depend on what the agent says about itself. The same report is posted on the issue, also when the agent made no change, and every follow-up run posts its own report on the pull request.

### Authentication

The agent runs with [Claude Code GitHub Actions](https://code.claude.com/docs/en/github-actions). It needs one repository secret:

- `CLAUDE_CODE_OAUTH_TOKEN`: a token tied to a Claude subscription, created with `claude setup-token`. Runs then count against that person's subscription and no API key is needed.
- `ANTHROPIC_API_KEY`: an API key, billed per token. Use this, or workload identity federation, when the set-up should not depend on one person.

The model is Claude Opus 5.5 (`claude-opus-5-5`). Set the repository variable `AGENT_MODEL` to a model id to choose another one.

### Safeguards

- **Runs are bounded.** Each run is limited to 120 agent turns and 60 minutes, and runs for the same issue or the same pull request do not overlap.
- **The agent has a narrow tool set.** It can read and edit files, search and fetch web pages, and run the two build commands. It has no general shell, so it cannot read the token from the environment or push.
- **The agent cannot change its own rules.** The skill forbids changes to workflows, skills, build scripts and instruction files, and the workflow discards any such change before it commits.
- **The build is checked twice.** The agent builds during its run, and the HL7 ci-build builds the branch again. The ci-build does not set a status on the pull request, so the reviewer opens the linked QA report.
- **Pull requests stay mergeable.** A new pull request starts from the current main branch. When the main branch moves on, the next follow-up run merges it into the pull request branch, and the agent resolves conflicts in the content. A conflict in a file the agent may not change is left for a maintainer, and the run says so. The change log is merged without the agent: when two branches add lines to it, git keeps the lines of both (`merge=union` in `.gitattributes`). GitHub's own conflict check may not apply this rule, so a pull request can still show a conflict in the change log until a follow-up run has merged the main branch.
- **Nothing merges without a human.** The agent opens pull requests and never merges them.

Issue text and fetched web pages are untrusted input. The safeguards reduce what a manipulated agent can do; they do not remove the need to read the diff.

This project ran a one-week trial, until 25 November 2026, in which every new issue started the agent without a maintainer reading it first. That is the shortest path for contributors, and it has a cost: anyone with a GitHub account can start runs on the project's Claude account, and the first reader of an issue is the agent. After the trial a maintainer approves each issue with the label `agent`. The end date is a single value, `OPEN_INTAKE_UNTIL`, in the workflow file, and the workflow switches by itself.

### What the agent may change

The agent may change everything under `input/`: pages, profiles, extensions, terminology and examples. It implements a cardinality, must-support flag, binding or code when the issue or a comment states it, and lists each such change for the reviewer. It does not choose such a value on its own when nobody stated one; it then asks. It may not change workflows, skills, build scripts or instruction files.

Every issue that a pull request covers gets its own line in the [change log](changes.html), with a link to the issue. This also holds for issues and requests that come in later through comments on the pull request.

### Limits

- A run reads the issue and the comments that exist when it starts. To add information afterwards, comment on the issue and ask a maintainer to add the label `agent`, which starts a new run. If the label is already there, the maintainer removes it and adds it again.
- Labelling the same issue again starts a new run that replaces the branch and updates the pull request.
- Every comment on a pull request starts a follow-up run, also a comment that asks for nothing. Such a run ends with a short reply and still uses tokens. Runs for the same pull request queue up, and each one reads all comments.
- A review that approves the pull request does not start a run.
- A pull request is brought up to date with the main branch only when a follow-up run starts. If the main branch has moved on since the last run and the pull request shows a conflict, any comment on it starts a run that merges and resolves.
- Follow-up runs work on every open pull request from a branch of this repository, also one a person opened, and the agent pushes its commit to that branch. Pull requests from forks are ignored.
- Until 25 November 2026 anyone's comment starts a follow-up run. Afterwards the run is rejected unless the commenter has write access.
- A new run from the issue label replaces the branch, including follow-up commits and commits you pushed yourself.
