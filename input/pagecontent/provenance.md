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

The base FHIR Provenance resource already allows a Device as an agent, and this profile only narrows that pattern. HL7 publishes [AI Transparency on FHIR](https://build.fhir.org/ig/HL7/aitransparency-ig/branches/main/en/index.html) (STU 1), which records when AI created, updated or manipulated health data in FHIR. This guide applies the same idea to the authoring of specifications. It makes no claim to conform to the HL7 guide.

#### Comparison with AI Transparency on FHIR

The comparison is based on the HL7 overview page and its [AI Device profile](https://build.fhir.org/ig/HL7/aitransparency-ig/branches/main/en/StructureDefinition-AI-Device.html) as read on 18 November 2026. The HL7 guide is a draft build and may change.

| Concept | HL7 AI Transparency | This guide |
|---|---|---|
| Identify the AI system | Profile AIDevice on Device; `Device.type` fixed to the code `Artificial-Intelligence` | [AI Agent Device](StructureDefinition-ai-agent-device.html) on Device; `Device.type` bound to the [AI Agent Type](ValueSet-ai-agent-type.html) value set |
| Kind of AI technology | Extension `aiKind`, preferred binding | Not modelled; the kind of agent is `Device.type` |
| Model documentation | Extension `modelCardDescription`, a reference to a model card | Not modelled |
| Name and version | `deviceName` and `version`, both must-support | `deviceName` and `version`, both required and must-support |
| Who is accountable | AI assertions are declarations of the producing system | A verifier is required in [Agent Authoring Provenance](StructureDefinition-agent-authoring-provenance.html) |
| Subject | Health data in FHIR | Implementation guide content |
{: .grid}

The two guides differ in what they describe. Aligning them would need decisions on the `Device.type` code, on a model card reference and on whether this guide depends on the HL7 guide. These are open and are listed in the pull request.
