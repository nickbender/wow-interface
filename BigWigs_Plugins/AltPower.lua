--------------------------------------------------------------------------------
-- Module Declaration
--

local plugin = BigWigs:NewPlugin("Alt Power")
if not plugin then return end

plugin.defaultDB = {
	posx = nil,
	posy = nil,
	font = nil,
	fontSize = nil,
	fontOutline = nil,
	monochrome = false,
	expanded = false,
	disabled = false,
	lock = false,
}

--------------------------------------------------------------------------------
-- Locals
--

local L = LibStub("AceLocale-3.0"):GetLocale("Big Wigs: Plugins")
local media = LibStub("LibSharedMedia-3.0")
plugin.displayName = L.altPowerTitle

local powerList, sortedUnitList, roleColoredList = nil, nil, nil
local unitList = nil
local maxPlayers = 0
local display, updater = nil, nil
local opener = nil
local inTestMode = nil
local sortDir = nil
local repeatSync = nil
local syncPowerList = nil
local UpdateDisplay
local tsort, min = table.sort, math.min
local UnitPower, IsInGroup = UnitPower, IsInGroup
local db = nil
local roleIcons = {
	["TANK"] = INLINE_TANK_ICON,
	["HEALER"] = INLINE_HEALER_ICON,
	["DAMAGER"] = INLINE_DAMAGER_ICON,
	["NONE"] = "",
}

local function colorize(power)
	if power == -1 then return 0, 255 end
	local ratio = power/100*510
	local r, g = min(ratio, 255), min(510-ratio, 255)
	if sortDir == "AZ" then -- red to green
		return r, g
	else -- green to red
		return g, r
	end
end

function plugin:RestyleWindow(dirty)
	if db.lock then
		display:SetMovable(false)
		display:RegisterForDrag()
		display:SetScript("OnDragStart", nil)
		display:SetScript("OnDragStop", nil)
	else
		display:SetMovable(true)
		display:RegisterForDrag("LeftButton")
		display:SetScript("OnDragStart", function(self) self:StartMoving() end)
		display:SetScript("OnDragStop", function(self)
			self:StopMovingOrSizing()
			local s = self:GetEffectiveScale()
			db.posx = self:GetLeft() * s
			db.posy = self:GetTop() * s
		end)
	end

	local font, size, flags = GameFontNormal:GetFont()
	local curFont = media:Fetch("font", db.font)
	if dirty or curFont ~= font or db.fontSize ~= size or db.fontOutline ~= flags then
		local newFlags
		if db.monochrome and db.fontOutline ~= "" then
			newFlags = "MONOCHROME," .. db.fontOutline
		elseif db.monochrome then
			newFlags = "" -- "MONOCHROME", XXX monochrome only is disabled for now as it causes a client crash
		else
			newFlags = db.fontOutline
		end

		display.title:SetFont(curFont, db.fontSize, newFlags)
		for i = 1, 25 do
			display.text[i]:SetFont(curFont, db.fontSize, newFlags)
		end
	end
end

-------------------------------------------------------------------------------
-- Options
--

