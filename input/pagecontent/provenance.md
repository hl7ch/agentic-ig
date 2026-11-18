This guide defines a small model for stating which AI agent authored IG content and who verified it. The model is optional. It is useful when a project must show, for governance or audit, that every agent contribution had an accountable reviewer.

### Artifacts

| Artifact | Purpose |
|---|---|
| [AI Agent Device](StructureDefinition-ai-agent-device.html) | Identifies the agent: product name, provider, kind of agent and the model or product version |
| [Agent Authoring Provenance](StructureDefinition-agent-authoring-provenance.html) | Links the changed artifacts to the agent as author, to a human as verifier and to the prompt the agent worked from |
| [Agent Tool Used](StructureDefinition-agent-tool-used.html) | Extension naming a skill, plugin, MCP server or command line tool the agent used |
| [AI Agent Type](ValueSet-ai-agent-type.html) | Kinds of agent |
| [Agent Tool Type](ValueSet-agent-tool-type.html) | Kinds of capability |
{: .grid}

### Rules the profile enforces

Agent Authoring Provenance derives from AI Provenance of HL7 AI Transparency on FHIR, so every rule and must-support flag of that profile applies. This guide adds rules for IG authoring:

- The AI agent (slice `AIagent`) has the type `author` and the role `Artificial-Intelligence`, and is an [AI Agent Device](StructureDefinition-ai-agent-device.html). At least one is present.
- At least one human agent (slice `Humanagent`) is present. It has the type `verifier` and is a Practitioner or PractitionerRole. The invariant `agent-verifier-human` adds that every agent with the type `verifier` is a Practitioner or PractitionerRole, so an Organization cannot be the verifier. A Provenance without a verifier does not conform, which makes unreviewed agent content visible.
- The activity is stated, so that creating content can be told apart from updating it.
- The `reason` contains `AIAST` ("Artificial Intelligence asserted", code system `http://terminology.hl7.org/CodeSystem/v3-ObservationValue`), as AI Provenance requires, so that the search `Provenance?reason=AIAST` finds the records of this guide as it finds those of HL7 AI Transparency on FHIR.
- The prompt the agent worked from can be referenced as an entity (slice `inputPrompt`) with role `derivation` that points to an AI Input Prompt DocumentReference.
- The AI agent's `onBehalfOf` element is must-support and names the person or organisation that instructed the agent.

### Labelling

Every artifact and example of this guide was created or changed by an AI agent and carries the security label `AIAST` in `meta.security`, as HL7 AI Transparency on FHIR requires for AI-influenced resources. A reader of a single artifact sees that AI was involved without having to find the Provenance.

### Example

The [example provenance](Provenance-ExampleAuthoringProvenance.html) records that the [example coding agent](Device-ExampleCodingAgent.html) created the two profiles of this guide with SUSHI and the IG Publisher, working from the [example input prompt](DocumentReference-ExampleInputPrompt.html). The [reviewer](Practitioner-ExampleReviewer.html) in the example is fictional and stands in for the editor who would verify the content.

### When to use it

Record one Provenance per reviewed change set, for example per merged pull request, and list every changed artifact as a target. Recording one per file adds effort without adding information.

A commit trailer is enough where no formal record is needed:

```text
Co-Authored-By: <agent name and version>
Reviewed-by: <human reviewer>
```

### Relation to other work

The base FHIR Provenance resource already allows a Device as an agent, and this profile only narrows that pattern.

#### HL7 AI Transparency on FHIR

