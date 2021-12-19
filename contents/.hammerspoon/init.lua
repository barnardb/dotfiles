-- Remapped Caps Lock
local capslockAsRemappedByKarabinerElements = "F19"
withCapslock = hs.hotkey.modal.new({}, nil);
hs.hotkey.bind({}, capslockAsRemappedByKarabinerElements, function() withCapslock:enter() end, function() withCapslock:exit() end);

-- Audio control
withCapslock:bind({}, "a", function() setAudioOutput("AirPods") end)
withCapslock:bind({}, "q", function() setAudioOutput("Internal Speakers") end)
withCapslock:bind({}, "m", function() toggleGoogleMeetMicrophoneMute() end)

-- Lighting Control
withCapslock:bind({}, '-', function() hs.shortcuts.run("Living Room Lights Off"); end)
withCapslock:bind({}, '=', function() hs.shortcuts.run("Living Room Lights On"); end)

-- Application Switching
withCapslock:bind({}, 'b', function() hs.application.launchOrFocus('Google Chrome'); end)
withCapslock:bind({}, 'e', function() hs.application.launchOrFocus('Visual Studio Code'); end)
withCapslock:bind({}, 'i', function() hs.application.launchOrFocus('IntelliJ IDEA CE'); end)
withCapslock:bind({}, 's', function() hs.application.launchOrFocus('Slack'); end)


-- Window Management

-- I used to first Spectacle and then Rectangle for window management.
-- But hammerspoon allows much more fine grained configuration, such as only using part of the screen.

-- Intercept Rectangle's keybindings, making them not use the lower part of the screen to accomodate my dying display
function bindRectangleStyleHotkey(key, x, y, w, h)
  hs.hotkey.bind({"alt", "ctrl"}, key, function()
    local window = hs.window.focusedWindow()
    local frame = window:screen():frame()
    frame.h = frame.h - 100
    window:setFrame(hs.geometry(x, y, w, h):fromUnitRect(frame), 0)
  end)
end
bindRectangleStyleHotkey("return", 0, 0, 1, 1) -- fullscreen
bindRectangleStyleHotkey("left", 0, 0, 0.5, 1) -- left half
bindRectangleStyleHotkey("right", 0.5, 0, 0.5, 1) -- right half
bindRectangleStyleHotkey("up", 0, 0, 1, 0.5) -- top half
bindRectangleStyleHotkey("down", 0, 0.5, 1, 1) -- bottom half


-- playTap = hs.eventtap.new({hs.eventtap.event.types.systemDefined}, function(event)
--   local data = event:systemKey()
--   if data["key"] == "PLAY" and data["down"] then
--     return toggleGoogleMeetMicrophoneMute(), nil
--   end
--   return false, nil
-- end)
-- playTap:start()


-- Runs AppleScript, displaying an alert if the script has an error.
function runAppleScript(script)
  local ok, result, raw = hs.osascript.applescript(script)
  if not ok then
    hs.alert(hs.inspect.inspect(raw))
  end
  return result
end


-- Sets an audio device, and toggles transparency on and off if it's already set.
function setAudioOutput(name)
  hs.alert(runAppleScript([[
    set OutputName to "]]..name..[["
    tell application "System Events"
      tell process "ControlCenter"
        set soundMenu to menu bar item "sound" of menu bar 1
        click(soundMenu)
        if not exists(window "Control Centre") then
          delay 1
        end if
        entire contents -- I don't understand why, but the script fails if this expression isn't evaluated
        tell scroll area 1 of window "Control Centre"
          if exists checkbox 1 whose title contains OutputName
            set outputCheckbox to checkbox 1 whose title contains OutputName
            if value of outputCheckbox is equal to 1 then
              set mode to "Noise Cancellation"
              if exists checkbox 1 whose title contains mode then
                if value of (checkbox 1 whose title contains mode) is 1 then
                  set mode to "Transparency"
                end if
                click(checkbox 1 whose title contains mode)
                set message to "Switched to " & mode
              else
                set message to "Already using " & OutputName
              end
            else
              click(outputCheckbox)
              set message to "Switched to " & OutputName
            end if
          else
            set message to "Can't find " & OutputName
          end if
        end tell
        click(soundMenu)
      end tell
    end tell
    message
  ]]))
end


function toggleGoogleMeetMicrophoneMute()
  local chrome = hs.application.find("Google Chrome")
  if chrome then
    used = runAppleScript([[
      tell application "Google Chrome"
        set windowIndex to 0
        repeat with theWindow in windows
          set windowIndex to windowIndex + 1
          set i to 0
          repeat with theTab in tabs of theWindow
            set i to i + 1
            if URL of theTab starts with "https://meet.google.com/" then
              set active tab index of theWindow to i
              tell application "System Events" to tell process "Google Chrome"
                perform action "AXRaise" of window windowIndex
                set frontmost to true
                keystroke "d" using command down
              end tell
              return true
            end if
          end repeat
        end repeat
      end tell
      return false
    ]])
    if used then
      hs.alert("Toggled mute status in Google Meet")
      return true
    else
      hs.alert("Didn't find any Google Meet tabs in Chrome")
    end
  end
  return false
end


-- Code useful for inspecting what's going on:
-- hs.printf("%s", hs.inspect.inspect(hs.eventtap.event.types))
-- hs.eventtap.new({"all", hs.eventtap.event.types.mouseMoved}, function(event)
--   hs.printf("EVENTY %s", hs.inspect.inspect(event:getRawEventData()))
-- end):start()
