This guide defines a small model for stating which AI agent authored IG content and who verified it. The model is optional. It is useful when a project must show, for governance or audit, that every agent contribution had an accountable reviewer.

### Artifacts

| Artifact | Purpose |
|---|---|
| [AI Agent Device](StructureDefinition-ai-agent-device.html) | Identifies the agent: product name, provider, kind of agent and the model or product version |
| [Agent Authoring Provenance](StructureDefinition-agent-authoring-provenance.html) | Links the changed artifacts to the agent as author and to a human or organisation as verifier |
| [Agent Tool Used](StructureDefinition-agent-tool-used.html) | Extension naming a skill, plugin, MCP server or command line tool the agent used |
| [AI Agent Type](ValueSet-ai-agent-type.html) | Kinds of agent |
| [Agent Tool Type](ValueSet-agent-tool-type.html) | Kinds of capability |
{: .grid}

### Rules the profile enforces

- The author is an [AI Agent Device](StructureDefinition-ai-agent-device.html), with at least one author present.
- At least one verifier is present, and the verifier is a Practitioner, PractitionerRole or Organization. A Provenance without a verifier does not conform, which makes unreviewed agent content visible.
- The activity is stated, so that creating content can be told apart from updating it.
- The agent's `onBehalfOf` element is must-support and names the person or organisation that instructed the agent.

### Example

The [example provenance](Provenance-ExampleAuthoringProvenance.html) records that the [example coding agent](Device-ExampleCodingAgent.html) created the two profiles of this guide with SUSHI and the IG Publisher. The [reviewer](Practitioner-ExampleReviewer.html) in the example is fictional and stands in for the editor who would verify the content.

### When to use it

Record one Provenance per reviewed change set, for example per merged pull request, and list every changed artifact as a target. Recording one per file adds effort without adding information.

A commit trailer is enough where no formal record is needed:

```text
Co-Authored-By: <agent name and version>
Reviewed-by: <human reviewer>
```

### Relation to other work

The base FHIR Provenance resource already allows a Device as an agent, and this profile only narrows that pattern. HL7 projects on AI transparency address AI-generated content in clinical data. This guide applies the same idea to the authoring of specifications and makes no claim to align with those projects.
