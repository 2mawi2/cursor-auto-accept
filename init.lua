-- Hammerspoon init.lua

---------------------------------------
-- Configuration
---------------------------------------
local CURSOR_APP_NAME = "Cursor"
local LOOP_INTERVAL = 2

---------------------------------------
-- Globals
---------------------------------------
local cursorTimer = nil
local menubarItem = hs.menubar.new()
local logger = hs.logger.new('CursorLoop', 'info')
local userInputTap = nil

---------------------------------------
-- Helper Functions
---------------------------------------

local function updateMenubar()
    if menubarItem then
        menubarItem:setTitle(cursorTimer and "Cursor Loop: Running" or "Cursor Loop: Stopped")
    end
end

local function stopCursorLoop(reason)
    if cursorTimer then
        cursorTimer:stop()
        cursorTimer = nil
        updateMenubar()
        if reason then
            hs.alert.show("Cursor loop stopped: " .. reason)
            logger.i("Cursor loop stopped: " .. reason)
        else
            hs.alert.show("Cursor loop stopped")
            logger.i("Cursor loop stopped")
        end
    else
        logger.i("Attempted to stop cursor loop, but it's not running")
    end
    
    -- Stop monitoring user input since the loop is not active
    if userInputTap then
        userInputTap:stop()
        userInputTap = nil
    end
end

local function sendKeystrokeToCursor()
    local app = hs.application.get(CURSOR_APP_NAME)
    if app then
        hs.eventtap.keyStroke({"cmd"}, "return", app)
        logger.i("Sent Command + Return to " .. CURSOR_APP_NAME)
    else
        hs.alert.show(CURSOR_APP_NAME .. " application not found.")
        logger.w(CURSOR_APP_NAME .. " application not found.")
        stopCursorLoop("App not found")
    end
end

local function startCursorLoop()
    if not cursorTimer then
        cursorTimer = hs.timer.doEvery(LOOP_INTERVAL, sendKeystrokeToCursor)
        updateMenubar()
        hs.alert.show("Cursor loop started")
        logger.i("Cursor loop started")
        
        -- Start monitoring user input events
        -- This eventtap does not block or modify events. It simply observes them.
        userInputTap = hs.eventtap.new({hs.eventtap.event.types.keyDown}, function(evt)
            local frontApp = hs.application.frontmostApplication()
            if frontApp and frontApp:name() == CURSOR_APP_NAME then
                -- User typed something in Cursor, stop the loop
                stopCursorLoop("User input detected in Cursor")
            end
            return false -- Do not block or interfere with the keystroke
        end)
        userInputTap:start()
    else
        hs.alert.show("Cursor loop is already running")
        logger.i("Attempted to start cursor loop, but it's already running")
    end
end

local function toggleCursorLoop()
    if cursorTimer then
        stopCursorLoop()
    else
        startCursorLoop()
    end
end

---------------------------------------
-- Hotkey and IPC Setup
---------------------------------------

-- Set up a hotkey (Ctrl + Alt + C) to toggle the loop
hs.hotkey.bind({"ctrl", "alt"}, "C", toggleCursorLoop)

-- Ensure the hs binary is installed correctly (adjust path if necessary)
hs.ipc.cliInstall("/usr/local/bin/hs")

-- Define command callbacks for IPC
if hs.ipc.setCommandCallback then
    hs.ipc.setCommandCallback(function(cmd, args)
        if cmd == "start" then
            startCursorLoop()
            return "Cursor loop started."
        elseif cmd == "stop" then
            stopCursorLoop()
            return "Cursor loop stopped."
        elseif cmd == "toggle" then
            toggleCursorLoop()
            return "Cursor loop toggled."
        elseif cmd == "status" then
            return cursorTimer and "running" or "stopped"
        else
            return "Unknown command: " .. tostring(cmd)
        end
    end)
else
    logger.e("hs.ipc.setCommandCallback is not available.")
end

---------------------------------------
-- Periodic Menubar Update
---------------------------------------
hs.timer.doEvery(60, updateMenubar)

---------------------------------------
-- Initial UI State
---------------------------------------
updateMenubar()