do
	local pluginOptions = nil
	function plugin:GetPluginConfig()
		if not pluginOptions then
			pluginOptions = {
				type = "group",
				get = function(info)
					return db[info[#info]]
				end,
				set = function(info, value)
					local entry = info[#info]
					db[entry] = value
					plugin:RestyleWindow(entry == "fontOutline" or entry == "fontSize" or entry == "monochrome")
				end,
				disabled = function() return plugin.db.profile.disabled end,
				args = {
					disabled = {
						type = "toggle",
						name = L.disabled,
						desc = L.disabledDisplayDesc,
						order = 1,
						disabled = false,
					},
					lock = {
						type = "toggle",
						name = L.lock,
						desc = L.lockDesc,
						order = 2,
					},
					font = {
						type = "select",
						name = L.font,
						order = 3,
						values = media:List("font"),
						itemControl = "DDI-Font",
						get = function()
							for i, v in next, media:List("font") do
								if v == db.font then return i end
							end
						end,
						set = function(info, value)
							db.font = media:List("font")[value]
							plugin:RestyleWindow(true)
						end,
					},
					fontOutline = {
						type = "select",
						name = L.outline,
						order = 4,
						values = {
							[""] = L.none,
							OUTLINE = L.thin,
							THICKOUTLINE = L.thick,
						},
					},
					fontSize = {
						type = "range",
						name = L.fontSize,
						order = 5,
						max = 24,
						min = 8,
						step = 1,
					},
					monochrome = {
						type = "toggle",
						name = L.monochrome,
						desc = L.monochromeDesc,
						order = 6,
					},
					--[[showHide = {
						type = "group",
						name = L.showHide,
						inline = true,
						order = 5,
						get = function(info)
							local key = info[#info]
							return db.objects[key]
						end,
						set = function(info, value)
							local key = info[#info]
							db.objects[key] = value
							plugin:RestyleWindow()
						end,
						args = {
							title = {
								type = "toggle",
								name = L.title,
								desc = L.titleDesc,
								order = 1,
							},
							background = {
								type = "toggle",
								name = L.background,
								desc = L.backgroundDesc,
								order = 2,
							},
							sound = {
								type = "toggle",
								name = L.soundButton,
								desc = L.soundButtonDesc,
								order = 3,
							},
							close = {
								type = "toggle",
								name = L.closeButton,
								desc = L.closeButtonDesc,
								order = 4,
							},
							ability = {
								type = "toggle",
								name = L.abilityName,
								desc = L.abilityNameDesc,
								order = 5,
							},
							tooltip = {
								type = "toggle",
								name = L.tooltip,
								desc = L.tooltipDesc,
								order = 6,
							}
						},
					},]]
				},
			}
		end
		return pluginOptions
	end
end

-------------------------------------------------------------------------------
-- Initialization
--

local function resetAnchor()
	display:ClearAllPoints()
	display:SetPoint("CENTER", UIParent, "CENTER", 300, -80)
	db.posx = nil
	db.posy = nil
	plugin:Contract()
end

local function updateProfile()
	db = plugin.db.profile

	if not db.font then
		db.font = media:GetDefault("font")
	end
	if not db.fontSize then
		local _, size = GameFontNormal:GetFont()
		db.fontSize = size
	end
	if not db.fontOutline then
		local _, _, flags = GameFontNormal:GetFont()
		db.fontOutline = flags
	end

	if display then
		local x = db.posx
		local y = db.posy
		if x and y then
			local s = display:GetEffectiveScale()
			display:ClearAllPoints()
			display:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", x / s, y / s)
		else
			display:ClearAllPoints()
			display:SetPoint("CENTER", UIParent, "CENTER", 300, -80)
		end

		plugin:RestyleWindow()
	end
end

function plugin:OnPluginEnable()
	self:RegisterMessage("BigWigs_StartSyncingPower")
	self:RegisterMessage("BigWigs_ShowAltPower")
	self:RegisterMessage("BigWigs_HideAltPower", "Close")
	self:RegisterMessage("BigWigs_OnBossDisable")

	self:RegisterMessage("BigWigs_StartConfigureMode", "Test")
	self:RegisterMessage("BigWigs_StopConfigureMode", "Close")
	self:RegisterMessage("BigWigs_SetConfigureTarget")

	self:RegisterMessage("BigWigs_ProfileUpdate", updateProfile)
	self:RegisterMessage("BigWigs_ResetPositions", resetAnchor)
	updateProfile()
end

function plugin:OnPluginDisable()
	self:Close()
end

-------------------------------------------------------------------------------
-- Event Handlers
--

do
	-- Realistically this should never fire during an encounter, we're just compensating for someone leaving the group
	-- whilst the display is shown (more likely to happen in LFR). The display should not be shown outside of an encounter
	-- where the event seems to fire frequently, which would make this very inefficient.
	local function GROUP_ROSTER_UPDATE()
		if not IsInGroup() then plugin:Close() return end

		local players = GetNumGroupMembers()
		if players ~= maxPlayers then
			if updater then plugin:CancelTimer(updater) end

			if repeatSync then
				syncPowerList = {}
			end
			maxPlayers = players
			unitList = IsInRaid() and plugin:GetRaidList() or plugin:GetPartyList()
			powerList, sortedUnitList, roleColoredList = {}, {}, {}

			local UnitClass, UnitGroupRolesAssigned = UnitClass, UnitGroupRolesAssigned
			local colorTbl = CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS
			for i = 1, players do
				local unit = unitList[i]
				sortedUnitList[i] = unit

				local name = plugin:UnitName(unit, true) or "???"
				local _, class = UnitClass(unit)
				local tbl = class and colorTbl[class] or GRAY_FONT_COLOR
				roleColoredList[unit] = ("%s|cFF%02x%02x%02x%s|r"):format(roleIcons[UnitGroupRolesAssigned(unit)], tbl.r*255, tbl.g*255, tbl.b*255, name)
			end
			updater = plugin:ScheduleRepeatingTimer(UpdateDisplay, 2)
		end

		if repeatSync then
			plugin:RosterUpdateForHiddenDisplay() -- Maybe a player logged back on after a DC, force sync refresh to send them our power.
		end
	end

	local function createFrame()
		display = CreateFrame("Frame", "BigWigsAltPower", UIParent)
		display:SetSize(230, db.expanded and 210 or 80)
		display:SetClampedToScreen(true)
		display:EnableMouse(true)
		display:SetScript("OnMouseUp", function(self, button)
			if inTestMode and button == "LeftButton" then
				plugin:SendMessage("BigWigs_SetConfigureTarget", plugin)
			end
		end)

		local bg = display:CreateTexture(nil, "PARENT")
		bg:SetAllPoints(display)
		bg:SetBlendMode("BLEND")
		bg:SetTexture(0, 0, 0, 0.3)
		display.background = bg

		local close = CreateFrame("Button", nil, display)
		close:SetPoint("BOTTOMRIGHT", display, "TOPRIGHT", -2, 2)
		close:SetHeight(16)
		close:SetWidth(16)
		close:SetNormalTexture("Interface\\AddOns\\BigWigs\\Textures\\icons\\close")
		close:SetScript("OnClick", function()
			BigWigs:Print(L.toggleDisplayPrint)
			plugin:Close()
		end)

		local expand = CreateFrame("Button", nil, display)
		expand:SetPoint("BOTTOMLEFT", display, "TOPLEFT", 2, 2)
		expand:SetHeight(16)
		expand:SetWidth(16)
		expand:SetNormalTexture(db.expanded and "Interface\\AddOns\\BigWigs\\Textures\\icons\\arrows_up" or "Interface\\AddOns\\BigWigs\\Textures\\icons\\arrows_down")
		expand:SetScript("OnClick", function()
			if db.expanded then
				plugin:Contract()
			else
				plugin:Expand()
			end
		end)
		display.expand = expand

		local header = display:CreateFontString(nil, "OVERLAY", "GameFontNormal")
		header:SetPoint("BOTTOM", display, "TOP", 0, 4)
		display.title = header

		display.text = {}
		for i = 1, 25 do
			local text = display:CreateFontString(nil, "OVERLAY", "GameFontNormal")
			text:SetText("")
			text:SetSize(115, 16)
			text:SetJustifyH("LEFT")
			if i == 1 then
				text:SetPoint("TOPLEFT", display, "TOPLEFT", 5, 0)
			elseif i % 2 == 0 then
				text:SetPoint("LEFT", display.text[i-1], "RIGHT")
			else
				text:SetPoint("TOP", display.text[i-2], "BOTTOM")
			end
			display.text[i] = text
		end

		local x = db.posx
		local y = db.posy
		if x and y then
			local s = display:GetEffectiveScale()
			display:ClearAllPoints()
			display:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", x / s, y / s)
		else
			display:ClearAllPoints()
			display:SetPoint("CENTER", UIParent, "CENTER", 300, -80)
		end

		display:SetScript("OnEvent", GROUP_ROSTER_UPDATE)
		plugin:RestyleWindow()

		-- USE THIS CALLBACK TO SKIN THIS WINDOW! NO NEED FOR UGLY HAX! E.g.
		-- local name, addon = ...
		-- if BigWigsLoader then
		--  BigWigsLoader.RegisterMessage(addon, "BigWigs_FrameCreated", function(event, frame, name) print(name.." frame created.") end)
		-- end
		plugin:SendMessage("BigWigs_FrameCreated", display, "AltPower")
	end

	-- This module is rarely used, and opened once during an encounter where it is.
	-- We will prefer on-demand variables over permanent ones.
	function plugin:BigWigs_ShowAltPower(event, module, title, sorting, sync)
		if db.disabled or not IsInGroup() then return end -- Solo runs of old content

		if createFrame then createFrame() createFrame = nil end
		self:Close()

		if sync then
			BigWigs:AddSyncListener(self, "BWPower", 0)
		end

		display:RegisterEvent("GROUP_ROSTER_UPDATE")

		opener = module
		sortDir = sorting
		maxPlayers = 0 -- Force an update via GROUP_ROSTER_UPDATE
		if title then
			display.title:SetFormattedText("%s: %s", L.altPowerTitle, title)
		else
			display.title:SetText(L.altPowerTitle)
		end
		display:Show()
		GROUP_ROSTER_UPDATE()
		UpdateDisplay()
	end

	function plugin:Test()
		if createFrame then createFrame() createFrame = nil end
		self:Close()

		sortDir = "AZ"
		unitList = self:GetRaidList()
		for i = 1, db.expanded and 25 or 10 do
			local power = 100-(i*(db.expanded and 4 or 10))
			local r, g = colorize(power)
			display.text[i]:SetFormattedText("|cFF%02x%02x00[%d]|r %s", r, g, power, unitList[i])
		end
		display.title:SetText(L.altPowerTitle)
		display:Show()
		inTestMode = true
	end
end

function plugin:BigWigs_SetConfigureTarget(event, module)
	if module == self then
		display.background:SetTexture(0.2, 1, 0.2, 0.3)
	else
		display.background:SetTexture(0, 0, 0, 0.3)
	end
end

do
	local function sortTbl(x,y)
		local px, py = powerList[x], powerList[y]
		if px == py then
			return x > y
		elseif sortDir == "AZ" then
			return px > py
		else
			return px < py
		end
	end

	function UpdateDisplay()
		for i = 1, maxPlayers do
			local unit = unitList[i]
			powerList[unit] = syncPowerList and (syncPowerList[unit] or -1) or UnitPower(unit, 10) -- ALTERNATE_POWER_INDEX = 10
		end
		tsort(sortedUnitList, sortTbl)
		for i = 1, db.expanded and 25 or 10 do
			local unit = sortedUnitList[i]
			if unit then
				local power = powerList[unit]
				local r, g = colorize(power)
				display.text[i]:SetFormattedText("|cFF%02x%02x00[%d]|r %s", r, g, power, roleColoredList[unit])
			else
				display.text[i]:SetText("")
			end
		end
	end
end

function plugin:Expand()
	db.expanded = true
	display:SetHeight(210)
	display.expand:SetNormalTexture("Interface\\AddOns\\BigWigs\\Textures\\icons\\arrows_up")
	if inTestMode then
		self:Test()
	else
		UpdateDisplay()
	end
end

function plugin:Contract()
	db.expanded = false
	display:SetHeight(80)
	display.expand:SetNormalTexture("Interface\\AddOns\\BigWigs\\Textures\\icons\\arrows_down")
	for i = 11, 25 do
		display.text[i]:SetText("")
	end
	if inTestMode then
		self:Test()
	end
end

function plugin:Close()
	if repeatSync then
		self:UnregisterEvent("GROUP_ROSTER_UPDATE")
		self:CancelTimer(repeatSync)
		repeatSync = nil
	end

	if display then
		if updater then self:CancelTimer(updater) end
		updater = nil
		display:UnregisterEvent("GROUP_ROSTER_UPDATE")
		display:Hide()
		BigWigs:ClearSyncListeners(self)
		for i = 1, 25 do
			display.text[i]:SetText("")
		end
	end

	powerList, sortedUnitList, roleColoredList, syncPowerList = nil, nil, nil, nil
	unitList, opener, inTestMode = nil, nil, nil
end

function plugin:BigWigs_OnBossDisable(_, module)
	if module == opener then
		self:Close()
	end
end

do
	local power = -1
	local function sendPower()
		local newPower = UnitPower("player", 10) -- ALTERNATE_POWER_INDEX = 10
		if newPower ~= power then
			power = newPower
			BigWigs:Transmit("BWPower", newPower)
		end
	end

	function plugin:RosterUpdateForHiddenDisplay()
		-- This is for people that don't show the AltPower display (event isn't registered to the display as it normally would be).
		-- It will force sending the current power for those that do have the display shown but just had their power list reset by a 
		-- GROUP_ROSTER_UPDATE. Or someone DCd and is logging back on, so send an update.
		if not IsInGroup() then plugin:Close() return end
		self:CancelTimer(repeatSync)
		power = -1
		repeatSync = self:ScheduleRepeatingTimer(sendPower, 1)
	end

	function plugin:BigWigs_StartSyncingPower(_, module)
		if not IsInGroup() then return end
		power = -1
		opener = module
		if not repeatSync then
			repeatSync = self:ScheduleRepeatingTimer(sendPower, 1)
			if display and display:IsShown() then
				syncPowerList = {}
			else
				self:RegisterEvent("GROUP_ROSTER_UPDATE", "RosterUpdateForHiddenDisplay")
			end
		end
	end

	function plugin:OnSync(sync, amount, nick)
		local curPower = tonumber(amount)
		if curPower then
			for i = 1, maxPlayers do
				local unit = unitList[i]
				if nick == self:UnitName(unit) then
					syncPowerList[unit] = curPower
					break
				end
			end
		end
	end
end

