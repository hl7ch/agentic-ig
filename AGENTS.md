# Agent instructions

This repository is a FHIR R4 implementation guide written in FHIR Shorthand (FSH).

## Build

- `./_build.sh sushi` compiles FSH only. Run it after every FSH edit. It must report 0 errors and 0 warnings.
- `./_build.sh` runs SUSHI and the IG Publisher. It takes several minutes. It runs the tools directly when SUSHI and Jekyll are installed, as on the GitHub runner, and in a Docker container otherwise. Run it before you report a change as done.
- After a full build, read `output/qa.json` (`errs`, `warnings`, `hints`) and `output/qa.html` for the messages. `errs` must be 0.
- Run only one full build at a time in a working copy.

## Layout

- `sushi-config.yaml`: IG metadata, pages and menu. Add every new page here.
- `input/fsh/`: `profiles.fsh`, `terminology.fsh`, `examples.fsh`.
- `input/pagecontent/`: narrative pages in markdown. Page headings start at `###`.
- `.github/`, `.claude/`: workflows, issue forms and skills. Change them only when a maintainer asks for it directly.
- `fsh-generated/`, `output/`, `temp/`, `template/`, `input-cache/`: generated. Never edit them.

## Conventions

- Ids are lower-case with hyphens. FSH names are PascalCase. Code systems end in `CS`, value sets in `VS`.
- Every profile has at least one example instance.
- Every code system sets `^caseSensitive` and every definitional resource sets `^experimental`.
- Link to artifacts from pages with their generated file name, for example `StructureDefinition-ai-agent-device.html`.

## Ask before you

- change a cardinality, a must-support flag or a binding strength
- add or change a dependency
- choose a code from an external terminology; look it up with a terminology tool and show the result

## Do not

- add entries to `input/ignoreWarnings.txt` to make the build pass; the file is kept empty on purpose
- remove an example or loosen a constraint to make the build pass
- state in the catalogue page that a tool was checked when it was not; use the check levels the page defines
