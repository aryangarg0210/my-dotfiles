#!/usr/bin/env bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# nmtui connect with a catppuccin-mocha-inspired dark theme via NEWT_COLORS

export NEWT_COLORS='
root=black,black
border=cyan,black
window=white,black
shadow=black,black
title=cyan,black
button=black,cyan
actbutton=black,white
checkbox=white,black
actcheckbox=black,cyan
entry=white,black
label=cyan,black
listbox=white,black
actlistbox=black,magenta
textbox=white,black
acttextbox=white,black
helpline=black,cyan
roottext=white,black
emptyscale=black,black
fullscale=cyan,black
disentry=black,black
compactbutton=white,black
actsellistbox=black,cyan
sellistbox=magenta,black
'

nmtui connect
