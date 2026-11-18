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

- The author is an [AI Agent Device](StructureDefinition-ai-agent-device.html), with at least one author present.
- At least one verifier is present, and the verifier is a human: a Practitioner or PractitionerRole. An Organization is not allowed as verifier, as in the human agent of HL7 AI Provenance. A Provenance without a verifier does not conform, which makes unreviewed agent content visible.
- The activity is stated, so that creating content can be told apart from updating it.
- The `reason` contains `AIAST` ("Artificial Intelligence asserted", code system `http://terminology.hl7.org/CodeSystem/v3-ObservationValue`), so that the search `Provenance?reason=AIAST` finds the records of this guide as it finds those of HL7 AI Transparency on FHIR.
- The prompt the agent worked from can be referenced as an entity with role `derivation` that points to a DocumentReference.
- The agent's `onBehalfOf` element is must-support and names the person or organisation that instructed the agent.

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

HL7 International is developing [AI Transparency on FHIR](https://build.fhir.org/ig/HL7/aitransparency-ig/branches/main/en/index.html) (package `hl7.fhir.uv.aitransparency`). It records when AI created or changed FHIR health data. This guide records when AI created or changed the artifacts of a specification. Both guides answer the same questions: which AI system was involved, what it worked from, and which human was involved. This guide follows the HL7 guide in labelling, the Provenance reason, the human verifier and the input prompt. It depends on the HL7 package `hl7.fhir.uv.aitransparency#1.0.0-ballot`. [AI Agent Device](StructureDefinition-ai-agent-device.html) derives from AI Device, so a validator checks every agent against the HL7 rules. [Agent Authoring Provenance](StructureDefinition-agent-authoring-provenance.html) does not derive from AI Provenance yet; see step 3 below. The table compares the two models as described in the current HL7 build.

The HL7 guide defines two levels:

1. **Labelling** is required. Every resource that AI influenced carries the security label `AIAST` ("Artificial Intelligence asserted", code system `http://terminology.hl7.org/CodeSystem/v3-ObservationValue`) in `meta.security`. Individual elements can also be labelled inline.
2. **Provenance** is optional. It names the AI system as a Device, the human in the loop, and the model card and input prompt as entities.

| Concept | AI Transparency on FHIR | This guide |
|---|---|---|
| Marking content as AI-influenced | `AIAST` in `meta.security` of every affected resource; required | `AIAST` in `meta.security` of every artifact and example of this guide; the profiles do not require it |
| Provenance profile | AI Provenance; `reason` must contain `AIAST`; `target` 1..* | [Agent Authoring Provenance](StructureDefinition-agent-authoring-provenance.html); `reason` must contain `AIAST`; `activity` 1..1 |
| AI system | AI Device; `type` fixed to `Artificial-Intelligence`; the kind of AI goes in the extension AI Kind (preferred binding) | [AI Agent Device](StructureDefinition-ai-agent-device.html), derived from AI Device; `type` holds `Artificial-Intelligence` and a second coding bound (required) to [AI Agent Type](ValueSet-ai-agent-type.html): coding agent, chat assistant or CI agent |
| Kind of AI | Classification by technical model, behaviour, clinical scenario and data type, for example `Large-Language-Models` | Classification by how the agent works in the IG repository |
| AI participant in Provenance | Agent slice with `role` `Artificial-Intelligence` and `who` an AI Device | Agent slice `author` with `type` `author` and `who` an AI Agent Device |
| Human in the loop | Agent slice, 0..*; Practitioner, PractitionerRole, RelatedPerson or Patient | Agent slice `verifier`, 1..*; Practitioner or PractitionerRole; no Organization |
| Who instructed the agent | Not modelled separately | `agent.onBehalfOf` of the author |
| Model description | Model card as a DocumentReference, in Hugging Face or CHAI format, as an entity or a Device extension | Not modelled; `Device.version` names the model |
| Input prompt | Input prompt as a DocumentReference with role `derivation` | Entity slice `inputPrompt` with role `derivation` and `what` a DocumentReference; the prompts are on the [development](development.html) page |
| Tools the AI used | Not modelled | Extension [Agent Tool Used](StructureDefinition-agent-tool-used.html) |
| Element-level detail | Inline labels, and the `targetElement` or `targetPath` extensions on `Provenance.target` | Not needed; a target is a whole artifact |
{: .grid}

#### Alignment

These steps adopt the HL7 concepts:

1. **Label agent-authored artifacts.** Done. Every artifact and example carries `AIAST` in `meta.security`.
2. **Add the reason.** Done. `Provenance.reason` must contain `AIAST`.
3. **Build on the HL7 profiles.** Partly done. This guide depends on `hl7.fhir.uv.aitransparency#1.0.0-ballot`, the only version in the package registry. AI Agent Device derives from AI Device. `Device.type` holds the HL7 code `Artificial-Intelligence`, which AI Device requires, and the AI Agent Type code as a second coding. Agent Authoring Provenance cannot derive from AI Provenance in this version. Its agents are sliced by profile on `who`, not on `who.resolve()`, so the validator matches every agent, a human verifier too, to the slice for the AI system and then rejects the human. The same happens to the input prompt entity and the model card slice. The current HL7 build has a separate slice for the human agent and the input prompt; the derivation can follow once a version with these changes is published.
4. **Record the prompt.** Done. The Provenance can reference the prompt as an entity with role `derivation`, and the example does so.
5. **Keep what is specific to IG authoring.** Done. The required verifier, `onBehalfOf` and the Agent Tool Used extension stay. The HL7 guide does not cover them.

The verifier no longer allows an Organization, so it does not conflict with the human agent of the current AI Provenance.

Two sources are not stable yet. The only package in the registry is `1.0.0-ballot`, and it differs from the current HL7 build. The HL7 code systems `AIdeviceTypeCS` and `AIinputsCS` use `terminology.hl7.org` URLs, but the terminology server at tx.fhir.org could not look up their codes on 18 November 2026. The code `AIAST` was found there.
