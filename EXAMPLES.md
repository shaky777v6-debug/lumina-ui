# Lumina UI - Advanced Examples

This document contains advanced usage examples for Lumina UI.

## Table of Contents

1. [Game Automation Script](#game-automation-script)
2. [Settings Manager](#settings-manager)
3. [Multi-Tab Configuration](#multi-tab-configuration)
4. [Real-Time Monitoring](#real-time-monitoring)

---

## Game Automation Script

A complete example of an automated farming script with Lumina UI:

```lua
local Lumina = require(script.Parent:WaitForChild("lumina"))
local RunService = game:GetService("RunService")

local UI = Lumina.new("Farm Bot v1.0")

local farmTab = UI:AddTab("Farming", true)
local combatTab = UI:AddTab("Combat", false)
local settingsTab = UI:AddTab("Settings", false)

UI:AddToggle(farmTab, "Enable Auto Farm", "autoFarm", function(enabled)
    if enabled then
        UI:Notify("Farm", "Auto farming started", 2)
    else
        UI:Notify("Farm", "Auto farming stopped", 2)
    end
end)

UI:AddSlider(farmTab, "Farm Speed", 1, 10, "farmSpeed", function(speed)
    print("Farm speed: " .. speed .. "x")
end)

UI:AddDropdown(farmTab, "Target Mobs", {"Goblin", "Orc", "Dragon", "Boss"}, "targetMobs", function(mob, selected)
    if selected then
        print("Added: " .. mob)
    else
        print("Removed: " .. mob)
    end
end)

UI:AddToggle(combatTab, "Auto Attack", "autoAttack", function(enabled)
    if enabled then
        UI:Notify("Combat", "Auto attack enabled", 2)
    end
end)

UI:AddSlider(combatTab, "Attack Delay", 0.1, 2, "attackDelay", nil)

UI:AddToggle(combatTab, "Auto Heal", "autoHeal", function(enabled)
    if enabled then
        UI:Notify("Combat", "Auto heal enabled", 2)
    end
end)

UI:AddSlider(settingsTab, "Health Threshold", 10, 100, "healthThreshold", nil)

UI:AddToggle(settingsTab, "Show Notifications", "showNotifs", function(enabled)
    if enabled then
        UI:Notify("Settings", "Notifications enabled", 2)
    end
end)

UI:Notify("Welcome", "Farm Bot loaded!", 3)

RunService.Heartbeat:Connect(function()
    if UI.config.autoFarm then
        local speed = UI.config.farmSpeed
        local targets = UI.config.targetMobs
        
        for target, selected in pairs(targets) do
            if selected then
                -- Farm logic here
            end
        end
    end
    
    if UI.config.autoAttack then
        local delay = UI.config.attackDelay
        -- Attack logic here
    end
    
    if UI.config.autoHeal and UI.config.healthThreshold then
        -- Heal logic here
    end
end)
```

---

## Settings Manager

A reusable settings manager pattern with Lumina UI:

```lua
local Lumina = require(script.Parent:WaitForChild("lumina"))
local HttpService = game:GetService("HttpService")

local UI = Lumina.new("Settings Manager")
local settingsTab = UI:AddTab("Settings", true)

local DEFAULT_SETTINGS = {
    username = "Player",
    volume = 50,
    quality = "High",
    notifications = true,
}

local SETTINGS_FILE = "settings.json"

local function saveSettings()
    local json = HttpService:JSONEncode(UI.config)
    writefile(SETTINGS_FILE, json)
    UI:Notify("Saved", "Settings saved successfully", 2)
end

local function loadSettings()
    if isfile(SETTINGS_FILE) then
        local json = readfile(SETTINGS_FILE)
        local loaded = HttpService:JSONDecode(json)
        for key, value in pairs(loaded) do
            UI.config[key] = value
        end
        UI:Notify("Loaded", "Settings loaded", 2)
    else
        for key, value in pairs(DEFAULT_SETTINGS) do
            UI.config[key] = value
        end
    end
end

UI:AddToggle(settingsTab, "Notifications", "notifications", function(enabled)
    saveSettings()
end)

UI:AddSlider(settingsTab, "Volume", 0, 100, "volume", function(value)
    saveSettings()
end)

UI:AddDropdown(settingsTab, "Quality", {"Low", "Medium", "High", "Ultra"}, "quality", function(quality, selected)
    if selected then
        saveSettings()
    end
end)

loadSettings()
UI:Notify("Ready", "Settings loaded and ready", 2)
```

---

## Multi-Tab Configuration

Organize a complex script into multiple logical tabs:

```lua
local Lumina = require(script.Parent:WaitForChild("lumina"))

local UI = Lumina.new("Complex Script")

local mainTab = UI:AddTab("Main", true)
local farmingTab = UI:AddTab("Farming", false)
local combatTab = UI:AddTab("Combat", false)
local itemsTab = UI:AddTab("Items", false)
local advancedTab = UI:AddTab("Advanced", false)

-- Main Tab
UI:AddToggle(mainTab, "Master Enable", "masterEnable", nil)
UI:AddSlider(mainTab, "Update Rate", 1, 60, "updateRate", nil)

-- Farming Tab
UI:AddToggle(farmingTab, "Auto Farm", "autoFarm", nil)
UI:AddSlider(farmingTab, "Farm Speed", 1, 10, "farmSpeed", nil)
UI:AddDropdown(farmingTab, "Resources", {"Wood", "Stone", "Gold", "Diamond"}, "resources", nil)

-- Combat Tab
UI:AddToggle(combatTab, "Auto Fight", "autoFight", nil)
UI:AddSlider(combatTab, "Aggression", 1, 10, "aggression", nil)
UI:AddToggle(combatTab, "Auto Dodge", "autoDodge", nil)

-- Items Tab
UI:AddToggle(itemsTab, "Auto Pickup", "autoPickup", nil)
UI:AddSlider(itemsTab, "Pickup Range", 10, 100, "pickupRange", nil)
UI:AddDropdown(itemsTab, "Item Rarity", {"Common", "Rare", "Epic", "Legendary"}, "itemRarity", nil)

-- Advanced Tab
UI:AddToggle(advancedTab, "Debug Mode", "debugMode", nil)
UI:AddSlider(advancedTab, "Debug Level", 0, 5, "debugLevel", nil)
UI:AddToggle(advancedTab, "Performance Monitor", "perfMonitor", nil)

UI:Notify("Loaded", "All modules initialized", 3)
```

---

## Real-Time Monitoring

Display real-time data with Lumina UI:

```lua
local Lumina = require(script.Parent:WaitForChild("lumina"))
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local UI = Lumina.new("Monitor")
local statsTab = UI:AddTab("Stats", true)
local logsTab = UI:AddTab("Logs", false)

UI:AddToggle(statsTab, "Monitor Active", "monitorActive", nil)

local lastNotification = 0

RunService.Heartbeat:Connect(function()
    if UI.config.monitorActive then
        local player = Players.LocalPlayer
        local character = player.Character
        
        if character then
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                local health = humanoid.Health
                local maxHealth = humanoid.MaxHealth
                local healthPercent = (health / maxHealth) * 100
                
                if healthPercent < 30 and tick() - lastNotification > 5 then
                    UI:Notify("Warning", "Health critical: " .. math.floor(healthPercent) .. "%", 2)
                    lastNotification = tick()
                end
            end
        end
    end
end)
```

---

## Tips for Advanced Usage

### 1. Organize with Tabs
Use tabs to separate different features and keep the UI clean.

### 2. Use Callbacks Effectively
Callbacks allow you to react to user input immediately:
```lua
UI:AddToggle(tab, "Feature", "feature", function(enabled)
    if enabled then
        startFeature()
    else
        stopFeature()
    end
end)
```

### 3. Access Config Values
Check configuration values in your game loop:
```lua
if UI.config.autoFarm and UI.config.farmSpeed > 5 then
    -- Run high-speed farming
end
```

### 4. Combine Multiple Elements
Create complex interactions by combining toggles, sliders, and dropdowns:
```lua
UI:AddToggle(tab, "Advanced Mode", "advancedMode", nil)
UI:AddSlider(tab, "Precision", 1, 100, "precision", nil)
UI:AddDropdown(tab, "Algorithm", {"Fast", "Balanced", "Accurate"}, "algorithm", nil)
```

### 5. Provide User Feedback
Always notify users of important state changes:
```lua
UI:Notify("Status", "Operation completed successfully", 3)
```

---

## Performance Considerations

- Keep the number of UI elements reasonable (< 50 per tab)
- Use callbacks instead of polling UI values
- Minimize notification frequency
- Clean up resources when the script stops

---

For more information, see the main [README.md](README.md).