HL7 International is developing [AI Transparency on FHIR](https://build.fhir.org/ig/HL7/aitransparency-ig/branches/main/en/index.html) (package `hl7.fhir.uv.aitransparency`). It records when AI created or changed FHIR health data. This guide records when AI created or changed the artifacts of a specification. Both guides answer the same questions: which AI system was involved, what it worked from, and which human was involved. This guide follows the HL7 guide and depends on its current build, `hl7.fhir.uv.aitransparency#current`. This guide is an experiment and aligns with AI Transparency on FHIR continuously, so it uses the build rather than the published ballot version. [AI Agent Device](StructureDefinition-ai-agent-device.html) derives from AI Device, and [Agent Authoring Provenance](StructureDefinition-agent-authoring-provenance.html) derives from AI Provenance, so a validator checks every agent and every record against the HL7 rules. A change in the HL7 build can change these rules or break the build of this guide. The table compares the two models as described in the current HL7 build.

The HL7 guide defines two levels:

1. **Labelling** is required. Every resource that AI influenced carries the security label `AIAST` ("Artificial Intelligence asserted", code system `http://terminology.hl7.org/CodeSystem/v3-ObservationValue`) in `meta.security`. Individual elements can also be labelled inline.
2. **Provenance** is optional. It names the AI system as a Device, the human in the loop, and the model card and input prompt as entities.

| Concept | AI Transparency on FHIR | This guide |
|---|---|---|
| Marking content as AI-influenced | `AIAST` in `meta.security` of every affected resource; required; AI Provenance warns when a target lacks it (invariant `ai-target-aiast`) | `AIAST` in `meta.security` of every artifact and example of this guide; the warning of AI Provenance applies |
| Provenance profile | AI Provenance; `reason` must contain `AIAST`; `target` 1..* | [Agent Authoring Provenance](StructureDefinition-agent-authoring-provenance.html), derived from AI Provenance; adds `activity` 1..1 |
| AI system | AI Device; `type` fixed to `Artificial-Intelligence`; the kind of AI goes in the extension AI Kind (0..*, preferred binding) | [AI Agent Device](StructureDefinition-ai-agent-device.html), derived from AI Device; the extension AI Kind is 1..1 and bound (required) to [AI Agent Type](ValueSet-ai-agent-type.html): coding agent, chat assistant or CI agent |
| Kind of AI | Classification by technical model, behaviour, clinical scenario and data type, for example `Large-Language-Models` | Classification by how the agent works in the IG repository |
| AI participant in Provenance | Agent slice `AIagent` with `role` `Artificial-Intelligence` and `who` an AI Device | The same slice; `type` is `author` and `who` an AI Agent Device |
| Human in the loop | Agent slice `Humanagent`, 0..*; Practitioner, PractitionerRole, RelatedPerson or Patient | The same slice, 1..*; `type` is `verifier`; Practitioner or PractitionerRole; no Organization |
| Who instructed the agent | Not modelled separately | `agent.onBehalfOf` of the AI agent |
| Model description | Model card as a DocumentReference, in Hugging Face or CHAI format, as an entity or a Device extension | Taken over, not used in the examples; `Device.version` names the model |
| Input prompt | Entity slice `inputPrompt` with role `derivation` and an AI Input Prompt DocumentReference | Taken over; the prompts are on the [development](development.html) page |
| Tools the AI used | Not modelled | Extension [Agent Tool Used](StructureDefinition-agent-tool-used.html) |
| Element-level detail | Inline labels, and the `targetElement` or `targetPath` extensions on `Provenance.target` | Not needed; a target is a whole artifact |
{: .grid}

#### Alignment

These steps adopt the HL7 concepts:

1. **Label agent-authored artifacts.** Done. Every artifact and example carries `AIAST` in `meta.security`.
2. **Add the reason.** Done. `Provenance.reason` must contain `AIAST`.
3. **Build on the HL7 profiles.** Done. This guide depends on the current HL7 build, `hl7.fhir.uv.aitransparency#current`. AI Agent Device derives from AI Device: `Device.type` holds the HL7 code `Artificial-Intelligence`, and the extension AI Kind holds the AI Agent Type code. Agent Authoring Provenance derives from AI Provenance. The published ballot version `1.0.0-ballot` could not be used, because it has no slice for a human agent and would reject the verifier.
4. **Record the prompt.** Done. The Provenance can reference the prompt as an entity with role `derivation`, and the example does so.
5. **Keep what is specific to IG authoring.** Done. The required verifier, `onBehalfOf` and the Agent Tool Used extension stay. The HL7 guide does not cover them.

The verifier no longer allows an Organization, so it does not conflict with the human agent of the current AI Provenance.

Two sources are not stable yet. The current HL7 build changes without notice, and the only package in the registry is `1.0.0-ballot`, which differs from it. The HL7 code systems `AIdeviceTypeCS` and `AIinputsCS` use `terminology.hl7.org` URLs, but the terminology server at tx.fhir.org could not look up their codes on 18 November 2026. The codes `Artificial-Intelligence` and `AIInputPrompt` are taken from the HL7 package. The code `AIAST` was found on tx.fhir.org.
