---
name: ig-qa-loop
description: Build this FHIR implementation guide and fix what the build reports. Use after editing FSH or pages, when asked to fix SUSHI or IG Publisher QA errors, or before reporting an IG change as done.
---

# IG QA loop

Work in two loops. The inner loop is fast and catches most mistakes. The outer loop is the authoritative check.

## Inner loop: SUSHI

1. Run `./_build.sh sushi`.
2. Fix every error and warning in `input/fsh/`. SUSHI reports the file and line.
3. Repeat until the result line shows `0 Errors 0 Warnings`.

## Outer loop: IG Publisher

1. Run `./_build.sh`. It takes several minutes; run it in the background and do not start a second one.
2. Read the counts in `output/qa.json`: `errs`, `warnings`, `hints`.
3. If `errs` is above 0, read the messages in `output/qa.html`. They are grouped by source file. The same text is in `output/qa.txt`.
4. Fix each error at its source under `input/`. Never edit `fsh-generated/` or `output/`.
5. Return to the inner loop, then run the full build again.

## Common causes

| Message mentions | Usual cause |
|---|---|
| a broken link in a page | A page links to an artifact file name that does not exist. File names are `<ResourceType>-<id>.html`. |
| a code that is not in a value set or is unknown | The code or system URL is wrong. Look it up; do not guess a replacement. |
| a slice or discriminator | The example does not match the pattern that the slice fixes. |
| a page that is not in the IG | The page is missing from `pages` in `sushi-config.yaml`. |

## Stop and ask when

- the fix would change a cardinality, must-support flag or binding strength
- the fix would replace a code from an external terminology
- the only way to clear a message is to suppress it

## Report

State the final `errs`, `warnings` and `hints`, what you changed, and each warning you left in place with the reason.
