---
name: create-plan
description: Create and maintain concise, actionable execution plans for coding or operational tasks, using Codex CLI's `update_plan` tool. Use when a user asks to "make a plan", "create a roadmap", "break this down", "add TODOs", or when work is multi-step and would benefit from explicit milestones and progress tracking.
---

# Create Plan

## Goal

Create a small, high-signal plan that:

- Breaks work into 3–7 concrete steps.
- Makes progress visible by updating statuses as you work.
- Stays aligned with what you can actually do in the current environment (tools, permissions, time).

## Workflow (use `update_plan`)

1. Decide if a plan is worth it.
   - Use a plan for multi-phase work, ambiguity, multiple deliverables, or anything likely to take several tool calls.
   - Skip the plan for trivial changes or one-step answers.

2. Draft plan steps.
   - Write steps as short imperatives (verb first), typically 3–7 words.
   - Keep steps outcome-oriented (deliverables), not tool-oriented ("run tests" is OK if it’s a meaningful checkpoint).
   - Prefer 4–6 steps; avoid >7 unless the task truly requires it.

3. Create the plan with one `in_progress` step.
   - Call `update_plan` with the full step list.
   - Set exactly one step to `in_progress`; all others `pending`.
   - Include a brief `explanation` if it clarifies scope or constraints.

4. Maintain the plan while executing.
   - Before starting a new phase, mark the previous `in_progress` step as `completed`, then set the next step to `in_progress`.
   - Never leave multiple steps as `in_progress`.
   - Do not let the plan drift: if scope changes, update step wording/order rather than forcing progress.

5. Close the plan.
   - End with all steps either `completed` or explicitly deferred/canceled (use step text like "Defer: ...").

## Quality bar

- Each step should be verifiable by reading outputs or repo changes.
- Avoid vague steps like "Do stuff" or "Handle edge cases" unless you name which ones.
- Avoid micro-steps ("open file", "scroll") and obvious filler.

## Templates

### Default (4–6 steps)

Use when you need a clean, linear flow.

- Clarify requirements and constraints
- Inspect current code and behavior
- Implement targeted changes
- Add/adjust tests or checks
- Run validation and fix regressions
- Summarize changes and next steps

### Ambiguous scope (5–7 steps)

Use when discovery is needed.

- Confirm desired behavior and scope
- Inventory relevant files and entrypoints
- Propose approach and tradeoffs
- Implement minimal viable change
- Expand to handle key edge cases
- Validate with tests/build/run
- Document usage and follow-ups

## Example `update_plan` payload

Use this shape; keep step text short.

```json
{
  "explanation": "Implement feature X end-to-end with tests.",
  "plan": [
    { "step": "Confirm requirements and constraints", "status": "in_progress" },
    { "step": "Inspect relevant codepaths", "status": "pending" },
    { "step": "Implement core behavior", "status": "pending" },
    { "step": "Add tests and fixtures", "status": "pending" },
    { "step": "Run checks and fix issues", "status": "pending" }
  ]
}
```

