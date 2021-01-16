;Moji - Custom Emoji Injector
;JamesR
;Last Modified 1.12.2021

;Ctrl+NumpadMinus for a changelog like usual.


#SingleInstance force ;One script instance allowed at a time
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

;debugMode lets you set what level of debugging you need. This script doesn't really use anything other than level 4 and level 0, so the others are stripped out.
global debugMode = 4 ; 0, 4


checkForDebug() ;initialize debug checking and check current level. onScriptLoad calls stuff here, so this has to be first
onScriptLoad() ;onScriptLoad is your main() so put most stuff here for organization.


#include %A_ScriptDir%\lib\gdip_all.ahk ;I really wanted to not use a library for this, but this is apparently the only way to copy the actual image itself
#include %A_ScriptDir%\emojis.ahk ;Custom user definitions for emoji


return

;~~~~~~~~~~~~~~~~~~~~~~~
;Script main() thread!
;~~~~~~~~~~~~~~~~~~~~~~~

onScriptLoad()
{
	;initializes strings for [INFO] and [ERROR] logs, as well as the path to the emoji asset
	logInfoString=" "
	logErrorString=" "
	imagePath=" "
	
	;Other functions to call to initialize stuff in a neat and tidy way
	setChangelog()
	doesLogFileExist() ;checks if the logs are present, if not creates a new file.
	logAddBootSuccessful() ;adds to log that application didn't have a stroke when loading
	
;debug check needs to be the last thing here else threads break due to weird
	
	if (debugMode = 4)
	{
		MsgBox, , debugMode = 4, Script load finished and entering idle
		return
	}
	
	;Function to call when the script is terminated.
	OnExit("OnScriptExit")
	
	return
}

checkForDebug()
{
	if (debugMode = 4)
	{
		MsgBox, checkForDebug called, level 4 - Development mode set. There be dragons.
		logAddInfo("Debug variable set to 4 - script running in development mode.")
		logAddInfo("Dev mode for this script is currently identical to release. Recommend you change debugMode to 0 for less visual debugging interruptions.")
		return
	}
	if (debugMode = 0)
	{
		;MsgBox, This is running in release mode.
		logAddInfo("Debug variable set to 4 - script running in release mode.")
		return
	}
	else
	{
		MsgBox, debugMode is out of range or unitialized, please fix the script.
		logAddError("debugMode is out of range or unitialized, please fix the script.")
		OnScriptExit()
		return
	}
	return
}


;~~~~~~~~~~~~~~~~~~~~~~~
;Function keys!
;~~~~~~~~~~~~~~~~~~~~~~~

;debug and utility

!M::
mouseCoordDebug()
return

!N::
clipboardDebug()
return

Pause::
reloadScript()
return

F12::
logAddInfo("info string test, f12 pressed")
return

F11::
logAddError("error string test, f11 pressed")
return

F10::
logAddError("application kill requested, f10 pressed")
debugKillApp()
return

F9::
clipboardDebug()
return

;F8::
;mojiExampleDebug()
;return

;~~~~~~~~~~~~~~~~~~~~~
;Script Utility Functions!
;~~~~~~~~~~~~~~~~~~~~~

;Reload AutoHotKey
;-----------------

reloadScript()
{
	Sleep, 25
	ToolTip Script reload engaged.
	logAddInfo("Script reload was requested by user via reloadScript()")
	Sleep, 825
	Reload
	Sleep 1000 ; If successful, the reload will close this instance during the Sleep, so the line below will never be reached.
	MsgBox, A modification has caused the script reload to fail. Please fix the script. Terminating.
	logAddError("script modified poorly - code reload failed. Please fix the script. Terminating.")
	return
}

;Exit AutoHotKey
;-----------------

debugKillApp()
{
	logAddError("debugKillApp() called, terminating.")
	logAddClose()
	Run,%ComSpec% /c Taskkill -f -im autohotkey.exe,%A_ScriptDir%,Hide
	return
}

;Alt+N - clipboard debug
clipboardDebug()
{
	logAddInfo("clipboardDebug() called, displaying most recent clipboard data.")
	MsgBox, %Clipboard%
	Sleep 1000
	return
}

clipboardPasteDebug()
{
	logAddInfo("clipboardPasteDebug() called, injecting manual paste command.")
	send {Ctrl Down}v{Ctrl Up}
	return
}

;~~~~~~~~~~~~~~~~~~~~~~~
;Do Functions!
;~~~~~~~~~~~~~~~~~~~~~~~


