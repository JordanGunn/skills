# Procedure

1. **Run Split**: Execute `split.sh` on the source document.
2. **Run Index**: Execute `index/index.sh` on the output directory.
3. **Verify**: Skim the generated files and `.INDEX.md` for correctness.
4. **Summarize**: Create `.SUMMARY.md` based on the split chunks.
   - Keep summaries thin and non-redundant.
   - Use the `.SPLIT.json` manifest if available for authoritative titles/ordering.
