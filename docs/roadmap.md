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
- [ ] Remove old registry bucket assumptions
- [x] Add lookup helpers for new behavior model
- [ ] Verify class spell definitions still register correctly
- [ ] Plan saved-variable migration impact

## Phase 2: Event Pipeline

- [ ] Refactor combat-log handling in core/Events.lua
- [ ] Route events by behavior instead of old modality buckets
- [ ] Separate self aura, target aura, cast success, and outcome handling
- [ ] Add clean success path for tracked spells
- [ ] Add clean failure path for miss, resist, and immune
- [ ] Prevent duplicate messages on refresh or reapply
- [ ] Handle nil target data safely

## Phase 3: Message Formatting

- [ ] Rebuild success message formatting
- [ ] Rebuild fail message formatting
- [ ] Add break message formatting
- [ ] Add expiry message formatting
- [ ] Add target name support
- [ ] Add raid icon support
- [ ] Clean up noisy or awkward wording
- [ ] Keep category wording consistent

## Phase 4: Localization

- [ ] Localize miss messaging
- [ ] Localize resist messaging
- [ ] Localize immune messaging
- [ ] Localize break messaging
- [ ] Localize expiry messaging
- [ ] Add labels for new categories
- [ ] Add labels for new options
- [ ] Remove hard-coded English from logic paths

## Phase 5: Defensives

- [ ] Mark defensive spells in class data
- [ ] Announce successful defensive use
- [ ] Add final 3-second countdown
- [ ] Announce target for externals
- [ ] Whisper target for externals
- [ ] Prevent self-whisper
- [ ] Verify countdown only runs when duration makes sense
- [ ] Test one full defensive flow end-to-end

## Phase 6: Offensives

- [ ] Mark offensive spells in class data
- [ ] Limit offensives to curated list
- [ ] Add menu warning for possible spam
- [ ] Announce target where relevant
- [ ] Whisper target for externals
- [ ] Support self-only offensives cleanly
- [ ] Test one self-only offensive
- [ ] Test one external offensive

## Phase 7: Taunts

- [ ] Mark taunt spells in class data
- [ ] Announce successful taunts
- [ ] Announce target name for taunts
- [ ] Announce target raid icon when available
- [ ] Announce taunt miss
- [ ] Announce taunt resist
- [ ] Announce taunt immune
- [ ] Test taunt success and failure paths

## Phase 8: Crowd-Control

- [ ] Mark CC spells in class data
- [ ] Add my CC vs all tracked CC option
- [ ] Announce successful CC application
- [ ] Announce target name for CC
- [ ] Announce target raid icon when available
- [ ] Announce CC miss
- [ ] Announce CC resist
- [ ] Announce CC immune
- [ ] Add early break detection
- [ ] Add standard expiry handling
- [ ] Prevent break and expiry from colliding
- [ ] Test one full CC lifecycle

## Phase 9: Important Tank Outcomes

- [ ] Finalize exact paladin spell list
- [ ] Finalize exact warrior spell list
- [ ] Finalize exact druid spell list
- [ ] Add outcome flags to selected spells
- [ ] Announce miss for selected spells
- [ ] Announce resist for selected spells
- [ ] Announce immune for selected spells
- [ ] Announce target name for selected spells
- [ ] Announce target raid icon when available
- [ ] Verify these do not become generic cast announcements

## Phase 10: Trinkets

- [ ] Review existing trinket path in core/Trinkets.lua
- [ ] Keep trinkets usage-only
- [ ] Add menu warning for possible spam
- [ ] Ensure no countdowns fire for trinkets
- [ ] Ensure no expiry messages fire for trinkets
- [ ] Verify GetItemSpell handling remains safe
- [ ] Test both trinket slots

## Phase 11: Dispels

- [ ] Confirm dispels stay in active scope
- [ ] Add dispel success handling
- [ ] Add dispel fail or resist handling where possible
- [ ] Add target display for dispels where relevant
- [ ] Curate dispel spell list
- [ ] Test one successful dispel path
- [ ] Test one failed dispel path

## Phase 12: Options and Saved Variables

- [ ] Replace old option assumptions in core/DB.lua
- [ ] Add category-specific toggles
- [ ] Add target announcement options
- [ ] Add external whisper options
- [ ] Add CC scope option
- [ ] Add menu warning text for noisy categories
- [ ] Migrate old taunt option safely
- [ ] Migrate old tracked spell options safely
- [ ] Verify clean defaults for new options

## Phase 13: Class Data Expansion

- [ ] Review warrior spell list
- [ ] Review paladin spell list
- [ ] Review druid spell list
- [ ] Review hunter spell list
- [ ] Review priest spell list
- [ ] Review shaman spell list
- [ ] Review mage spell list
- [ ] Review warlock spell list
- [ ] Review rogue spell list
- [ ] Add exact spell IDs
- [ ] Confirm category fit for each spell
- [ ] Confirm behavior fit for each spell
- [ ] Confirm flags for each spell

## Phase 14: UI

- [ ] Show spell icons in options
- [ ] Improve options layout
- [ ] Group options by category
- [ ] Surface warnings clearly
- [ ] Surface whisper options clearly
- [ ] Surface target announcement options clearly
- [ ] Verify layout remains readable with larger spell lists

## Phase 15: Docs Sync

- [ ] Update docs/public_todo.md to match shipped scope
- [ ] Update docs/README.md to match shipped behavior
- [ ] Remove stale wording from docs
- [ ] Replace placeholder spell names with exact names where possible
- [ ] Ensure public docs match actual implemented features

## Phase 16: Long-Term

- [ ] Design profile system
- [ ] Design dual-spec support
- [ ] Review future filtering ideas
- [ ] Review future quality-of-life options

## Milestones

- [ ] Milestone 1: Spell model and event refactor complete
- [ ] Milestone 2: Defensives, taunts, and CC working end-to-end
- [ ] Milestone 3: Important tank outcomes, offensives, and trinkets working
- [ ] Milestone 4: Options and class coverage expanded
- [ ] Milestone 5: Public docs fully aligned

## Per-Phase Verification

- [ ] Reload UI without Lua errors
- [ ] Open options without errors
- [ ] Verify saved variables still load
- [ ] Test one success case
- [ ] Test one failure case
- [ ] Test one edge case relevant to the phase
- [ ] Check for duplicate messages
- [ ] Check for obvious spam
