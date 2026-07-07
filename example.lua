local Lumina = require(script.Parent:WaitForChild("lumina"))

local UI = Lumina.new("My Script")

local mainTab = UI:AddTab("Main", true)
local settingsTab = UI:AddTab("Settings", false)

UI:AddToggle(mainTab, "Auto Farm", "autoFarm", function(enabled)
	if enabled then
		UI:Notify("Auto Farm", "Auto farming enabled", 3)
	else
		UI:Notify("Auto Farm", "Auto farming disabled", 3)
	end
end)

UI:AddToggle(mainTab, "Auto Sell", "autoSell", function(enabled)
	if enabled then
		UI:Notify("Auto Sell", "Auto selling enabled", 3)
	end
end)

UI:AddSlider(mainTab, "Farm Speed", 1, 10, "farmSpeed", function(value)
	print("Farm speed set to: " .. value)
end)

UI:AddDropdown(mainTab, "Select Items", {"Sword", "Shield", "Potion", "Gem"}, "selectedItems", function(item, selected)
	print(item .. " selected: " .. tostring(selected))
end)

UI:AddToggle(settingsTab, "Notifications", "notifications", function(enabled)
	print("Notifications: " .. tostring(enabled))
end)

UI:AddSlider(settingsTab, "Volume", 0, 100, "volume", function(value)
	print("Volume: " .. value .. "%")
end)

UI:Notify("Welcome", "Script loaded successfully!", 4)
