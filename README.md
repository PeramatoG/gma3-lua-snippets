# grandMA3 Plugin Utilities

Small, reusable Lua helpers and UI components for building larger grandMA3 plugins.

> Work in progress. At the moment this repo only contains the **Keypad** UI component, but it is designed to host more small tools over time.

## Goals

- Provide small, focused building blocks you can drop into your own plugins.
- Keep each tool self-contained and easy to read/modify.
- Document clearly what the user is expected to change when integrating a tool.

---

## Keypad UI Component

The **Keypad** component shows a simple on-screen keypad dialog to let the user enter a PIN or numeric code and returns the result to your plugin.

Typical use cases:

- Protecting a setup page with a PIN.
- Asking the operator to confirm actions with a numeric code.
- Quick numeric input for your plugin without building a full UI every time.

### Files

- `ui/keypad.lua` – UI component that implements `helpers.ShowKeypadDialog`.
- `examples/keypad_test.lua` – Minimal example that calls the keypad and checks a hard-coded PIN.

(Adjust the paths to match your own project structure.)

### How it works

- Your plugin passes a `display_handle` and a callback function to `helpers.ShowKeypadDialog`.
- The keypad dialog is shown on the chosen display.
- When the user finishes, your callback is called with:
  - the entered `pin` (string)
  - a `wasCancelled` flag (boolean)

Your plugin is responsible for validating the PIN and reacting accordingly.

### Integrating the Keypad into your plugin

1. **Copy the component files**

   Add the keypad UI file (and the example if you want) into your plugin repo, for example:

   - `components/ui/keypad.lua`
   - `components/examples/keypad_test.lua`

2. **Expose the helper**

   Make sure your plugin loads the keypad component and passes its functions through the shared `helpers` table, so other components can call `helpers.ShowKeypadDialog`.

3. **Call the keypad**

   In any component where you need a PIN, call the keypad and process the result in the callback. The test component does exactly this with a fixed PIN `"1234"`.

4. **Changing the PIN length**

   The example keypad is configured for a 4-digit code.
   If you want a different length, open the keypad UI file and look for the constant or variable that limits the number of digits (for example `MAX_PIN_LENGTH = 4`) and change it to your desired value.

### Customisation ideas

- Change the title / message text shown on the keypad.
- Allow non-numeric characters if you need an alphanumeric code.
- Store the expected PIN in a configuration file instead of hard-coding it.
- Use the keypad not only for security but also for quick numeric parameters.

---

## Roadmap / future tools

This repository is meant to grow over time. Possible future utilities:

- Simple selection dialogs (lists with OK/Cancel).
- Common message / confirmation boxes.
- Small helpers for working with fixtures, presets, and sequences.
- Logging and debugging helpers shared between plugins.

Contributions and ideas are welcome — feel free to adapt everything to your own workflow.
