# Lumina UI

A modern, lightweight GUI library for Roblox scripts with smooth animations, intuitive components, and a professional dark theme.

## Features

- **Tabs System**: Organize your UI into multiple tabs with smooth transitions
- **Toggles**: Boolean switches with animated state changes
- **Sliders**: Numeric input with real-time value updates
- **Dropdowns**: Multi-select dropdown menus with smooth animations
- **Notifications**: Toast-style notifications with auto-dismiss
- **Draggable Window**: Move your UI around the screen
- **Minimizable**: Collapse the window to just the header
- **Dark Theme**: Professional dark color scheme optimized for readability
- **Smooth Animations**: All interactions use tweens for polished feel

## Installation

1. Download `lumina.lua` to your scripts folder
2. Require it in your script:

```lua
local Lumina = require(game:GetService("ServerScriptService"):WaitForChild("lumina"))
```

Or for client-side scripts:

```lua
local Lumina = require(script.Parent:WaitForChild("lumina"))
```

## Quick Start

```lua
local Lumina = require(script.Parent:WaitForChild("lumina"))

local UI = Lumina.new("My Script")

local mainTab = UI:AddTab("Main", true)

UI:AddToggle(mainTab, "Auto Farm", "autoFarm", function(enabled)
    print("Auto Farm: " .. tostring(enabled))
end)

UI:AddSlider(mainTab, "Speed", 1, 100, "speed", function(value)
    print("Speed: " .. value)
end)

UI:Notify("Welcome", "Script loaded!", 3)
```

## API Reference

### Creating a UI

```lua
local UI = Lumina.new(title)
```

Creates a new Lumina UI window.

**Parameters:**
- `title` (string): The title displayed in the window header

**Returns:** Lumina UI instance

---

### Adding Tabs

```lua
local tab = UI:AddTab(name, isDefault)
```

Adds a new tab to the UI.

**Parameters:**
- `name` (string): Tab name
- `isDefault` (boolean, optional): Whether this tab is shown by default (defaults to true for first tab)

**Returns:** ScrollingFrame for adding elements

---

### Adding a Toggle

```lua
UI:AddToggle(parent, text, key, callback)
```

Adds a toggle switch to the specified parent.

**Parameters:**
- `parent` (Frame): The tab or container to add the toggle to
- `text` (string): Label text
- `key` (string): Config key for storing the value
- `callback` (function, optional): Called when toggled with boolean parameter

**Example:**
```lua
UI:AddToggle(mainTab, "Auto Farm", "autoFarm", function(enabled)
    if enabled then
        startFarming()
    else
        stopFarming()
    end
end)
```

---

### Adding a Slider

```lua
UI:AddSlider(parent, text, minVal, maxVal, key, callback)
```

Adds a numeric slider to the specified parent.

**Parameters:**
- `parent` (Frame): The tab or container to add the slider to
- `text` (string): Label text
- `minVal` (number): Minimum value
- `maxVal` (number): Maximum value
- `key` (string): Config key for storing the value
- `callback` (function, optional): Called on value change with number parameter

**Example:**
```lua
UI:AddSlider(mainTab, "Farm Speed", 1, 10, "farmSpeed", function(value)
    setFarmSpeed(value)
end)
```

---

### Adding a Dropdown

```lua
UI:AddDropdown(parent, text, options, key, callback)
```

Adds a multi-select dropdown to the specified parent.

**Parameters:**
- `parent` (Frame): The tab or container to add the dropdown to
- `text` (string): Label text
- `options` (table): Array of option strings
- `key` (string): Config key for storing selections
- `callback` (function, optional): Called on selection change with (item, selected) parameters

**Example:**
```lua
UI:AddDropdown(mainTab, "Select Items", {"Sword", "Shield", "Potion"}, "selectedItems", function(item, selected)
    if selected then
        print(item .. " selected")
    else
        print(item .. " deselected")
    end
end)
```

---

### Sending Notifications

```lua
UI:Notify(title, message, duration)
```

Displays a notification that auto-dismisses.

**Parameters:**
- `title` (string): Notification title
- `message` (string): Notification message
- `duration` (number, optional): Seconds before auto-dismiss (defaults to 4)

**Example:**
```lua
UI:Notify("Success", "Item purchased!", 3)
UI:Notify("Error", "Not enough currency", 4)
```

---

## Configuration

The UI stores all values in `UI.config` table. Access them directly:

```lua
local UI = Lumina.new("My Script")
local tab = UI:AddTab("Main", true)

UI:AddToggle(tab, "Feature", "feature", nil)

print(UI.config.feature)  -- true or false
print(UI.config["feature"])  -- same as above
```

---

## Customization

### Colors

Edit the `COLORS` table in `lumina.lua` to customize the theme:

```lua
local COLORS = {
    background = Color3.fromRGB(18, 18, 20),
    surface = Color3.fromRGB(24, 24, 28),
    primary = Color3.fromRGB(45, 120, 255),
    text_primary = Color3.fromRGB(230, 230, 235),
    -- ... more colors
}
```

### Animation Speed

Modify the `TWEENS` table to adjust animation timing:

```lua
local TWEENS = {
    fast = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    normal = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    smooth = TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
}
```

---

## Examples

### Complete Script Example

```lua
local Lumina = require(script.Parent:WaitForChild("lumina"))

local UI = Lumina.new("Advanced Script")

local mainTab = UI:AddTab("Main", true)
local advancedTab = UI:AddTab("Advanced", false)

UI:AddToggle(mainTab, "Enable Script", "enabled", function(state)
    if state then
        UI:Notify("Enabled", "Script is now running", 2)
    end
end)

UI:AddSlider(mainTab, "Update Rate", 1, 60, "updateRate", function(fps)
    print("Update rate: " .. fps .. " FPS")
end)

UI:AddDropdown(mainTab, "Game Mode", {"Easy", "Normal", "Hard"}, "gameMode", function(mode, selected)
    if selected then
        print("Selected: " .. mode)
    end
end)

UI:AddToggle(advancedTab, "Debug Mode", "debug", nil)
UI:AddSlider(advancedTab, "Debug Level", 0, 5, "debugLevel", nil)

UI:Notify("Welcome", "Script loaded successfully!", 4)

game:GetService("RunService").Heartbeat:Connect(function()
    if UI.config.enabled then
        -- Your script logic here
    end
end)
```

---

## Tips & Tricks

1. **Store References**: Save tab references for later use
   ```lua
   local mainTab = UI:AddTab("Main", true)
   local settingsTab = UI:AddTab("Settings", false)
   ```

2. **Organize Elements**: Use multiple tabs to organize related settings
   ```lua
   local farmTab = UI:AddTab("Farming", true)
   local combatTab = UI:AddTab("Combat", false)
   ```

3. **Use Notifications**: Provide feedback for important actions
   ```lua
   UI:Notify("Success", "Configuration saved", 3)
   ```

4. **Access Config Values**: Check configuration values in your game loop
   ```lua
   if UI.config.autoFarm then
       -- Run farming logic
   end
   ```

---

## Performance

Lumina UI is optimized for performance:
- Minimal object creation
- Efficient event handling
- Smooth 60 FPS animations
- Low memory footprint

---

## License

MIT License - Feel free to use and modify for your projects.

---

## Support

For issues, suggestions, or contributions, please open an issue on GitHub.

Enjoy building with Lumina UI! ✨
