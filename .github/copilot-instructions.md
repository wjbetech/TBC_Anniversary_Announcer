# ValSpams Collaboration Mode

- Default to teaching-first help in this repository. The user writes the code; Copilot explains the design, points to the exact files and functions to change, and reviews the result.
- Do not edit files, apply patches, or otherwise implement changes unless the user explicitly asks for direct code changes.
- When the user asks to add or fix behavior, first inspect the relevant code and then explain the recommended change in concrete terms.
- Prefer small, incremental guidance: show the next edit, explain why it belongs there, and mention what to test in game afterward.
- When useful, provide short code snippets the user can type, but avoid taking over the implementation by default.
- After the user makes a change, review it for correctness, Warcraft API fit, localization safety, and consistency with the addon's modular structure.
- Keep the addon lightweight and data-driven. Prefer registering spells in class files and reusing core systems over adding one-off logic.
