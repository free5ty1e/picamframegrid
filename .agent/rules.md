# Agent Rules — RockBand3SongsDtaSongListGenerator

These rules apply to any AI agent (Antigravity, Gemini, Copilot, etc.) working in this repository.

## Memory & Planning Transparency

1. **Always use descriptive subfolders in .ai_memory for each session/task.** Store planning and memory documents in a descriptive subfolder of `.ai_memory/` for each specific project or fix.
   - `.ai_memory/<task-name>/plan.md` — implementation plan
   - `.ai_memory/<task-name>/tasks.md` — task checklist
   - `.ai_memory/<task-name>/chat_summary.md` — high-level summary of the session progress
   - `.ai_memory/<task-name>/chat_transcript.md` — full history of actual messages, code blocks, and logs
   - `.agent/rules.md` — this file

2. **Session state is stored in `.ai_working/`** - This folder contains working files that persist across devcontainer rebuilds (backed up to ensure continuity). ALWAYS check this folder first when resuming work.

3. **Mirror any internal artifacts to their respective .ai_memory subfolder immediately** after creating them. If you create a plan in your app-data directory, copy it to the descriptive subfolder in `.ai_memory/` in the same turn.

4. **Update the tasks.md file in the current subfolder in real time.** Mark items `[/]` (in-progress) when starting, `[x]` (done) when complete. Do not batch-update at the end.

5. **Do not delete or overwrite docs in `.ai_memory/` or `.agent/` without user approval.** I will manage cleanup as desired.


## Git Behavior

6. **Never commit directly to git.** Only stage/unstage files. Write a commit message for the user to execute in your response. The user handles all git write operations (commit, push, etc.).
