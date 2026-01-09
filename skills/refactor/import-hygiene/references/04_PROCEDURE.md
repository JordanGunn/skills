# Procedure

1) Scan changed files for import statements:
   - `import X`
   - `import X as Y`
   - `from X import Y`

2) Identify imported symbol names that match a “generic identifier” set:
   - Metadata, Header, Payload, Spec, File, Config, Builder, Reader, Writer, Manager, Factory, Handler

3) Flag any `from X import <Generic>` usage as a finding.

4) Propose a namespace-first rewrite:
   - Replace `from X import Generic` with `import X as <alias>` OR `from Parent import <module>`
   - Update callsites to use `<alias>.Generic`

5) Keep rewrites minimal:
   - Prefer alias name derived from module basename (`cache`, `format`, `metadata`)
   - Do not restructure modules; this skill only changes imports and callsites accordingly

6) Output a Markdown report with concrete rewrites for each finding.
