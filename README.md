# AHK-Moji
An autohotkey script that injects custom emoji's into Teams chats.

Emoji's are located in the /assets/ directory, and the images should match Twitch guidelinies for small, non-Retina thumbnails. In other words, PNG's with transparent backgrounds that are 28x28 is recommended. Twitch has a template guideline you can use, and you can of couse download the Twitch emotes from the site. The library can actually (from what I can tell) accept any image I throw at it, but over a certain size it looks really bad in the chat. 48x48 or 64x64 is probably the upper limit of what you'd want to use before it makes the chat look bad/hard to read. I do plan on adding an image import wizard at some point, that will format images for you and add them to the script for you, but for now they need to be prepared before using them here for optimal results.

This script was written and designed around how Microsoft Teams handles pasting images into it's chat window. This script does actually work elsewhere, for example Discord. However some chat programs will filter images, so you may see it for a frame before it gets removed by the program, or it might get filtered and removed when sent off. Using Dicord as an example again, they trigger the file upload dialog when you inject the emoji, rather than keeping the emoji inline with your text, which makes it less useful there. Using this in Teams is roughly equivalent to using the :jamesFFS: style in Discord, so go into it with that expectation and it makes it easier to account for when used.

# Adding your own Emoji
Creating your own custom additions is easy! Use the below breakdown as a template.

This is specifically for slash commands, you can absolutely set your own keybinds here. In this example, if you type /jamesFFS the script will replace the "/jamesFFS" with the emoji you specify.
```
:*:/jamesFFS::
```
A_ScriptDir is imporant, that's the location of the main script, so you don't hardcode file paths that only work on your PC. Pass the location of the PNG to the function using A_ScriptDir (note, this means you could absolutely create your own organization scheme for the emojis as long as you enter the path correctly in the script.)
```
Gdip_SetImagetoClipboard( A_ScriptDir . "\assets\jamesFFS.png" )
```
Images need to follow the guidelines for Twitch "small" emoji's, in other words PNG's with transparency at 28x28.
The library can support any resolution and filetype, but non transparent images will have borders and that looks bad in the chat program, as well as the larger emojis.
Could probably get away with 48x48 or 64x64 but I can't imagine anything larger than that would look good in your chats.

For now, we need to manually send a Ctrl+V event to send the emoji to work around a bug with how the GDI+ library edits/adds to the %Clipboard% variable.This is what actually sends the emoji. if you send %Clipboard% nothing happens, probably because AHK expects text from the clipboard, and it doesn't exist as it's a raw PNG.
```
send {Ctrl Down}v{Ctrl Up} 
```
Every thread has to end with return, which terminates the thread. If you don't, it will run the next lines of code until it hits a return.
```
return
```

Our final product looks like this:

```
:*:/jamesFFS::
Gdip_SetImagetoClipboard( A_ScriptDir . "\assets\jamesFFS.png" )
send {Ctrl Down}v{Ctrl Up}
return
```
And we have our emojis! 


TLDR: Edit emojis.ahk and call the function Gdip_SetImageToClipboard with the path to the file, and manually send a Ctrl+V event.

Check out https://jamesr-cb.github.io for documentation on all of the specific functions in this script. This is a WIP and may be incomplete, as that documentation is going to be the under the hood stuff, not "how to use the script" documentation so I might get a bit lazy with updating the site.