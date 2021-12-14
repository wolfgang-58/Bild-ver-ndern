#!/bin/bash
cd $(dirname $0)
ScriptPfad="$PWD"
cd "$ScriptPfad"
DeskTop="$XDG_SESSION_DESKTOP"
case $DeskTop in
 cinnamon)
 titel="Installer für Bild veränderung"
 gnome-terminal --title="$titel" -- bash -c "./inst_cmd.sh; bash"
 exit
;;
 mate)
 titel="Installer für Bild veränderung"
 mate-terminal --title="$titel" -- bash -c "./inst_cmd.sh; bash"
 exit
;;
 xfce)
 xfce4-terminal --command=./inst_cmd.sh
 exit
;;
esac



