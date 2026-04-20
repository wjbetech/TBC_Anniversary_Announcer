### core/Registry.lua

spell category, behavior, and flags.

### core/Events.lua

aura-applied CC, taunt fail states, spell outcome tracking.

### core/Formatter.lua

target names, raid icons, different wording for use/fail/break/end.

### core/Options.lua and core/DB.lua

my CC vs all CC, category toggles, external whisper options, future spam warnings.

### core/Localization.lua

localized immune/resist/miss wording and any new menu labels.

## Edge Cases

- raid icon may not exist on target
- target name may be nil on some combat log events
- CC natural expiry and early break need different wording
- “taunt fails for any reason” includes miss, dodge, parry, immune, resist, maybe invalid target cases
- offensives like Power Infusion are target-based; others may be self-only
- whisper target for externals needs guard so you do not whisper yourself or nil
- target trinket spam warning belongs in UI text, not event throttle logic

## Spell Definition Model

### Categories

- defensive
- offensive
- taunt
- crowd_control
- trinket
- important_tank_outcome

### Behaviors

- self_aura
- target_aura
- cast_success

### Flags

- announceOnMiss
- announceOnResist
- announceOnImmune
- announceOnBreak
- announceOnExpire
- announceTarget
- whisperTarget
- showRaidIcon
