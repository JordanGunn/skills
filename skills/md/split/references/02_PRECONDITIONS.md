# Preconditions

- Input markdown must be UTF-8 encoded.
- H2 sections must be well-formed (start with `##` followed by a space).
- If no H2 exists, the script will produce `00_INTRO.md` containing all content (including any H1 title).
- If H2 sections exist and the only pre-H2 content is a single H1 title plus whitespace, `00_INTRO.md` will not be created.
- Output directory should ideally be empty to avoid collisions.
