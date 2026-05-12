#Requires AutoHotkey v2.0
#SingleInstance Force

; ==============================================================================
; 🚦 SMART BOOT WAIT (With 30-Second Timeout)
; ==============================================================================
; todo - this is Gemini's 15th solution to the problem of auto startup
; Wait for the Windows Desktop process to exist (max 30 seconds)
ProcessWait("explorer.exe", 30)

; Wait for the Taskbar to render (max 30 seconds)
WinWait("ahk_class Shell_TrayWnd", , 30)

; Check if the script is running as admin
if not A_IsAdmin
{
    ; If not, relaunch the script with the '*RunAs' verb (requests Admin)
    Run '*RunAs "' A_ScriptFullPath '"'
    ExitApp ; Close the non-admin instance
}

; --- The rest of your script goes below ---
SetTitleMatchMode 2
SendMode "Input"

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
; 2. CAPSLOCK SHORTCUTS: GLOBAL
; ==============================================================================
; {Blind} allows you to hold Shift/Ctrl/Alt physically while pressing these keys.
; Example: Shift + CapsLock + h will highlight text to the left.

CapsLock & h::Send "{Blind}{Left}"
CapsLock & j::Send "{Blind}{Down}"
CapsLock & k::Send "{Blind}{Up}"
CapsLock & l::Send "{Blind}{Right}"

CapsLock & w::Send "{Blind}^{Right}" ; Move forward by word
CapsLock & b::Send "{Blind}^{Left}"  ; Move backward by word

CapsLock & i::Send "{Blind}{Home}"
CapsLock & o::Send "{Blind}{End}"
CapsLock & u::Send "{Blind}{PgUp}"
CapsLock & p::Send "{Blind}{PgDn}"

CapsLock & ,::Send "{Del}"       ; Forward Delete
CapsLock & .::Send "^{Del}"      ; Delete Word Forward
CapsLock & m::Send "{BS}"        ; Backspace
CapsLock & n::Send "^{BS}"       ; Backspace Word

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

; ==============================================================================
; 2. CAPSLOCK SHORTCUTS: APP SPECIFIC
; ==============================================================================

; 2.1.  Notion:
; ==============================================================================

#HotIf WinActive("ahk_exe Notion.exe")

:X:/synb::
CapsLock & s::
{
    SendInput "/synced"
    Sleep 100
    SendInput "{Enter}"
    Sleep 500 
    SendInput "!+l"
    
    ToolTip "🔗 Synced Block Created & Link Copied!"
    SetTimer () => ToolTip(), -2000 
}

; proof of concept:  ? to open keyboard shortcut reference
CapsLock & ?::Send "^!/"     ; Undo

; create reminder - defaults to tomorrow at 7am
CapsLock & r::
{
    SendInput "@remind tomorrow 7am"
    Sleep 100
    SendInput "{Enter}" 
}

Ctrl & Space::Send "^p" ; command palette like Obsidian
^+d::Send "^+l" ; dark mode like vivaldi
CapsLock & Left::Send "^\"  ; left sidebar toggle
CapsLock & Right::Send "^+\"  ; right sidebar toggle

#HotIf ; Reset context sensitivity

; 2.2.  Notion Calendar:
; ==============================================================================
#HotIf WinActive("ahk_exe Notion Calendar.exe")

CapsLock & Left::Send "^\"  ; left sidebar toggle
CapsLock & Right::Send "\"  ; right sidebar toggle

#HotIf ; Reset context sensitivity

; 2.3.  Obsidian:
; ==============================================================================; 
#HotIf WinActive("ahk_exe Obsidian.exe")

CapsLock & Left::Send "^!+{Left}"  ; left sidebar toggle
CapsLock & Right::Send "^!+{Right}"  ; right sidebar toggle

; create reminder - defaults to tomorrow at 7am
CapsLock & r::
{
    SendInput "@@"
    Sleep 100
    SendInput "{Right}"
    SendInput "{Enter}"
}


#HotIf ; Reset context sensitivity

; 2.4.  Bluebeam:
; ==============================================================================; 
#HotIf WinActive("ahk_exe Revu.exe")

CapsLock & Left::Send "!x"  ; tool toggle
CapsLock & Right::Send "!p"  ; right sidebar toggle
CapsLock & Down::Send "!l"  ; markups list toggle
CapsLock & Up::Send "^!+{Up}"  ; all panels toggle

#HotIf ; Reset context sensitivity


; 2.5.  Vivaldi:
; ==============================================================================
#HotIf WinActive("ahk_exe vivaldi.exe")

CapsLock & Left::Send "^t"  ; tab bar toggle
CapsLock & Right::Send "{F4}"  ; panel toggle
CapsLock & Down::Send "!l"  ; markups list toggle
CapsLock & Up::Send "^!+{Up}"  ; all panels toggle

#HotIf ; Reset context sensitivity