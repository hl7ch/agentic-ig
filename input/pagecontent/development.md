This page records how the first version of this guide was developed: the model, the token usage and the prompts. It is meant as a data point for others who plan similar work.

### Model and tools

| Item | Value |
|---|---|
| Agent | Claude Code (command line) |
| Model | Claude Fable 5.2, model id `claude-fable-5-2` |
| Date | 18 November 2026 |
| Sessions | One, on a single machine |
| Build tools | SUSHI 3.21.0, IG Publisher 3.0.4 in the `hl7fhir/ig-publisher-base` container |
| Skills used | None from the [catalogue](catalog.html); the agent worked from the tools' own output |
| Connectors used | Web search and page fetch for the research, GitHub command line for publishing |
{: .grid}

### Token usage

The figures are summed from the session transcript that Claude Code keeps locally. They cover the 31 model calls from the first prompt up to the start of the fifth prompt, which asked for this page.

| Kind | Tokens |
|---|---|
| Input, not cached | 74 |
| Input, written to the prompt cache | 101,021 |
| Input, read from the prompt cache | 3,222,481 |
| Output | 38,792 |
| **Total** | **3,362,368** |
{: .grid}

How to read the figures:

- Almost all input is cache reads. An agent session sends the whole conversation again with every model call, and the prompt cache makes the repeated part cheap. The amount of new content the model read is close to the cache-write figure, about 100,000 tokens.
- The output figure covers everything the model wrote: the FSH, the pages, the shell commands and its replies.
- The transcript does not record the tokens that the web search and page fetch tools spent on summarising pages with a smaller model, so those are not included.
- The work for this page and its publication is not included.

### Prompts

The session had five prompts from the IG editor. They are copied as typed.

**Prompt 1**

```text
can your create a demo FHIR Implementaton Guide focused on maintaining / developing a FHIR IG with agents? You need to do research what current skills/agents are availble and list them in the ig and proivde a guidance how to use them. Verify with FSH and IG Publiser that it has no errors.
```

Result: the research, all pages, the profiles and terminology, the agent set-up files, and a build without errors.

**Prompt 2**

```text
can you change the canonical to ahdis.ch/... and publish it in our repo and add the hl7 ci-build?
```

Result: the agent asked which canonical, repository and publisher to use. The editor dismissed the question and answered with prompt 3.

**Prompt 3**

```text
lets us hl7.ch instead of ahdis.ch
```

Result: the canonical and package id were changed and the sources committed locally. The agent then asked for confirmation before creating a public repository.

**Prompt 4**

```text
yes hl7ch is right, public is fine, make it HL7 Switzerland
```

Result: the publisher was set, the repository created and pushed, the webhook for the HL7 ci-build added, and the build on build.fhir.org confirmed.

**Prompt 5**

```text
thx can you add the token count and model you used for this first development with a copy of the prompts?
```

Result: this page.

### Observations

- One prompt produced the guide. The following prompts dealt with naming and publishing, which are decisions the agent could not take alone.
- The agent needed three full IG Publisher runs for the first version. The first failed on a mistake in the agent's own build script, the second reported one error and 90 warnings, and the third reported no errors.
- The agent stopped twice to ask before acting: once on the choice of canonical and repository, and once before creating a public repository.
