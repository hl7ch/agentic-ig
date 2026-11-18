Instance: ExampleCodingAgent
InstanceOf: AIAgentDevice
Usage: #example
Title: "Example coding agent"
Description: "The coding agent that drafted this implementation guide."
* meta.security = $obs-value#AIAST
* manufacturer = "Anthropic"
* deviceName.name = "Claude Code"
* deviceName.type = #user-friendly-name
* type.coding[0] = http://hl7.org/fhir/uv/aitransparency/CodeSystem/AIdeviceTypeCS#Artificial-Intelligence
* type.coding[+] = AIAgentTypeCS#coding-agent
* version.value = "claude-fable-5-2"

Instance: ExampleReviewer
InstanceOf: Practitioner
Usage: #example
Title: "Example reviewer"
Description: "A fictional IG editor who instructs the agent and verifies its output."
* meta.security = $obs-value#AIAST
* name.family = "Reviewer"
* name.given = "Example"

Instance: ExampleAuthoringProvenance
InstanceOf: AgentAuthoringProvenance
Usage: #example
Title: "Example authoring provenance"
Description: "Illustrates how to record that an agent created the profiles of this guide with SUSHI and the IG Publisher, and that a human verified them. The reviewer is fictional."
* meta.security = $obs-value#AIAST
* target[0] = Reference(StructureDefinition/ai-agent-device)
* target[+] = Reference(StructureDefinition/agent-authoring-provenance)
* recorded = "2026-11-18T18:00:00+01:00"
* activity = $data-operation#CREATE
* reason[aiReason] = $obs-value#AIAST
* entity[inputPrompt].role = #derivation
* entity[inputPrompt].what = Reference(ExampleInputPrompt)
* agent[author].who = Reference(ExampleCodingAgent)
* agent[author].onBehalfOf = Reference(ExampleReviewer)
* agent[verifier].who = Reference(ExampleReviewer)
* extension[toolUsed][0].extension[type].valueCode = #cli-tool
* extension[toolUsed][=].extension[name].valueString = "SUSHI"
* extension[toolUsed][=].extension[source].valueUrl = "https://github.com/FHIR/sushi"
* extension[toolUsed][+].extension[type].valueCode = #cli-tool
* extension[toolUsed][=].extension[name].valueString = "IG Publisher"
* extension[toolUsed][=].extension[source].valueUrl = "https://github.com/HL7/fhir-ig-publisher"
* extension[toolUsed][+].extension[type].valueCode = #instruction-file
* extension[toolUsed][=].extension[name].valueString = "AGENTS.md"

Instance: ExampleInputPrompt
InstanceOf: DocumentReference
Usage: #example
Title: "Example input prompt"
Description: "The prompts that the coding agent worked from, published on the development page of this guide."
* meta.security = $obs-value#AIAST
* status = #current
* description = "Prompts given to the coding agent while it drafted this implementation guide"
* content.attachment.contentType = #text/html
* content.attachment.url = "https://build.fhir.org/ig/hl7ch/agentic-ig/development.html"
* content.attachment.title = "How This Guide Was Developed"
