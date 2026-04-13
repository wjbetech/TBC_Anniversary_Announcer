# Announcer

## Unreleased

- Added a Blizzard options panel for toggling announcement, taunt, and debug settings.
- Updated `/announcer` to open the options panel by default.
- Fixed the saved debug setting to consistently use `Announcer_Options.debug`.
- Added Hammer of Justice to tracked debuff announcements and count down the final 3 seconds before it ends.
- Switched tracked ability matching to localized spell registration from spell IDs so non-English clients are supported.
- Added a localized announce-mode dropdown for cast-only, cast-plus-countdown, or cast-plus-ending behavior.
- Updated tracked announcements to include the caster name and localized spell links.
- Added an option to hide target names in tracked announcements.
- Added tracked durations to the initial cast message.
- Added tracking for Blessing of Protection, Blessing of Freedom, Blessing of Sacrifice, Divine Illumination, and Avenging Wrath.
- Added a nested Classes section under Announcer with per-class spell toggle panels.
- Refactored the addon into core modules and per-class files with Announcer.lua as the hub.
- Added an option to show or hide the caster name in tracked announcements.
- Added a main-menu toggle for announcing equipped trinket slot activations.
- Added a channel mode option for `Raid > Party > Yell` priority or `Yell only`.

## [v2.05.1](https://github.com/snerfy/Announcer/tree/v2.05.1) (2021-06-23)

[Full Changelog](https://github.com/snerfy/Announcer/commits/v2.05.1) [Previous Releases](https://github.com/snerfy/Announcer/releases)

- Updating files to be in top level directory