;Check if log exists in current working directory, if not create it.
doesLogFileExist()
{
	
	if FileExist("log.txt")
	{
		if (debugMode = 4)
		{
			logAddInfo("succesfully found existing log.")
			ToolTip debugMode = 4 existing log found
			sleep 1000
			ToolTip
		}
	}
	
	if !FileExist("log.txt")
	{
		if (debugMode = 4)
		{
			ToolTip debugMode = 4 no log found so creating new
			sleep 1000
			ToolTip
		}
		
		
		;FormatTime, currentTime, A_now, d-MMM-yyyy hh:mm:ss tt
		;FileAppend,
		;(
		;%currentTime% [INFO] Log file does not exist, creating new log. `n
		;), %A_WorkingDir%\log.txt
		
		logAddInfo("Log file does not exist, creating new log.")
	}
	
	return
}

;Log application startup.
logAddBootSuccessful()
{
	FormatTime, currentTime, A_now, d-MMM-yyyy hh:mm:ss tt
	FileAppend,
		(
		%currentTime% [INFO] Application boot successful. `n
		), %A_WorkingDir%\log.txt 
	return
}

;Log an application error (I want this to be similar to how ProjectContingency logs)
logAddError(logErrorString="")
{
	FormatTime, currentTime, A_now, d-MMM-yyyy hh:mm:ss tt
	FileAppend,
		(
		%currentTime% [ERROR] %logErrorString% `n
		), %A_WorkingDir%\log.txt
	return
}

;Log app close
logAddClose()
{
	FormatTime, currentTime, A_now, d-MMM-yyyy hh:mm:ss tt
	FileAppend,
		(
		%currentTime% [INFO] Application close requested. `n
		), %A_WorkingDir%\log.txt
	return
}

;Log app info. Can pass string to it via logAddInfo("this is a string")
logAddInfo(logInfoString="")
{
	FormatTime, currentTime, A_now, d-MMM-yyyy hh:mm:ss tt
	FileAppend,
		(
		%currentTime% [INFO] %logInfoString% `n
		), %A_WorkingDir%\log.txt
	return
}

;Alt+M - mouse coord for debug
mouseCoordDebug()
{
MouseGetPos, xpos, ypos 
MsgBox, Mouse cursor coords - X: %xpos% Y: %ypos%.
logAddInfo("mouseCoordDebug() called, coordinates are:")
logAddInfo("X: " . xpos)
logAddInfo("Y: " . ypos)
}

;GDI+ - loads jpg or png from file path, copies the actual image to clipboard, not a references
Gdip_SetImagetoClipboard( pImage )
{
	logAddInfo( "Emoji send requested, asset path is " . pImage )
	PToken := Gdip_Startup()
	pBitmap := Gdip_CreateBitmapFromFile(pImage)
	Gdip_SetBitmaptoClipboard(pBitmap)
	Gdip_DisposeImage( pBitmap )
	Gdip_Shutdown( PToken)
	logAddInfo( "Emoji send successful." )
}


;going to move these to GUIs at some point but lazy

;Ctrl+NumpadMinus - Changelog infobox
<^NumpadSub::
msgBox, 0, Changelog, %changelogText%`n%changelogText1%`n%changelogText2%`n%changelogText3%`n%changelogText4%`n%changelogText5%`n%changelogText6%`n%changelogText7%`n%changelogText8%`n%changelogText9%`n%changelogText10%`n%changelogText11%`n%changelogText12%`n%changelogText13%`n%changelogText14%`n%changelogText15%`n%changelogText16%`n%changelogText17%`n%changelogText18%`n%changelogText19%`n%changelogText20%`n%changelogText21%`n%changelogText22%`n%changelogText23%`n%changelogText24%`n%changelogText25%`n
return

;Ctrl+NumpadPlus - List of Macros
;removed in Moji, no point, plus would be better handled by the library editor I want to make. 
;~~~~~~~~~~~~~~~~~~~~~~~~~


;~~~~~~~~~~~~~~~~~~~~
;Initializations
;~~~~~~~~~~~~~~~~~~~~



setChangelog()
{
;~~~~~~~~~~~~~~~~~~~~~~
;Changelog Text Goes Here
	global
	changelogText :="Here is a list of all the changes for this version of the script. Past updates are in changelog.txt, ask James if you didn't get one and care"
	changelogText1 :="v0.1 Prerelease - 1/12/21 - mostly boilerplate code. General framework from my daily script used for this one, lots of leftover code."
	changelogText2 :="v0.5 Prerelease - 1/14/21 - added GDI+ library. Debug and logging framework hooked into gdip.ahk."
	changelogText3 :="v0.8 Prerelease - 1/15/21 - finished debugging issues with GDI+, migrated to newer library gdip_all.ahk, hooked logging into it. Code works."
	changelogText4 :="v1.0  Release - 1/16/21 - General code cleanup, moved emojis to own file for easy additions, removed debugging, old functions. Posted to Github."
	changelogText5 :=" "
	changelogText6 :=" "
	changelogText7 :=" "
	changelogText8 :=" " 
	changelogText9 :=" "
	changelogText10 :=" "
	changelogText11 :=" "
	changelogText12 :=" "
	changelogText13 :=" "
	changelogText14 :=" "
	changelogText15 :=" "
	changelogText16 :=" "
	changelogText17 :=" "
	changelogText18 :=" "
	changelogText19 :=" "
	changelogText20 :=" "
	changelogText21 :=" "
	changelogText22 :=" "
	changelogText23 :=" "
	changelogText24 :=" "
	changelogText25 :=" "
;~~~~~~~~~~~~~~~~~~~~~~
	return
}

OnScriptExit()
{
logAddClose()
return
}