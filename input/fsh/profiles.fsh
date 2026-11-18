Alias: $participant-type = http://terminology.hl7.org/CodeSystem/provenance-participant-type
Alias: $data-operation = http://terminology.hl7.org/CodeSystem/v3-DataOperation
Alias: $obs-value = http://terminology.hl7.org/CodeSystem/v3-ObservationValue
Alias: $ai-device-type = http://terminology.hl7.org/CodeSystem/AIdeviceTypeCS

Profile: AIAgentDevice
Parent: http://hl7.org/fhir/uv/aitransparency/StructureDefinition/AI-Device
Id: ai-agent-device
Title: "AI Agent Device"
Description: "An AI agent that authors or maintains implementation guide content, identified well enough that its contributions can be traced to a product and a model version. It is an AI Device of HL7 AI Transparency on FHIR: `type` holds the HL7 code `Artificial-Intelligence`, and the extension AI Kind holds the kind of agent."
* ^experimental = true
* ^meta.security = $obs-value#AIAST
* extension[aiKind] 1..1 MS
* extension[aiKind] ^short = "Kind of agent"
* extension[aiKind].value[x] from AIAgentTypeVS (required)
* manufacturer 1..1 MS
* manufacturer ^short = "Organisation that provides the agent"
* deviceName 1..* MS
* deviceName ^short = "Product name of the agent"
* type MS
* type ^short = "The HL7 code Artificial-Intelligence, which AI Device requires"
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
Parent: http://hl7.org/fhir/uv/aitransparency/StructureDefinition/AI-Provenance
Id: agent-authoring-provenance
Title: "Agent Authoring Provenance"
Description: "Provenance for implementation guide content that an AI agent authored. It is an AI Provenance of HL7 AI Transparency on FHIR and adds that the AI agent is the author and that at least one human, a Practitioner or PractitionerRole, is the verifier, so that every agent contribution has an accountable reviewer."
* ^experimental = true
* ^meta.security = $obs-value#AIAST
* obeys agent-verifier-human
* extension contains AgentToolUsed named toolUsed 0..* MS
* target ^short = "The IG artifacts the agent created or changed"
* recorded MS
* activity 1..1 MS
* activity ^short = "What the agent did, for example create or update"
* agent[AIagent] ^short = "The AI agent that produced the content"
* agent[AIagent].type = $participant-type#author
* agent[AIagent].who only Reference(AIAgentDevice)
* agent[AIagent].who MS
* agent[AIagent].onBehalfOf MS
* agent[AIagent].onBehalfOf ^short = "The person or organisation that instructed the agent"
* agent[Humanagent] 1..*
* agent[Humanagent] ^short = "The human who reviewed and accepted the content"
* agent[Humanagent].type = $participant-type#verifier
* agent[Humanagent].who only Reference(Practitioner or PractitionerRole)
* agent[Humanagent].who MS
* entity[inputPrompt] ^short = "The prompt the agent worked from"

Invariant: agent-verifier-human
Description: "Every agent with the type verifier is a Practitioner or a PractitionerRole."
Severity: #error
Expression: "agent.where(type.coding.where(system = 'http://terminology.hl7.org/CodeSystem/provenance-participant-type' and code = 'verifier').exists()).all(who.resolve() is Practitioner or who.resolve() is PractitionerRole)"
