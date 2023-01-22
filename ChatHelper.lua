SLASH_RELOADUI1 = "/r" -- a shorter command for faster reloading of the interface
SlashCmdList.RELOADUI = ReloadUI

local white = "|cFFFFFFFF"
local yellow = "|cFFFFFF00"
local function LoadedAddOn(self, event, name)
    if name == "ChatHelper" then
        print(yellow.."ChatHelper: "..white.."Use "..yellow.."/ch"..white.." to open the menu")
	end
end


local start = CreateFrame("Frame")
start:RegisterEvent("ADDON_LOADED")
start:SetScript("OnEvent", LoadedAddOn)
---------------------------------------------------------------------------------



UIConfig = CreateFrame("Frame", "ChatHelperFrame", UIParent, "UIPanelDialogTemplate")
UIConfig:SetSize(200,230)
UIConfig:SetPoint("CENTER", UIParent, "CENTER")
UIConfig:Hide()

-- Window Flexibility
UIConfig:EnableMouse(true)
UIConfig:SetMovable(true)
UIConfig:SetResizable(true)
UIConfig:SetMinResize(185,215)
UIConfig:SetMaxResize(210,240)

-- Dragging
UIConfig:RegisterForDrag("LeftButton")
UIConfig:SetScript("OnDragStart", UIConfig.StartMoving)
UIConfig:SetScript("OnDragStop", UIConfig.StopMovingOrSizing)

-- Resize Button
UIConfig.resizeBtn = CreateFrame("Button", nil, UIConfig)
UIConfig.resizeBtn:SetSize(16, 16)
UIConfig.resizeBtn:SetPoint("BOTTOMRIGHT",-4,7)
UIConfig.resizeBtn:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
UIConfig.resizeBtn:SetHighlightTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
UIConfig.resizeBtn:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")
UIConfig.resizeBtn:SetScript("OnMouseDown", function(self, button)
	self:GetParent():StartSizing("BOTTOMRIGHT")
end)
UIConfig.resizeBtn:SetScript("OnMouseUp", function(self, button)
	self:GetParent():StopMovingOrSizing()
end)



-- Title
UIConfig.title = UIConfig:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
UIConfig.title:SetPoint("CENTER", UIConfig, "TOP", 0, -15)
UIConfig.title:SetText("ChatHelper")


-- Text Input for the keywords
UIConfig.editBox = CreateFrame("EditBox", "InputBox", UIConfig, "InputBoxTemplate")
UIConfig.editBox:SetPoint("TOP", UIConfig.title, "TOP", 0, -60)
UIConfig.editBox:SetSize(115, 30)
UIConfig.editBox:SetAutoFocus(false)
UIConfig.editBox:SetMultiLine(false)

local placeholder = "Key words"
local function SetPlaceholder()
	UIConfig.editBox:SetText(placeholder)
	UIConfig.editBox:SetTextColor(0.5, 0.5, 0.5)
	UIConfig.editBox:EnableMouse(true)
end

SetPlaceholder()

UIConfig.editBox:SetScript("OnEditFocusGained", function(self) self:SetText("") self:SetTextColor(1, 1, 1) end)
UIConfig.editBox:SetScript("OnEditFocusLost", function(self)
    if self:GetText() == "" then
        SetPlaceholder()
    end
end)

UIConfig.editBox:SetScript("OnTextChanged", function(self, userinput)
	if self:GetText() ~= placeholder then
		if #self:GetText() > 0 then
			UIConfig.startBtn:Enable()
		else
			UIConfig.startBtn:Disable()
			UIConfig.stopBtn:Disable()
		end
	else
		UIConfig.startBtn:Disable()
		UIConfig.stopBtn:Disable()
	end
end)


-- Start Button
UIConfig.startBtn = CreateFrame("Button", nil, UIConfig, "GameMenuButtonTemplate")
UIConfig.startBtn:Enable()
UIConfig.startBtn:Disable()
UIConfig.startBtn:SetPoint("CENTER", UIConfig, "CENTER", 0, -10)
UIConfig.startBtn:SetSize(100,30)
UIConfig.startBtn:SetText("Start Searching")
local words
local searching
UIConfig.startBtn:SetScript("OnClick", function(self)
	searching = true
	UIConfig.stopBtn:Enable()
	UIConfig.editBox:EnableMouse(false)
	UIConfig.editBox:ClearFocus()
	words = UIConfig.editBox:GetText()
	-- Track messages
	chattracking = CreateFrame("Frame")
	chattracking:RegisterEvent("CHAT_MSG_CHANNEL")
	chattracking:SetScript("OnEvent", function(self, event, text, playername, languagename, channelname)
		if not searching then
            return
        end
        for word in string.gmatch(words, "%S+") do
            if string.find(string.lower(text), string.lower(word)) then
                message(white.."Found "..yellow..word..white.." in "..yellow..channelname..white.."\nSent From: "..yellow..playername)
                return
            end
        end
    end)
end)


-- Stop Button
UIConfig.stopBtn = CreateFrame("Button", nil, UIConfig, "GameMenuButtonTemplate")
UIConfig.stopBtn:Enable()
UIConfig.stopBtn:Disable()
UIConfig.stopBtn:SetPoint("CENTER", UIConfig, "CENTER", 0, -40)
UIConfig.stopBtn:SetSize(100,30)
UIConfig.stopBtn:SetText("Stop")
UIConfig.stopBtn:SetScript("OnClick", function(self) searching = false SetPlaceholder() end)
 
 
function OpenMenu()
	UIConfig:Show()
end

SLASH_OPENMENU1 = "/ch" -- Main command for displaying the menu
SlashCmdList.OPENMENU = OpenMenu
