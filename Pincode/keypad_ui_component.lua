-- grandMA3 Keypad UI component by Peramato
-- This component provides a masked keypad dialog and an API function
-- helpers.ShowKeypadDialog(display_handle, options)
-- Options:
--   title      : string, window title (default: "Enter PIN")
--   maxLength  : integer, maximum PIN length (default: 8)
--   onComplete : function(pin, wasCancelled)
--                pin is a string or nil when cancelled

local pluginName    = select(1, ...)
local componentName = select(2, ...)
local helpers       = select(3, ...)
local myHandle      = select(4, ...)

-- Ensure helpers table exists
helpers = helpers or {}

-- Public API: show keypad dialog
function helpers.ShowKeypadDialog(display_handle, options)
    options = options or {}

    local title      = options.title or "Enter PIN"
    local maxLength  = options.maxLength or 8
    local onComplete = options.onComplete

    -- Determine which display to use
    local displayIndex = Obj.Index(GetFocusDisplay())
    if displayIndex > 5 then
        displayIndex = 1
    end

    local colorTransparent        = Root().ColorTheme.ColorGroups.Global.Transparent
    local colorBackground         = Root().ColorTheme.ColorGroups.Button.Background
    local colorBackgroundPlease   = Root().ColorTheme.ColorGroups.Button.BackgroundPlease

    local display       = GetDisplayByIndex(displayIndex)
    local screenOverlay = display.ScreenOverlay

    -- Clear any existing custom UI
    screenOverlay:ClearUIChildren()

    -- Base dialog
    local dialogWidth = 420
    local baseInput = screenOverlay:Append("BaseInput")
    baseInput.Name = "KeypadDialog"
    baseInput.H = "0"
    baseInput.W = dialogWidth
    baseInput.MaxSize = string.format("%s,%s", display.W * 0.8, display.H)
    baseInput.MinSize = string.format("%s,0", dialogWidth - 120)
    baseInput.Columns = 1
    baseInput.Rows = 2
    baseInput[1][1].SizePolicy = "Fixed"
    baseInput[1][1].Size = "60"
    baseInput[1][2].SizePolicy = "Stretch"
    baseInput.AutoClose = "No"
    baseInput.CloseOnEscape = "Yes"

    -- Title bar
    local titleBar = baseInput:Append("TitleBar")
    titleBar.Columns = 2
    titleBar.Rows = 1
    titleBar.Anchors = "0,0"
    titleBar[2][2].SizePolicy = "Fixed"
    titleBar[2][2].Size = "50"
    titleBar.Texture = "corner2"

    local titleBarLabel = titleBar:Append("TitleButton")
    titleBarLabel.Text = title
    titleBarLabel.Texture = "corner1"
    titleBarLabel.Anchors = "0,0"

    local titleBarCloseButton = titleBar:Append("CloseButton")
    titleBarCloseButton.Anchors = "1,0"
    titleBarCloseButton.Texture = "corner2"
    titleBarCloseButton.PluginComponent = myHandle
    titleBarCloseButton.Clicked = "KeypadOnCloseClicked"

    -- Main frame with 3 rows: label, keypad, bottom buttons
    local dlgFrame = baseInput:Append("DialogFrame")
    dlgFrame.H = "100%"
    dlgFrame.W = "100%"
    dlgFrame.Columns = 1
    dlgFrame.Rows = 3
    dlgFrame.Anchors = { left = 0, right = 0, top = 1, bottom = 1 }
    dlgFrame[1][1].SizePolicy = "Fixed"
    dlgFrame[1][1].Size = "70"   -- label row
    dlgFrame[1][2].SizePolicy = "Fixed"
    dlgFrame[1][2].Size = "230"  -- keypad row
    dlgFrame[1][3].SizePolicy = "Fixed"
    dlgFrame[1][3].Size = "80"   -- buttons row

    -- Label row
    local label = dlgFrame:Append("UIObject")
    label.Text = "Enter code"
    label.ContentDriven = "Yes"
    label.ContentWidth = "No"
    label.TextAutoAdjust = "No"
    label.TextalignmentH = "Centre"
    label.Anchors = { left = 0, right = 0, top = 0, bottom = 0 }
    label.Padding = { left = 20, right = 20, top = 15, bottom = 15 }
    label.Font = "Medium20"
    label.HasHover = "No"
    label.BackColor = colorTransparent

    -- Keypad grid (4 x 4)
    local keypadGrid = dlgFrame:Append("UILayoutGrid")
    keypadGrid.Columns = 4
    keypadGrid.Rows = 4
    keypadGrid.Anchors = { left = 0, right = 0, top = 1, bottom = 1 }
    keypadGrid.Margin = { left = 10, right = 10, top = 0, bottom = 5 }

    local keys = {
        "1","2","3","A",
        "4","5","6","B",
        "7","8","9","C",
        "*","0","#","D"
    }

    for index, key in ipairs(keys) do
        local row = math.floor((index - 1) / 4)
        local col = (index - 1) % 4

        local btn = keypadGrid:Append("Button")
        btn.Text = key
        btn.TextalignmentH = "Centre"
        btn.Font = "Medium20"
        btn.Textshadow = 1
        btn.HasHover = "Yes"
        btn.Margin = { left = 4, right = 4, top = 4, bottom = 4 }
        btn.Anchors = { left = col, right = col, top = row, bottom = row }
        btn.PluginComponent = myHandle
        btn.Clicked = "KeypadOnKeyClicked"
        btn.BackColor = colorBackground
    end

    -- Bottom buttons grid
    local buttonGrid = dlgFrame:Append("UILayoutGrid")
    buttonGrid.Columns = 3
    buttonGrid.Rows = 1
    buttonGrid.Anchors = { left = 0, right = 0, top = 2, bottom = 2 }
    buttonGrid.Margin = { left = 10, right = 10, top = 5, bottom = 10 }

    local showButton = buttonGrid:Append("Button")
    showButton.Anchors = { left = 0, right = 0, top = 0, bottom = 0 }
    showButton.Text = "Show"
    showButton.TextalignmentH = "Centre"
    showButton.Font = "Medium20"
    showButton.Textshadow = 1
    showButton.HasHover = "Yes"
    showButton.PluginComponent = myHandle
    showButton.Clicked = "KeypadOnToggleShowClicked"
    showButton.BackColor = colorBackground

    local deleteButton = buttonGrid:Append("Button")
    deleteButton.Anchors = { left = 1, right = 1, top = 0, bottom = 0 }
    deleteButton.Text = "Delete"
    deleteButton.TextalignmentH = "Centre"
    deleteButton.Font = "Medium20"
    deleteButton.Textshadow = 1
    deleteButton.HasHover = "Yes"
    deleteButton.PluginComponent = myHandle
    deleteButton.Clicked = "KeypadOnDeleteClicked"
    deleteButton.BackColor = colorBackground

    local sendButton = buttonGrid:Append("Button")
    sendButton.Anchors = { left = 2, right = 2, top = 0, bottom = 0 }
    sendButton.Text = "Send"
    sendButton.TextalignmentH = "Centre"
    sendButton.Font = "Medium20"
    sendButton.Textshadow = 1
    sendButton.HasHover = "Yes"
    sendButton.PluginComponent = myHandle
    sendButton.Clicked = "KeypadOnSendClicked"
    sendButton.BackColor = colorBackgroundPlease

    -- State for this dialog instance
    local currentPin   = ""
    local showPlain    = false
    local maxLen       = maxLength
    local overlay      = screenOverlay
    local base         = baseInput

    local function updateLabel()
        local text
        if #currentPin == 0 then
            text = "Enter code"
        else
            if showPlain then
                text = currentPin
            else
                text = string.rep("*", #currentPin)
            end
        end
        label.Text = text
    end

    -- Signal handlers (stored on helpers table)
    helpers.KeypadOnCloseClicked = function(caller)
        -- User closed the dialog using the title bar close button
        currentPin = ""
        updateLabel()
        if onComplete then
            onComplete(nil, true)
        end
        Obj.Delete(overlay, Obj.Index(base))
    end

    helpers.KeypadOnKeyClicked = function(caller)
        local key = caller.Text or ""
        if key == "" then
            return
        end
        if #currentPin >= maxLen then
            return
        end
        currentPin = currentPin .. key
        updateLabel()
    end

    helpers.KeypadOnToggleShowClicked = function(caller)
        showPlain = not showPlain
        if showPlain then
            caller.BackColor = colorBackgroundPlease
            caller.Text = "Hide"
        else
            caller.BackColor = colorBackground
            caller.Text = "Show"
        end
        updateLabel()
    end

    helpers.KeypadOnDeleteClicked = function(caller)
        if #currentPin > 0 then
            currentPin = string.sub(currentPin, 1, #currentPin - 1)
            updateLabel()
        end
    end

    helpers.KeypadOnSendClicked = function(caller)
        if onComplete then
            onComplete(currentPin, false)
        end
        -- Clear and close
        currentPin = ""
        updateLabel()
        Obj.Delete(overlay, Obj.Index(base))
    end

    -- Ensure initial label is correct
    updateLabel()
end

-- This component does not run by itself; it only provides helpers.
return function() end
