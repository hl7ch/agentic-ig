CodeSystem: AIAgentTypeCS
Id: ai-agent-type
Title: "AI Agent Type"
Description: "Kinds of AI agent that can contribute to an implementation guide."
* ^caseSensitive = true
* ^experimental = true
* #coding-agent "Coding agent" "An agent that reads and edits the IG source in a working copy and runs the build tools itself, for example from a terminal or an IDE."
* #chat-assistant "Chat assistant" "A conversational assistant that proposes content which a human copies into the IG source."
* #ci-agent "CI agent" "An agent that runs unattended in a build pipeline, for example to triage QA results or to open pull requests."

ValueSet: AIAgentTypeVS
Id: ai-agent-type
Title: "AI Agent Type"
Description: "All kinds of AI agent that can contribute to an implementation guide."
* ^experimental = true
* include codes from system AIAgentTypeCS

CodeSystem: AgentToolTypeCS
Id: agent-tool-type
Title: "Agent Tool Type"
Description: "Kinds of capability an AI agent can be given when it works on an implementation guide."
* ^caseSensitive = true
* ^experimental = true
* #skill "Skill" "A folder with a SKILL.md file holding instructions, references and scripts that the agent loads when a task calls for it."
* #plugin "Plugin" "An installable bundle of skills, commands, subagents or MCP server configurations, distributed through a marketplace."
* #mcp-server "MCP server" "A Model Context Protocol server that offers the agent tools, for example validation or terminology lookup."
* #subagent "Subagent" "A separately configured agent that the main agent delegates a bounded task to."
* #slash-command "Slash command" "A named prompt stored in the repository that a user invokes explicitly."
* #instruction-file "Instruction file" "A file such as AGENTS.md or CLAUDE.md that gives every agent session the project conventions."
* #cli-tool "Command line tool" "A conventional build or validation tool that the agent runs in a shell, such as SUSHI or the IG Publisher."

ValueSet: AgentToolTypeVS
Id: agent-tool-type
Title: "Agent Tool Type"
Description: "All kinds of capability an AI agent can be given when it works on an implementation guide."
* ^experimental = true
* include codes from system AgentToolTypeCS
