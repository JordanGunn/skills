# Scripts

## split.sh / split.ps1

Splits a markdown file by H2 headings.

```bash
./scripts/split.sh --in path/to/file.md --out path/to/output/
```

## index.sh / index.ps1

Generates `.INDEX.md` from the output of the split script.

```bash
./scripts/index/index.sh --dir path/to/output/
```
