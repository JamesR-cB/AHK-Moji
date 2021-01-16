;Moji - Custom Emoji Injector
;JamesR
;Version 1.0 
;Last Modified 1.16.2021

return

;~~~~~~~~~~~~~~~~~~~~~
;Emoji binds!!!!!
;~~~~~~~~~~~~~~~~~~~~~


;Creating your own custom additions is easy! Use the below as a template.

;This is specifically for slash commands, you can absolutely set your own keybinds here.
;if you type /jamesFFS the script will replace the "/jamesFFS" with the emoji you specify.

;:*:/jamesFFS::

;A_ScriptDir is imporant, that's the location of the main script, so you don't hardcode file paths that only work on your PC.
;Gdip_SetImagetoClipboard( A_ScriptDir . "\assets\jamesFFS.png" )

;Images need to follow the guidelines for Twitch "small" emoji's, in other words PNG's with transparency at 28x28.
;The library can support any resolution and filetype, but non transparent images will have borders and that looks bad in the chat program, as well as the larger emojis.
;Could probably get away with 48x48 or 64x64 but I can't imagine anything larger than that would look good in your chats.

;BUGFIX - will improve in future versions (hopefully)
;This is what actually sends the emoji. if you send %Clipboard% nothing happens, probably because AHK expects text from the clipboard, and it doesn't exist
;send {Ctrl Down}v{Ctrl Up} 

;Every thread has to end with return, which terminates the thread. If you don't, it will run the next lines of code until it hits a return.
;return

;~~~~~~~~~~~~~~~~~~~~~
;Stock Emoji
;~~~~~~~~~~~~~~~~~~~~~

:*:/jamesFFS::

Gdip_SetImagetoClipboard( A_ScriptDir . "\assets\jamesFFS.png" )
send {Ctrl Down}v{Ctrl Up}
return

:*:/LUL::
Gdip_SetImagetoClipboard( A_ScriptDir . "\assets\LUL.png" )
send {Ctrl Down}v{Ctrl Up}
return

:*:/SugaNotLikeThis::
Gdip_SetImagetoClipboard( A_ScriptDir . "\assets\SugaNotLikeThis.png" )
send {Ctrl Down}v{Ctrl Up}
return

;~~~~~~~~~~~~~~~~~~~~~
;Custom Emojis
;~~~~~~~~~~~~~~~~~~~~~


;your emojis here, see above for documentation.