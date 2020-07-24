#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #InstallKeybdHook
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
#include Lib/kbdled.ahk
SetTitleMatchMode 1


GroupAdd, exclusion, ahk_class RiotWindowClass
GroupAdd, exclusion, ahk_class mintty

#IfWinActive ahk_class mintty
CapsLock::
; 	; Input key, I L1 E
; 	; if (GetKeyState("CapsLock", "P") && %key% != "CapsLock")
; 	;    Send {Blind}{F13}%key%
	Send {F13}
	return

#IfWinActive emacs
ESC::^g


#IfWinNotActive ahk_group exclusion

markset = false
forward = true
; SetStoreCapsLockMode, [O]Off
OnWinActiveChange(hWinEventHook, vEvent, hWnd)
{
	global markset
	global forward
	static _ := DllCall("user32\SetWinEventHook", UInt,0x3, UInt,0x3, Ptr,0, Ptr,RegisterCallback("OnWinActiveChange"), UInt,0, UInt,0, UInt,0, Ptr)
	; DetectHiddenWindows, On
	markset := false
	; SetCapsLockState off
	KeyboardLED(4, "off", 0)
	forward := true
}

emacs()
{
	global markset
	global forward
	if markset
	   if forward
	      send {Right}
	   else
	      send {Left}
	markset := ! markset
	; SetCapsLockState % markset
	KeyboardLED(4, markset ? "on" : "off", 0)
	return
}


!CapsLock::CapsLock
CapsLock::
	emacs()
	return

^Space::
	emacs()
	return


+^a::
	markset := true
	Send ^{a}
	return

^a::
	forward := false
	if markset
	   Send +{Home}
	else
	   Send {Home}
	return

^e::
	forward := true	
	if markset
	   Send +{End}
	else
	   Send {End}
	return

!f::
	forward := true
	if markset
	   Send ^+{Right}
	else
	   Send ^{Right}
	return

!b::
	forward := false
	if markset
	   Send ^+{Left}
	else
	   Send ^{Left}
	return

!+.::
	forward := true
	if markset
	   Send ^+{End}
	else
	   Send ^{End}
	return
	
!+,::
	forward := false
	if markset
	   Send ^+{Home}
	else
	   Send ^{Home}
	return

^k::
	if !markset
	{
		markset	:= true
		Send +{End}
		Sleep 20

	}
	Send {Backspace}
	Gosub, Esc
	return

Left::
	forward := false
       	if markset
	   Send +{Left}
	else
	   Send {Left}
	return

Right::
	forward := True
       	if markset
	   Send +{Right}
	else
	   Send {Right}
	return

Down::
       	if markset
	   Send +{Down}
	else
	   Send {Down}
	return

Up::
       	if markset
	   Send +{Up}
	else
	   Send {Up}
	return

Esc::
	if markset
	{
		markset := false	
		; SetCapsLockState off
		KeyboardLED(4, "off", 0)	
		if forward
			send {Right}
		else
			send {Left}
	}
	else
		Send {Esc}
	return

^w::
	Send ^{x}
	Gosub, Esc
	return

!w::
	Send ^{c}
	Gosub, Esc
	return

^y::^v

!Backspace::
	Send ^{Backspace}
	return

^!k::
	if WinActive("Slack")
		WinClose
	else
		Run "C:\Users\mshua\AppData\Local\slack\slack.exe"
return