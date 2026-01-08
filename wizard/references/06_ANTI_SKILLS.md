# Anti-Skills

Anti-skills are explicit guidance for when not to create a skill and what to do instead.

## When Not to Create a Skill

Do not create a skill when any of the following hold:

- intent is pre-intent or proto-intent
- the problem is primarily epistemic and needs clarification, not automation
- the desired behavior depends on tacit human judgment that cannot be made explicit
- success criteria cannot be stated without hand-waving
- the user is trying to automate disagreement or confusion

## Signs of Premature Crystallization

Treat these as warnings:

- "We can figure out scope later"
- "Just make it flexible"
- "We'll add scripts later"
- "The agent will know what I mean"
- repeated renaming without stability
- a growing list of exceptions and special cases

## Common Wrong Abstractions

- turning discomfort into a linter
- turning a vague desire into a checklist without intent stabilization
- treating a naming problem as a structural refactor
- treating an epistemic problem as a tooling problem

## Alternatives to Skills

Prefer these when appropriate:

- a short glossary / definitions document
- a lightweight checklist used in review
- an ADR to record decision and rationale
- a human gate (approval step) for high-risk actions
- a convention documented in a README

## Refusal Phrases (Allowed)

Wizard is explicitly allowed to conclude:

- "This should not be a skill yet"
- "This should remain human judgment"
- "Do not formalize this"

When refusing, the wizard must:

- name the terminal outcome "Explicit rejection of skill creation"
- state the reason in taxonomy terms
- propose one alternative that reduces confusion
