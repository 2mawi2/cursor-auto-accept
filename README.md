# Cursor Auto Accept

A Hammerspoon script that enables autonomous operation of Cursor AI's agent mode by automatically accepting commands and changes.

## Overview

This tool automates the acceptance of commands, code changes, and other prompts in Cursor AI's agent mode by simulating `Cmd+Return` keystrokes at regular intervals. It's particularly useful for letting Cursor AI work autonomously on test-driven development tasks.

## Features

- 🤖 Automatic command/change acceptance in Cursor AI
- ⌨️ Toggle with keyboard shortcut (Ctrl + Alt + C)
- 🔄 Auto-stops when user input is detected
- 📊 Menubar status indicator
- 🔧 CLI control support via Hammerspoon

## Prerequisites

- [Hammerspoon](https://www.hammerspoon.org/) installed on your macOS
- [Cursor AI](https://cursor.sh/) installed
- macOS (tested on Ventura and later)

## Installation

1. Install Hammerspoon if you haven't already:
   ```bash
   brew install hammerspoon
   ```

2. Clone this repository:
   ```bash
   git clone https://github.com/mariusw/cursor-auto-accept.git
   ```

3. Copy or symlink `init.lua` to your Hammerspoon configuration directory:
   ```bash
   ln -s /path/to/cursor-auto-accept/init.lua ~/.hammerspoon/init.lua
   ```

4. Reload Hammerspoon configuration

## Usage

### Keyboard Control
- Use `Ctrl + Alt + C` to toggle the auto-accept loop

### CLI Control
The script can be controlled via command line using Hammerspoon's CLI:

```bash
# Start the auto-accept loop
hs -c "start"

# Stop the loop
hs -c "stop"

# Toggle the loop
hs -c "toggle"

# Check current status
hs -c "status"
```

### Features
- Automatically sends `Cmd+Return` every 2 seconds to accept Cursor AI's actions
- Automatically stops when user input is detected in Cursor
- Shows current status in the menubar
- Logs all actions for debugging

## Configuration

You can modify the following variables in `init.lua`:

- `CURSOR_APP_NAME`: The name of the Cursor application (default: "Cursor")
- `LOOP_INTERVAL`: Time between auto-accepts in seconds (default: 2)

## Best Practices

1. Use this tool primarily with test-driven development workflows
2. Monitor the initial actions to ensure correct behavior
3. Keep an eye on the menubar status
4. Use the auto-stop feature by typing when you need to intervene

## License

MIT License
