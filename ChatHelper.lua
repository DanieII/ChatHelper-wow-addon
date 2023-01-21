SLASH_RELOADUI1 = "/r" -- a shorter command for faster reloading of the interface
SlashCmdList.RELOADUI = ReloadUI

local function LoadedAddOn(self, event, name)
    if name == "ChatHelper" then
        print("ChatHelper loaded")
	end
end

local start = CreateFrame("Frame")
start:RegisterEvent("ADDON_LOADED")
start:SetScript("OnEvent", LoadedAddOn)
---------------------------------------------------------------------------------



UIConfig = CreateFrame("Frame", "ChatHelperFrame", UIParent, "UIPanelDialogTemplate")
UIConfig:SetSize(200,250)
UIConfig:SetPoint("CENTER", UIParent, "CENTER")

-- Window Flexibility
UIConfig:EnableMouse(true)
UIConfig:SetMovable(true)
UIConfig:SetResizable(true)
UIConfig:SetMinResize(180,230)
UIConfig:SetMaxResize(220,270)

-- Dragging
UIConfig:RegisterForDrag("LeftButton")
UIConfig:SetScript("OnDragStart", UIConfig.StartMoving)
UIConfig:SetScript("OnDragStop", UIConfig.StopMovingOrSizing)

-- Resize Button
local resizeButton = CreateFrame("Button", nil, UIConfig)
resizeButton:SetSize(16, 16)
resizeButton:SetPoint("BOTTOMRIGHT",-4,7)
resizeButton:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
resizeButton:SetHighlightTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
resizeButton:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")
resizeButton:SetScript("OnMouseDown", function(self, button)
	self.isSizing = true
	self:GetParent():StartSizing("BOTTOMRIGHT")
	self:GetParent():SetUserPlaced(true)
end)
resizeButton:SetScript("OnMouseUp", function(self, button)
	self.isSizing = false
	self:GetParent():StopMovingOrSizing()
end)



-- Title
UIConfig.title = UIConfig:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
UIConfig.title:SetPoint("LEFT", UIConfig, "TOP", -50, -14)
UIConfig.title:SetText("ChatHelper")

-- Info Text
UIConfig.info = UIConfig:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
UIConfig.info:SetPoint("CENTER", UIConfig.title, "CENTER", 0,-30);
UIConfig.info:SetText("Key words:")

-- Text Input for the keywords
UIConfig.editBox = CreateFrame("EditBox", "InputBox", UIConfig, "InputBoxTemplate")
UIConfig.editBox:SetPoint("TOP", UIConfig, "TOP", 0, -60)
UIConfig.editBox:SetSize(100, 20)
UIConfig.editBox:SetAutoFocus(false)
UIConfig.editBox:SetMultiLine(false)
UIConfig.editBox:SetScript("OnTextChanged", function(self, userinput)
	if #self:GetText() > 0 then
		UIConfig.startBtn:Enable()
	else
		UIConfig.startBtn:Disable()
	end
end)


-- Start Button
UIConfig.startBtn = CreateFrame("Button", nil, UIConfig, "GameMenuButtonTemplate")
UIConfig.startBtn:Enable()
UIConfig.startBtn:Disable()
UIConfig.startBtn:SetPoint("CENTER", UIConfig, "CENTER", 0, -50)
UIConfig.startBtn:SetSize(100,30)
UIConfig.startBtn:SetText("Start Searching")
UIConfig.startBtn:SetScript("OnClick", function(self)
	searching = true
	UIConfig.stopBtn:Enable()
	local words = UIConfig.editBox:GetText()
	-- Track messages
	chattracking = CreateFrame("Frame")
	chattracking:RegisterEvent("CHAT_MSG_CHANNEL")
	chattracking:SetScript("OnEvent", function(self, event, text, playername, languagename, channelname)
		if searching == true then
			for word in string.gmatch(words, "%S+") do
				if string.find(string.lower(text), string.lower(word)) then
					message("Found "..word.." in "..channelname.."\nSent From: "..playername)
					return
				end
			end
		end
		end)
	end)


-- Stop Button
UIConfig.stopBtn = CreateFrame("Button", nil, UIConfig, "GameMenuButtonTemplate")
UIConfig.stopBtn:Enable()
UIConfig.stopBtn:Disable()
UIConfig.stopBtn:SetPoint("CENTER", UIConfig, "CENTER", 0, -80)
UIConfig.stopBtn:SetSize(100,30)
UIConfig.stopBtn:SetText("Stop")
UIConfig.stopBtn:SetNormalFontObject("GameFontNorma")
UIConfig.stopBtn:SetHighlightFontObject("GameFontHighlight")
UIConfig.stopBtn:SetScript("OnClick", function(self) searching = false end)


 