#!/bin/bash
cd $(dirname $0)
ScriptPfad="$PWD"
cd "$ScriptPfad"
titel="Installer für Bild veränderung"
gnome-terminal --title="$titel" -- bash -c "./inst_cmd.sh; bash"
exit
