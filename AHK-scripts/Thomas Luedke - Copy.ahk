#Requires AutoHotkey v2.0

; Check if the script is running as admin
if not A_IsAdmin
{
    ; If not, relaunch the script with the '*RunAs' verb (requests Admin)
    Run '*RunAs "' A_ScriptFullPath '"'
    ExitApp ; Close the non-admin instance
}

; --- The rest of your script goes below ---

#SingleInstance Force
SetTitleMatchMode 2

SendMode "Input"
SetTitleMatchMode 2

; ─────────────────────────────
; 1️⃣ General Hotstrings
; ─────────────────────────────

:*:/address::
{
    Send "Thomas Luedke`n258 Peace St`nChattanooga, TN 37415"
}

:*:/hsd::Haskel Sears Design

:*:/sig::
{
    Send "Thomas Luedke{enter}General Manager{enter}Haskel Sears Design{enter}(706) 516-8460"
}

:*:/email::thomas.luedke@gmail.com
:*:/workemail::thomas@haskelsearsdesign.com
:*:/ph::(706) 516-8460

; ─────────────────────────────
; 2️⃣ Notion-Only Hotstrings
; ─────────────────────────────

#HotIf WinActive("ahk_exe Notion.exe")

:X:/synb::
{
    SendInput "/synced"
    Sleep 100
    SendInput "{Enter}"
    Sleep 500 
    SendInput "!+l"
    
    ToolTip "🔗 Synced Block Created & Link Copied!"
    SetTimer () => ToolTip(), -2000 
}

#HotIf ; Reset context sensitivity

; ─────────────────────────────
; 3️⃣ Dynamic Date Hotstrings 
; ─────────────────────────────

:*:/today::
{
    Send FormatTime(, "yyyy-MM-dd")
}

:*:/now::
{
    Send FormatTime(, "HH:mm tt")
}

:*:/datetime::
{
    Send FormatTime(, "yyyy-MM-dd")
    Send " at "
    Send FormatTime(, "HH:mm tt")
}

; ==============================================================================
; 0. General Purpose Hotkeys and Remaps
; ==============================================================================

; Reload this script (Ctrl+Alt+R)
^!r::Reload


; ==============================================================================
; 1. CAPSLOCK INITIALIZATION & ESCAPE BEHAVIOR
; ==============================================================================
; Disable the native CapsLock function
SetCapsLockState "AlwaysOff"

; Mod-Tap Logic:
; - If you tap CapsLock alone: Send Escape
; - If you hold CapsLock + Key: Act as a modifier (handled by the hotkeys below)

;this is to debug but it's actually slower to the first option so we try to avoid using it.
;*CapsLock::
;{
;    KeyWait "CapsLock"
;    
;    ; check if CapsLock was the only key pressed
;    if (A_PriorKey = "CapsLock")
;    {
;        ; Use SendEvent for better compatibility with WSL/Command Prompt
;        ; {Blind} is removed here so it forces a pure "Escape" press
;        SendEvent "{Esc}"
;    }
;    return
;}

*CapsLock::
{
    KeyWait "CapsLock"
    if (A_PriorKey = "CapsLock")
        Send "{Esc}"
    return
}

 ;CapsLock + ` (Backtick) toggles the ACTUAL CapsLock state (Case toggling) 
CapsLock & `::
{
    if GetKeyState("CapsLock", "T")
        SetCapsLockState "AlwaysOff"
    else
        SetCapsLockState "AlwaysOn"
}

; ==============================================================================
; 2. VIM NAVIGATION (H J K L) & EDITING
; ==============================================================================
; {Blind} allows you to hold Shift/Ctrl/Alt physically while pressing these keys.
; Example: Shift + CapsLock + h will highlight text to the left.

CapsLock & h::Send "{Blind}{Left}"
CapsLock & j::Send "{Blind}{Down}"
CapsLock & k::Send "{Blind}{Up}"
CapsLock & l::Send "{Blind}{Right}"

; Word Movement
CapsLock & w::Send "{Blind}^{Right}" ; Move forward by word
CapsLock & b::Send "{Blind}^{Left}"  ; Move backward by word

; Home/End/PageUp/PageDown
CapsLock & i::Send "{Blind}{Home}"
CapsLock & o::Send "{Blind}{End}"
CapsLock & u::Send "{Blind}{PgUp}"
CapsLock & p::Send "{Blind}{PgDn}"

; ==============================================================================
; 3. DELETION
; ==============================================================================
CapsLock & ,::Send "{Del}"       ; Forward Delete
CapsLock & .::Send "^{Del}"      ; Delete Word Forward
CapsLock & m::Send "{BS}"        ; Backspace
CapsLock & n::Send "^{BS}"       ; Backspace Word

; ==============================================================================
; 4. SMOOTH MOUSE MOVEMENT (FIXED FOR MULTI-MONITOR & ACCELERATION)
; ==============================================================================
; We route all four directional hotkeys to a single smooth-movement function.
CapsLock & Up::SmoothMouseMove()
CapsLock & Down::SmoothMouseMove()
CapsLock & Left::SmoothMouseMove()
CapsLock & Right::SmoothMouseMove()

