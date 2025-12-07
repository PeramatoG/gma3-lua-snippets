-- grandMA3 Keypad test component (template) by Peramato
-- This component is an example of how to:
--   1) Call helpers.ShowKeypadDialog (defined in the UI component).
--   2) Receive the PIN that the user typed (as a string).
--   3) React depending on whether it matches your expected value.
--
-- You can copy this component and adapt the parts marked with "USER CAN CHANGE".

------------------------------------------------------------
-- Component header: standard grandMA3 plugin arguments
------------------------------------------------------------
local pluginName    = select(1, ...)  -- Name of the plugin (set by grandMA3)
local componentName = select(2, ...)  -- Name of this component
local helpers       = select(3, ...)  -- Shared table between components of this plugin

-- Ensure "helpers" exists even if nothing was passed
-- (this makes the component more robust when used standalone).
helpers = helpers or {}

------------------------------------------------------------
-- Main entry point of this component
-- grandMA3 will call this function when the plugin is executed.
------------------------------------------------------------
local function Main(display_handle, argument)
    ----------------------------------------------------------------
    -- USER CAN CHANGE:
    --   expectedPin is only for testing/demos.
    --   Replace "1234" with:
    --     - another fixed PIN, OR
    --     - a value read from your own configuration, OR
    --     - remove this variable and implement custom validation
    --       directly inside onPinEntered().
    ----------------------------------------------------------------
    local expectedPin = "1234"

    ----------------------------------------------------------------
    -- Safety check: verify that the UI component is loaded and
    -- that it has registered helpers.ShowKeypadDialog.
    --
    -- REQUIREMENT:
    --   Another component in the same plugin must define:
    --     function helpers.ShowKeypadDialog(display_handle, options) ... end
    --
    -- If not available, we show a message and exit.
    ----------------------------------------------------------------
    if type(helpers.ShowKeypadDialog) ~= "function" then
        Echo("Keypad UI component is not available. Please check plugin components order.")
        return
    end

    ----------------------------------------------------------------
    -- Callback that will be called once the user presses "Send"
    -- (or closes the dialog).
    --
    -- PARAMETERS:
    --   pin          : string with the PIN typed by the user.
    --                  It is never printed while typing in the UI.
    --   wasCancelled : boolean, true if the user closed the window
    --                  without sending (e.g. X button).
    --
    -- SECURITY NOTE:
    --   The PIN only exists here in local variables. If you avoid
    --   Echo() and do not write it to global/user variables, it will
    --   not be stored in command line or system windows.
    ----------------------------------------------------------------
    local function onPinEntered(pin, wasCancelled)
        if wasCancelled then
            --------------------------------------------------------
            -- USER CAN CHANGE:
            --   What should happen if user cancels the dialog?
            --   Common options:
            --     - Do nothing
            --     - Show a short message
            --     - Abort a larger process
            --------------------------------------------------------
            Echo("PIN entry was cancelled.")
            return
        end

        ------------------------------------------------------------
        -- USER CAN CHANGE:
        --   Replace this simple comparison with your own logic.
        --   Examples:
        --     - Compare against an encrypted/hashed value.
        --     - Use the PIN as an index or key in another structure.
        --     - Trigger different actions depending on the PIN.
        ------------------------------------------------------------
        if pin == expectedPin then
            --------------------------------------------------------
            -- USER CAN CHANGE:
            --   This block runs when PIN is correct.
            --   Replace Echo() with your real action:
            --     - Call another helper function
            --     - Unlock some feature
            --     - Load/run another plugin, etc.
            --------------------------------------------------------
            Echo("PIN is correct.")
        else
            --------------------------------------------------------
            -- USER CAN CHANGE:
            --   This block runs when PIN is NOT correct.
            --   Replace or remove this Echo() according to your UX.
            --------------------------------------------------------
            Echo("PIN is incorrect.")
        end

        ------------------------------------------------------------
        -- After this function finishes, "pin" goes out of scope.
        -- No extra cleanup is required if you only used local
        -- variables and did not store the PIN elsewhere.
        ------------------------------------------------------------
    end

    ----------------------------------------------------------------
    -- Show the keypad dialog.
    --
    -- PARAMETERS:
    --   display_handle : usually forwarded from Main() as-is, so
    --                    the dialog appears on the current display.
    --
    --   options table:
    --     title      : text shown in the window title bar.
    --     maxLength  : maximum number of characters for the PIN.
    --     onComplete : callback function, called when user presses
    --                  "Send" or closes the dialog.
    --
    -- USER CAN CHANGE:
    --   - Change "title" to match your plugin.
    --   - Change "maxLength" to the length of your PIN.
    --   - Pass extra data to onPinEntered using upvalues or by
    --     creating the callback dynamically inside another function.
    ----------------------------------------------------------------
    helpers.ShowKeypadDialog(display_handle, {
        title      = "Test PIN",   -- USER CAN CHANGE: window title
        maxLength  = 4,            -- USER CAN CHANGE: max PIN length
        onComplete = onPinEntered  -- Leave as-is unless you use another callback
    })
end

------------------------------------------------------------
-- Component return value:
-- grandMA3 expects the component to return the Main function.
------------------------------------------------------------
return Main
