# Changelog

## Beta Release 1.0.2-beta.3 (2026.04.26)

- Beta release
  - Harden player-owned spell detection for Hammer of Justice, taunts, tank warnings, and trinkets when combat-log source data is inconsistent.
  - Add workspace Lua language-server config and switch module roots to `_G.ValSpams` to reduce false `ValSpams` diagnostics in VS Code.

## Beta Release 1.0.2-beta.2 (2026.04.26)

- Beta release
  - Fix Hammer of Justice and taunt announcements for tracked target-aura spells.
  - Add a `Say only` announcement channel mode.
  - Tighten CC break ownership so `My CC only` does not announce other players' CC breaks.

## Beta Release 1.0.2-beta.1 (2026.04.25)

- Beta release
  - Fixing the janky trinket interactions and double menu items
  - Removed announcing dispells for now, just too spammy

## Release 1.0.1 (2026.04.25)

- Initial release of ValSpams, update to the classic WakeSpams addon.
  - Announcements for offensives, defensives, taunts, interrupts, trinkets, and CC.
  - Defaults off for trinkets, turn on in options via /vs.
  - Defaults Raid > Party > Yell.
  - Defaults to announcing cast/use and end of effect.
  - Defaults to only announcing player's CC.
