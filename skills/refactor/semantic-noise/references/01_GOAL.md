# Goal

Run a focused audit to find violations of:

- Semantic Noise (redundant naming that repeats namespace context)
- Namespace Integrity erosion (identifiers doing work that structure should do)

Then:

- Flag concrete refactor opportunities (new modules, namespaces, splits)
- Propose minimal, safe renames when restructuring is not warranted
- Keep suggestions scoped to the provided change set whenever possible

The output should be a single Markdown report.
