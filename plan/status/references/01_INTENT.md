# Intent

Provide at-a-glance visibility into plan execution progress.

## Problem

Plans can have many sub-plans and tasks. Without a status view, the user must
manually inspect each file to understand what's done and what remains.

## Solution

Parse the `status` frontmatter from plan files and display a summary:

- Which tasks are pending, in progress, or complete
- Overall progress percentage
- Current active task (if any)

## Benefits

- **No manual inspection**: Derived from frontmatter, always accurate
- **Single source of truth**: Status lives in the files themselves
- **Works retroactively**: Can be run on any plan with frontmatter
