local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Plugins", "enUS", true)

-----------------------------------------------------------------------
-- AltPower.lua
--

L.altPowerTitle = "AltPower"
L.toggleDisplayPrint = "The display will show next time. To disable it completely for this encounter, you need to toggle it off in the encounter options."
L.disabled = "Disabled"
L.disabledDisplayDesc = "Disable the display for all modules that use it."

-----------------------------------------------------------------------
-- Bars.lua
--

L.bars = "Bars"
L.style = "Style"
L.bigWigsBarStyleName_Default = "Default"

L.clickableBars = "Clickable Bars"
L.clickableBarsDesc = "Big Wigs bars are click-through by default. This way you can target objects or launch targetted AoE spells behind them, change the camera angle, and so on, while your cursor is over the bars. |cffff4411If you enable clickable bars, this will no longer work.|r The bars will intercept any mouse clicks you perform on them.\n"
L.interceptMouseDesc = "Enables bars to receive mouse clicks."
L.modifier = "Modifier"
L.modifierDesc = "Hold down the selected modifier key to enable click actions on the timer bars."
L.modifierKey = "Only with modifier key"
L.modifierKeyDesc = "Allows bars to be click-through unless the specified modifier key is held down, at which point the mouse actions described below will be available."

L.tempEmphasize = "Temporarily Super Emphasizes the bar and any messages associated with it for the duration."
L.report = "Report"
L.reportDesc = "Reports the current bars status to the active group chat; either instance chat, raid, party or say, as appropriate."
L.remove = "Remove"
L.removeDesc = "Temporarily removes the bar and all associated messages."
L.removeOther = "Remove other"
L.removeOtherDesc = "Temporarily removes all other bars (except this one) and associated messages."
L.disable = "Disable"
L.disableDesc = "Permanently disables the boss encounter ability option that spawned this bar."

L.emphasizeAt = "Emphasize at... (seconds)"
L.scale = "Scale"
L.growingUpwards = "Grow upwards"
L.growingUpwardsDesc = "Toggle growing upwards or downwards from the anchor."
L.texture = "Texture"
L.emphasize = "Emphasize"
L.enable = "Enable"
L.move = "Move"
L.moveDesc = "Moves emphasized bars to the Emphasize anchor. If this option is off, emphasized bars will simply change scale and color."
L.regularBars = "Regular bars"
L.emphasizedBars = "Emphasized bars"
L.align = "Align"
L.left = "Left"
L.center = "Center"
L.right = "Right"
L.time = "Time"
L.timeDesc = "Whether to show or hide the time left on the bars."
L.icon = "Icon"
L.iconDesc = "Shows or hides the bar icons."
L.font = "Font"
L.restart = "Restart"
L.restartDesc = "Restarts emphasized bars so they start from the beginning and count from 10."
L.fill = "Fill"
L.fillDesc = "Fills the bars up instead of draining them."

L.localTimer = "Local"
L.timerFinished = "%s: Timer [%s] finished."
L.customBarStarted = "Custom bar '%s' started by %s user %s."

L.pull = "Pull"
L.pulling = "Pulling!"
L.pullStarted = "Pull timer started by %s user %s."
L.pullStopped = "Pull timer cancelled by %s."
L.pullIn = "Pull in %d sec"
L.sendPull = "Sending a pull timer to Big Wigs and DBM users."
L.sendCustomBar = "Sending custom bar '%s' to Big Wigs and DBM users."
L.requiresLeadOrAssist = "This function requires raid leader or raid assist."
L.wrongPullFormat = "Must be between 1 and 60 seconds. A correct example is: /pull 5"
L.wrongCustomBarFormat = "Incorrect format. A correct example is: /raidbar 20 text"
L.wrongTime = "Invalid time specified. <time> can be either a number in seconds, a M:S pair, or Mm. For example 5, 1:20 or 2m."
L.encounterRestricted = "This function can't be used during an encounter."

