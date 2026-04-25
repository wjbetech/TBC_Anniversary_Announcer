- todo.md says what the addon should do.
- implementation.md says which code areas own what work.
- roadmap.md is the item-by-item build plan so that we stay on track the entire build.

# Roadmap

This roadmap turns the design in `docs/todo.md` into a fully phased build plan.

The core principles follow this:

1. Build the data model first
2. Separate spell meaning from combat-log behavior
3. Add message rules per category, not per spell
4. Keep trinkets lightweight and special-cased
5. Prefer curating abilities over tracking everything
6. Finish one vertical slice cleanly before broad expansion

## Phase 1: Spell Model

- [x] Define final spell categories
- [x] Define final combat-log behaviors
- [x] Define final per-spell announcement flags
- [x] Refactor registry structure in core/Registry.lua
- [x] Remove old registry bucket assumptions
- [x] Add lookup helpers for new behavior model
- [x] Verify class spell definitions still register correctly
- [x] Plan saved-variable migration impact
  - [x] whether existing trackedSpells keys still match current spell keys
  - [x] whether taunt still has the same meaning under the new behavior model
  - [x] whether obsolete saved fields should be normalized or removed in EnsureOptions()

## Phase 2: Event Pipeline

- [x] Refactor combat-log handling in core/Events.lua
- [x] Route events by behavior instead of old modality buckets
- [x] Separate self aura, target aura, cast success, and outcome handling
- [x] Add clean success path for tracked spells
- [x] Add clean failure path for miss, resist, and immune
- [x] Prevent duplicate messages on refresh or reapply
- [x] Handle nil target data safely

## Phase 3: Message Formatting

- [x] Rebuild success message formatting
- [x] Rebuild fail message formatting
- [x] Add break message formatting
- [x] Add expiry message formatting
- [x] Add target name support
- [x] Add raid icon support
- [x] Clean up noisy or awkward wording
- [x] Keep category wording consistent

## Phase 4: Localization

- [x] Localize miss messaging
- [x] Localize resist messaging
- [x] Localize immune messaging
- [x] Localize break messaging
- [x] Localize expiry messaging
- [x] Add labels for new categories
- [x] Add labels for new options
- [x] Remove hard-coded English from logic paths

## Phase 5: Defensives

- [x] Mark defensive spells in class data
- [x] Announce successful defensive use
- [x] Announce target for externals
- [x] Whisper target for externals
- [x] Prevent self-whisper
- [ ] Test one full defensive flow end-to-end

## Phase 6: Offensives

- [x] Mark offensive spells in class data
- [x] Limit offensives to curated list
- [x] Add menu warning for possible spam
- [x] Announce target where relevant
- [x] Whisper target for externals
- [x] Support self-only offensives cleanly
- [ ] Test one self-only offensive
- [ ] Test one external offensive

## Phase 7: Taunts

- [x] Mark taunt spells in class data
- [x] Announce successful taunts
- [x] Announce target name for taunts
- [x] Announce target raid icon when available
- [x] Announce taunt miss
- [x] Announce taunt resist
- [x] Announce taunt immune
- [ ] Test taunt success and failure paths

## Phase 8: Crowd-Control

- [x] Mark CC spells in class data
- [x] Add my CC vs all tracked CC option
- [x] Announce successful CC application
- [x] Announce target name for CC
- [x] Announce target raid icon when available
- [x] Announce CC miss
- [x] Announce CC resist
- [x] Announce CC immune
- [x] Add early break detection
- [x] Add standard expiry handling
- [x] Prevent break and expiry from colliding
- [ ] Test one full CC lifecycle

## Phase 9: Important Tank Outcomes

- [x] Finalize exact paladin spell list
- [x] Finalize exact warrior spell list
- [x] Finalize exact druid spell list
- [x] Add outcome flags to selected spells
- [x] Announce miss for selected spells
- [x] Announce resist for selected spells
- [x] Announce immune for selected spells
- [x] Announce target name for selected spells
- [x] Announce target raid icon when available
- [x] Verify these do not become generic cast announcements

## Phase 10: Trinkets

- [x] Review existing trinket path in core/Trinkets.lua
- [x] Keep trinkets usage-only
- [x] Add menu warning for possible spam
- [x] Ensure no expiry messages fire for trinkets
- [x] Verify GetItemSpell handling remains safe
- [ ] Test both trinket slots

## Phase 11: Dispels

- [x] Confirm dispels stay in active scope
- [x] Add dispel success handling
- [x] Add dispel fail or resist handling where possible
- [x] Add target display for dispels where relevant
- [x] Curate dispel spell list
- [ ] Test one successful dispel path
- [ ] Test one failed dispel path

## Phase 12: Options and Saved Variables

- [x] Replace old option assumptions in core/DB.lua
- [x] Add category-specific toggles
- [x] Add target announcement options
- [x] Add external whisper options
- [x] Add CC scope option
- [x] Add menu warning text for noisy categories
- [x] Migrate old taunt option safely
- [x] Migrate old tracked spell options safely
- [x] Verify clean defaults for new options

## Phase 13: Class Data Expansion

- [x] Review warrior spell list
- [x] Review paladin spell list
- [x] Review druid spell list
- [x] Review hunter spell list
- [x] Review priest spell list
- [x] Review shaman spell list
- [x] Review mage spell list
- [x] Review warlock spell list
- [x] Review rogue spell list
- [x] Add exact spell IDs
- [x] Confirm category fit for each spell
- [x] Confirm behavior fit for each spell
- [x] Confirm flags for each spell

## Phase 14: UI

- [x] Show spell icons in options
- [x] Improve options layout
- [x] Group options by category
- [x] Surface warnings clearly
- [x] Surface whisper options clearly
- [x] Surface target announcement options clearly
- [ ] Verify layout remains readable with larger spell lists

## Phase 15: Docs Sync

- [x] Update docs/public_todo.md to match shipped scope
- [x] Update docs/README.md to match shipped behavior
- [x] Remove stale wording from docs
- [x] Replace placeholder spell names with exact names where possible
- [x] Ensure public docs match actual implemented features

## Phase 16: Long-Term

- [x] Design profile system
- [x] Design dual-spec support
- [x] Review future filtering ideas
- [x] Review future quality-of-life options

## Milestones

- [x] Milestone 1: Spell model and event refactor complete
- [ ] Milestone 2: Defensives, taunts, and CC working end-to-end
- [x] Milestone 3: Important tank outcomes, offensives, and trinkets working
- [x] Milestone 4: Options and class coverage expanded
- [x] Milestone 5: Public docs fully aligned

## Per-Phase Verification

- [ ] Reload UI without Lua errors
- [ ] Open options without errors
- [ ] Verify saved variables still load
- [ ] Test one success case
- [ ] Test one failure case
- [ ] Test one edge case relevant to the phase
- [ ] Check for duplicate messages
- [ ] Check for obvious spam
