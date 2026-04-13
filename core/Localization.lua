local A = Announcer

A.localeStrings = {
	enUS = {
		announce = "Announcements",
		announceDescription = "Broadcast alert messages to your current group channel.",
		classes = "Classes",
		classesDescription = "Choose which class spell lists are available under Announcer.",
		classSpellsDescription = "Enable or disable tracked spells for this class.",
		noTrackedSpells = "No tracked spells are configured for this class yet.",
		debug = "Debug",
		debugDescription = "Enable extra local debug output while testing.",
		trackTrinkets = "Track trinkets",
		trackTrinketsDescription = "Announce on-use trinket activations from your equipped trinket slots.",
		showPlayerName = "Show player name",
		showPlayerNameDescription = "Include the caster name in tracked announcements.",
		showTarget = "Show target",
		showTargetDescription = "Include the target name in tracked announcements.",
		channelMode = "Announcement Channel",
		channelModeDescription = "Choose whether announcements follow the default group priority or always use yell.",
		channelPriority = "Raid > Party > Yell",
		channelYellOnly = "Yell only",
		taunt = "Taunt tracking",
		tauntDescription = "Announce tracked crowd control and taunt application events.",
		announceMode = "Tracked Aura Announce Mode",
		announceModeDescription = "Choose how tracked aura announcements behave.",
		modeCastOnly = "Cast only",
		modeCountdown = "Cast + countdown",
		modeEnding = "Cast + ending",
		optionsSubtitle = "Configure which combat announcements this addon sends to party, raid, or local chat.",
		helpText = "Slash commands: /announcer, /announcer options, /announcer announce, /announcer taunt, /announcer debug",
		openedOptions = "Opened Announcer options.",
		usage = "Usage: /announcer options|announce|taunt|debug",
		statusChannel = "Channel",
		statusMode = "Mode",
		castMessage = "%s Cast %s%s!",
		castOnMessage = "%s Cast %s on %s%s!",
		castMessageNoSource = "Cast %s%s!",
		castOnMessageNoSource = "Cast %s on %s%s!",
		countdownMessage = "%s %s on %s ends in %d...",
		countdownNoTargetMessage = "%s %s ends in %d...",
		countdownMessageNoSource = "%s on %s ends in %d...",
		countdownNoTargetMessageNoSource = "%s ends in %d...",
		endedMessage = "%s %s on %s ended!",
		endedNoTargetMessage = "%s %s ended!",
		endedMessageNoSource = "%s on %s ended!",
		endedNoTargetMessageNoSource = "%s ended!",
		missMessage = "%s Cast %s on %s but it %s!",
		missNoTargetMessage = "%s Cast %s but it %s!",
		missMessageNoSource = "Cast %s on %s but it %s!",
		missNoTargetMessageNoSource = "Cast %s but it %s!"
	},
	koKR = {
		announce = "알림",
		announceDescription = "현재 파티 또는 공격대 채널로 경고 메시지를 보냅니다.",
		classes = "직업",
		classesDescription = "Announcer 아래에서 직업별 주문 추적 목록을 설정합니다.",
		classSpellsDescription = "이 직업에서 추적할 주문을 켜거나 끕니다.",
		noTrackedSpells = "아직 이 직업에 설정된 추적 주문이 없습니다.",
		debug = "디버그",
		debugDescription = "테스트 중 추가 디버그 메시지를 표시합니다.",
		trackTrinkets = "장신구 추적",
		trackTrinketsDescription = "착용한 장신구 칸의 사용 효과를 알립니다.",
		showPlayerName = "플레이어 이름 표시",
		showPlayerNameDescription = "추적 알림에 시전자 이름을 포함합니다.",
		showTarget = "대상 표시",
		showTargetDescription = "추적 알림에 대상 이름을 포함합니다.",
		channelMode = "알림 채널",
		channelModeDescription = "기본 우선순위를 사용할지 항상 외치기를 사용할지 선택합니다.",
		channelPriority = "공격대 > 파티 > 외치기",
		channelYellOnly = "외치기 전용",
		taunt = "도발 추적",
		tauntDescription = "추적 중인 군중 제어와 도발 효과 적용 알림을 보냅니다.",
		announceMode = "추적 효과 알림 방식",
		announceModeDescription = "추적 중인 효과의 알림 방식을 선택합니다.",
		modeCastOnly = "시전만 알림",
		modeCountdown = "시전 + 3초 카운트다운",
		modeEnding = "시전 + 종료 알림",
		optionsSubtitle = "이 애드온이 파티, 공격대 또는 일반 채팅에 보낼 전투 알림을 설정합니다.",
		helpText = "슬래시 명령어: /announcer, /announcer options, /announcer announce, /announcer taunt, /announcer debug",
		openedOptions = "Announcer 설정을 열었습니다.",
		usage = "사용법: /announcer options|announce|taunt|debug",
		statusChannel = "채널",
		statusMode = "방식",
		castMessage = "%s 시전 %s%s!",
		castOnMessage = "%s 시전 %s -> %s%s!",
		castMessageNoSource = "시전 %s%s!",
		castOnMessageNoSource = "시전 %s -> %s%s!",
		countdownMessage = "%s %s -> %s 종료 %d초 전...",
		countdownNoTargetMessage = "%s %s 종료 %d초 전...",
		countdownMessageNoSource = "%s -> %s 종료 %d초 전...",
		countdownNoTargetMessageNoSource = "%s 종료 %d초 전...",
		endedMessage = "%s %s -> %s 종료!",
		endedNoTargetMessage = "%s %s 종료!",
		endedMessageNoSource = "%s -> %s 종료!",
		endedNoTargetMessageNoSource = "%s 종료!",
		missMessage = "%s 시전 %s -> %s, 결과: %s!",
		missNoTargetMessage = "%s 시전 %s, 결과: %s!",
		missMessageNoSource = "시전 %s -> %s, 결과: %s!",
		missNoTargetMessageNoSource = "시전 %s, 결과: %s!"
	}
}

A.L = A.localeStrings[A.locale] or A.localeStrings.enUS

A.optionLabels = {
	announce = A.L.announce,
	debug = A.L.debug,
	trackTrinkets = A.L.trackTrinkets,
	showPlayerName = A.L.showPlayerName,
	showTarget = A.L.showTarget,
	taunt = A.L.taunt
}

A.optionDescriptions = {
	announce = A.L.announceDescription,
	debug = A.L.debugDescription,
	trackTrinkets = A.L.trackTrinketsDescription,
	showPlayerName = A.L.showPlayerNameDescription,
	showTarget = A.L.showTargetDescription,
	taunt = A.L.tauntDescription
}

A.announceModeLabels = {
	cast_only = A.L.modeCastOnly,
	countdown = A.L.modeCountdown,
	ending = A.L.modeEnding
}

A.channelModeLabels = {
	priority = A.L.channelPriority,
	yell_only = A.L.channelYellOnly
}