L.wrongBreakFormat = "Must be between 1 and 60 minutes. A correct example is: /break 5"
L.sendBreak = "Sending a break timer to Big Wigs and DBM users."
L.breakStarted = "Break timer started by %s user %s."
L.breakStopped = "Break timer cancelled by %s."
L.breakBar = "Break time"
L.breakAnnounce = "%g |4minute:minutes; break starts now!"
L.breakMinutes = "Break ends in %d |4minute:minutes;!"
L.breakSeconds = "Break ends in %d |4second:seconds;!"
L.breakFinished = "Break time is now over!"

-----------------------------------------------------------------------
-- Colors.lua
--

L.colors = "Colors"

L.text = "Text"
L.textShadow = "Text Shadow"
L.flash = "Flash"
L.normal = "Normal"
L.emphasized = "Emphasized"

L.reset = "Reset"
L.resetDesc = "Resets the above colors to their defaults."
L.resetAll = "Reset all"
L.resetAllDesc = "If you've customized colors for any boss encounter settings, this button will reset ALL of them so the colors defined here will be used instead."

L.Important = "Important"
L.Personal = "Personal"
L.Urgent = "Urgent"
L.Attention = "Attention"
L.Positive = "Positive"
L.Neutral = "Neutral"

-----------------------------------------------------------------------
-- Emphasize.lua
--

L.superEmphasize = "Super Emphasize"
L.superEmphasizeDesc = "Boosts related messages or bars of a specific boss encounter ability.\n\nHere you configure exactly what should happen when you toggle on the Super Emphasize option in the advanced section for a boss encounter ability.\n\n|cffff4411Note that Super Emphasize is off by default for all abilities.|r\n"
L.uppercase = "UPPERCASE"
L.uppercaseDesc = "Uppercases all messages related to a super emphasized option."
L.doubleSize = "Double size"
L.doubleSizeDesc = "Doubles the size of super emphasized bars and messages."
L.countdown = "Countdown"
L.countdownDesc = "If a related timer is longer than 5 seconds, a vocal and visual countdown will be added for the last 5 seconds. Imagine someone counting down \"5... 4... 3... 2... 1... COUNTDOWN!\" and big numbers in the middle of your screen."
L.superEmphasizeDisableDesc = "Disable Super Emphasize for all modules that use it."

-----------------------------------------------------------------------
-- Messages.lua
--

L.sinkDescription = "Route output from this addon through the Big Wigs message display. This display supports icons, colors and can show up to 4 messages on the screen at a time. Newly inserted messages will grow in size and shrink again quickly to notify the user."
L.emphasizedSinkDescription = "Route output from this addon through the Big Wigs Emphasized message display. This display supports text and colors, and can only show one message at a time."
L.emphasizedCountdownSinkDescription = "Route output from this addon through the Big Wigs Emphasized Countdown message display. This display supports text and colors, and can only show one message at a time."

L.bwEmphasized = "Big Wigs Emphasized"
L.messages = "Messages"
L.normalMessages = "Normal messages"
L.emphasizedMessages = "Emphasized messages"
L.output = "Output"
L.emphasizedCountdown = "Emphasized countdown"

L.useColors = "Use colors"
L.useColorsDesc = "Toggles white only messages ignoring coloring."
L.useIcons = "Use icons"
L.useIconsDesc = "Show icons next to messages."
L.classColors = "Class colors"
L.classColorsDesc = "Colors player names by their class."

L.fontSize = "Font size"
L.none = "None"
L.thin = "Thin"
L.thick = "Thick"
L.outline = "Outline"
L.monochrome = "Monochrome"
L.monochromeDesc = "Toggles the monochrome flag, removing any smoothing of the font edges."
L.fontColor = "Font color"

L.displayTime = "Display time"
L.displayTimeDesc = "How long to display a message, in seconds"
L.fadeTime = "Fade time"
L.fadeTimeDesc = "How long to fade out a message, in seconds"

-----------------------------------------------------------------------
-- Proximity.lua
--

L.customRange = "Custom range indicator"
L.proximityTitle = "%d yd / %d |4player:players;" -- yd = yards (short)
L.proximity_name = "Proximity"
L.sound = "Sound"
L.soundDelay = "Sound delay"
L.soundDelayDesc = "Specify how long Big Wigs should wait between repeating the specified sound when someone is too close to you."

