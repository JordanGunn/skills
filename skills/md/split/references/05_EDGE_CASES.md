# Edge Cases

- **Title-only intro**: If the document begins with a single H1 title and nothing else before the first H2, `00_INTRO.md` will not be created.
- **Duplicate H2 Names**: Not currently handled (will overwrite). Recommendation: Ensure H2 titles are unique.
- **Special Characters**: Stripped from filenames; preserved in promoted H1 titles.
- **Code Fences**: Headings inside code fences *may* be detected if they start at the beginning of a line.
- **Long Headings**: Slugs are truncated to 60 characters for filesystem safety.