SmoothMouseMove() {
    ; Prevent multiple loops from running at the same time
    Static IsMoving := false
    if IsMoving
        return
    IsMoving := true
    
    ; --- TWEAK THESE NUMBERS TO PERFECT THE FEEL ---
    BaseSpeed := 3.0    ; Starting speed (low for precise clicking)
    MaxSpeed := 20       ; Top speed (high for crossing monitors)
    Acceleration := 0.7    ; How much speed ramps up every 10ms
    TickRate := 10         ; Loop frequency in ms (10ms = 100fps smoothness)
    ; -----------------------------------------------
    
    CurrentSpeed := BaseSpeed
    
    ; Keep moving as long as CapsLock AND at least one direction is physically held
    While GetKeyState("CapsLock", "P") && (GetKeyState("Up", "P") || GetKeyState("Down", "P") || GetKeyState("Left", "P") || GetKeyState("Right", "P"))
    {
        dx := 0
        dy := 0
        
        ; Calculate diagonal math if holding two keys
        if GetKeyState("Left", "P")
            dx -= CurrentSpeed
        if GetKeyState("Right", "P")
            dx += CurrentSpeed
        if GetKeyState("Up", "P")
            dy -= CurrentSpeed
        if GetKeyState("Down", "P")
            dy += CurrentSpeed
        
        ; Move the mouse via Windows API (bypasses multi-monitor scaling glitches)
        DllCall("mouse_event", "UInt", 1, "Int", Round(dx), "Int", Round(dy), "UInt", 0, "UPtr", 0)
        
        ; Accelerate smoothly until top speed is reached
        if (CurrentSpeed < MaxSpeed) {
            CurrentSpeed += Acceleration
        }
        
        Sleep TickRate
    }
    
    ; Reset when keys are released
    IsMoving := false
}

; Left Click
CapsLock & Enter::
{
    SendEvent "{Blind}{LButton down}"
    KeyWait "Enter"
    SendEvent "{Blind}{LButton up}"
}


; ==============================================================================
; 5. WINDOWS & EDITOR CONTROLS
; ==============================================================================
; Standard Windows Shortcuts
CapsLock & z::Send "^z"     ; Undo
CapsLock & x::Send "^x"     ; Cut
CapsLock & c::Send "^c"     ; Copy
CapsLock & v::Send "^v"     ; Paste
CapsLock & a::Send "^a"     ; Select All
CapsLock & y::Send "^y"     ; Redo (RESTORED)
CapsLock & s::Send "^{Tab}" ; Switch Tab

; Smart Close (RESTORED)
; If Alt is held: Alt+F4 (Close Window). Else: Ctrl+W (Close Tab)
CapsLock & q::
{
    if GetKeyState("Alt")
        Send "!{F4}"
    else
        Send "^w"
}

CapsLock & g::Send "{AppsKey}" ; Context Menu

; RESTORED Dictionary/Find Shortcuts
;CapsLock & d::Send "!d" ; Alt+D (Often selects address bar)
;CapsLock & f::Send "!f" ; Alt+F (File menu or Find)

; ==============================================================================
; 6. MEDIA CONTROLS
; ==============================================================================
;CapsLock & F1::Send "{Volume_Mute}"
;CapsLock & F2::Send "{Volume_Down}"
;CapsLock & F3::Send "{Volume_Up}"
;CapsLock & F4::Send "{Media_Play_Pause}"
;CapsLock & F5::Send "{Media_Next}"
;CapsLock & F6::Send "{Media_Stop}"

; ==============================================================================
; 7. APP LAUNCHERS (CUSTOM) todo 
; ==============================================================================
;CapsLock & e::Run "https://www.google.com"  
;CapsLock & r::Run "C:\Users\thoma\AppData\Roaming\Microsoft\Windows\Start Menu\Ubuntu.lnk"
;CapsLock & t::Run "notepad.exe"

; ==============================================================================
; 8. DEVELOPER / VISUAL STUDIO MAPPINGS (RESTORED)
; ==============================================================================
; These keys were originally designed for Visual Studio debugging and navigation.
; Symbols
;CapsLock & '::Send "="
;CapsLock & `;::Send "{Enter}"

; Navigation & Comments (RESTORED from original script)
;CapsLock & [::Send "^-"     ; Navigate Backward
;CapsLock & ]::Send "{F12}"  ; Go to Definition
;CapsLock & /::              ; Comment Selection (Ctrl+E, C)
;{
;    Send "^e"
;    Send "c"
;}
;CapsLock & \::              ; Uncomment Selection (Ctrl+E, U)
;{
;    Send "^e"
;    Send "u"
;}

; Debugging Keys (RESTORED from original script)
;CapsLock & 1::Send "^{F5}"  ; Run without Debugging
;CapsLock & 2::Send "{F5}"   ; Start Debugging
;CapsLock & 3::Send "{F10}"  ; Step Over
;CapsLock & 4::Send "{F11}"  ; Step Into
;CapsLock & 5::Send "+{F5}"  ; Stop Debugging

; Number Row Shifting (Symbols)
;CapsLock & 6::Send "^"
;CapsLock & 7::Send "&"
;CapsLock & 8::Send "*"
;CapsLock & 9::Send "("
;CapsLock & 0::Send ")"