L.proximity = "Proximity display"
L.proximity_desc = "Show the proximity window when appropriate for this encounter, listing players who are standing too close to you."

L.close = "Close"
L.closeProximityDesc = "Closes the proximity display.\n\nTo disable it completely for any encounter, you have to go into the options for the relevant boss module and toggle the 'Proximity' option off."
L.lock = "Lock"
L.lockDesc = "Locks the display in place, preventing moving and resizing."
L.title = "Title"
L.titleDesc = "Shows or hides the title."
L.background = "Background"
L.backgroundDesc = "Shows or hides the background."
L.toggleSound = "Toggle sound"
L.toggleSoundDesc = "Toggle whether or not the proximity window should beep when you're too close to another player."
L.soundButton = "Sound button"
L.soundButtonDesc = "Shows or hides the sound button."
L.closeButton = "Close button"
L.closeButtonDesc = "Shows or hides the close button."
L.showHide = "Show/hide"
L.abilityName = "Ability name"
L.abilityNameDesc = "Shows or hides the ability name above the window."
L.tooltip = "Tooltip"
L.tooltipDesc = "Shows or hides a spell tooltip if the Proximity display is currently tied directly to a boss encounter ability."

-----------------------------------------------------------------------
-- RaidIcon.lua
--

L.icons = "Icons"
L.raidIconsDescription = "Some encounters might include elements such as bomb-type abilities targetted on a specific player, a player being chased, or a specific player might be of interest in other ways. Here you can customize which raid icons should be used to mark these players.\n\nIf an encounter only has one ability that is worth marking for, only the first icon will be used. One icon will never be used for two different abilities on the same encounter, and any given ability will always use the same icon next time.\n\n|cffff4411Note that if a player has already been marked manually, Big Wigs will never change their icon.|r"
L.primary = "Primary"
L.primaryDesc = "The first raid target icon that a encounter script should use."
L.secondary = "Secondary"
L.secondaryDesc = "The second raid target icon that a encounter script should use."

-----------------------------------------------------------------------
-- Sound.lua
--

L.defaultOnly = "Default only"
L.soundDefaultDescription = "With this option set, Big Wigs will only use the default Blizzard raid warning sound for messages that come with a sound alert. Note that only some messages from encounter scripts will trigger a sound alert."

L.Sounds = "Sounds"

L.Alarm = "Alarm"
L.Info = "Info"
L.Alert = "Alert"
L.Long = "Long"
L.Warning = "Warning"
L.Victory = "Victory"

L.Beware = "Beware (Algalon)"
L.FlagTaken = "Flag Taken (PvP)"
L.Destruction = "Destruction (Kil'jaeden)"
L.RunAway = "Run Away Little Girl (Big Bad Wolf)"

L.customSoundDesc = "Play the selected custom sound instead of the one supplied by the module"
L.resetAllCustomSound = "If you've customized sounds for any boss encounter settings, this button will reset ALL of them so the sounds defined here will be used instead."

-----------------------------------------------------------------------
-- Statistics.lua
--

L.bossDefeatDurationPrint = "Defeated '%s' after %s."
L.bossWipeDurationPrint = "Wiped on '%s' after %s."
L.newBestTime = "New best time!"
L.bossStatistics = "Boss Statistics"
L.bossStatsDescription = "Recording of various boss-related statistics such as the amount of times a boss had been killed, the amount of wipes, total time that combat lasted, or the fastest boss kill. These statistics can be viewed on each boss's configuration screen, but will be hidden for bosses that have no recorded statistics."
L.enableStats = "Enable Statistics"
L.chatMessages = "Chat Messages"
L.printBestTimeOption = "Best Time Notification"
L.printDefeatOption = "Defeat Time"
L.printWipeOption = "Wipe Time"
L.countDefeats = "Count Defeats"
L.countWipes = "Count Wipes"
L.recordBestTime = "Remember Best Time"
L.createTimeBar = "Show 'Best Time' bar"
L.bestTimeBar = "Best Time"

