Alias: $participant-type = http://terminology.hl7.org/CodeSystem/provenance-participant-type
Alias: $data-operation = http://terminology.hl7.org/CodeSystem/v3-DataOperation
Alias: $obs-value = http://terminology.hl7.org/CodeSystem/v3-ObservationValue

Profile: AIAgentDevice
Parent: http://hl7.org/fhir/uv/aitransparency/StructureDefinition/AI-Device
Id: ai-agent-device
Title: "AI Agent Device"
Description: "An AI agent that authors or maintains implementation guide content, identified well enough that its contributions can be traced to a product and a model version. It is an AI Device of HL7 AI Transparency on FHIR: `type` holds the HL7 code `Artificial-Intelligence` and a code for the kind of agent."
* ^experimental = true
* ^meta.security = $obs-value#AIAST
* manufacturer 1..1 MS
* manufacturer ^short = "Organisation that provides the agent"
* deviceName 1..* MS
* deviceName ^short = "Product name of the agent"
* type 1..1 MS
* type from AIAgentTypeVS (required)
* type ^short = "Kind of agent, together with the HL7 code Artificial-Intelligence"
* version 1..* MS
* version ^short = "Model or product version that produced the content"

Extension: AgentToolUsed
Id: agent-tool-used
Title: "Agent Tool Used"
Description: "A skill, plugin, MCP server or other capability that the agent used during the recorded activity."
Context: Provenance
* ^experimental = true
* ^meta.security = $obs-value#AIAST
* extension contains
    type 1..1 and
    name 1..1 and
    source 0..1
* extension[type] ^short = "Kind of capability"
* extension[type].value[x] only code
* extension[type].valueCode from AgentToolTypeVS (required)
* extension[name] ^short = "Name of the capability as the agent knows it"
* extension[name].value[x] only string
* extension[source] ^short = "Where the capability was obtained from"
* extension[source].value[x] only url

Profile: AgentAuthoringProvenance
Parent: Provenance
Id: agent-authoring-provenance
Title: "Agent Authoring Provenance"
Description: "Provenance for implementation guide content that an AI agent authored. It requires the agent as author, at least one human as verifier, so that every agent contribution has an accountable reviewer, and the reason AIAST as in HL7 AI Transparency on FHIR."
* ^experimental = true
* ^meta.security = $obs-value#AIAST
* reason ^slicing.discriminator.type = #pattern
* reason ^slicing.discriminator.path = "$this"
* reason ^slicing.rules = #open
* reason ^slicing.description = "Slice by the reason code"
* reason contains aiReason 1..1
* reason[aiReason] = $obs-value#AIAST
* reason[aiReason] ^short = "Marks the record as content asserted by AI"
* extension contains AgentToolUsed named toolUsed 0..* MS
* target MS
* target ^short = "The IG artifacts the agent created or changed"
* recorded MS
* activity 1..1 MS
* activity ^short = "What the agent did, for example create or update"
* agent ^slicing.discriminator.type = #pattern
* agent ^slicing.discriminator.path = "type"
* agent ^slicing.rules = #open
* agent ^slicing.description = "Slice by the role the participant played"
* agent contains
    author 1..* MS and
    verifier 1..* MS
* agent[author] ^short = "The AI agent that produced the content"
* agent[author].type 1..1 MS
* agent[author].type = $participant-type#author
* agent[author].who only Reference(AIAgentDevice)
* agent[author].who MS
* agent[author].onBehalfOf MS
* agent[author].onBehalfOf ^short = "The person or organisation that instructed the agent"
* agent[verifier] ^short = "The human who reviewed and accepted the content"
* agent[verifier].type 1..1 MS
* agent[verifier].type = $participant-type#verifier
* agent[verifier].who only Reference(Practitioner or PractitionerRole)
* agent[verifier].who MS
* entity ^slicing.discriminator.type = #profile
* entity ^slicing.discriminator.path = "what.resolve()"
* entity ^slicing.rules = #open
* entity ^slicing.description = "Slice by the kind of resource the entity refers to"
* entity contains inputPrompt 0..*
* entity[inputPrompt] ^short = "The prompt the agent worked from"
* entity[inputPrompt].role = #derivation
* entity[inputPrompt].what only Reference(DocumentReference)
