#!/bin/bash
# Starter für die Installation von -Bild verändern - ab Version 2.24 
# Startet: inst_cmd.sh
# 05.01.2022
#---------------------------------------------------------------------
cd $(dirname $0)
ScriptPfad="$PWD"
cd "$ScriptPfad"
DeskTop="$XDG_SESSION_DESKTOP"
function Hilfe
{
  echo "Wenn die Installation nicht startet wurde keine gültige"
  echo "Kombination von Desktop und Terminalprogramm gefunden"
  echo "Bitte die Installation mit folgendem Befehl starten:"
  echo  "./install.sh -simple"
  exit
}
function Fehler
{
notify-send --urgency=CRITICAL --icon=info ">Bild verändern< wichtiger Hinweis" "Kein kompatibles Terminal gefunden
Es besteht die Möglichkeit die Installation mit
>./install.sh -simple<
im Terminal zu starten"
exit
}
[ "$1" = "-h" -o "$1" = "-help" -o "$1" = "--help" -o "$1" = -?"" ] && Hilfe
case $1 in
-simple)
./inst_cmd.sh
exit
;;
*)
case $DeskTop in
 cinnamon)
 titel="Installer für Bild verändern"
 gnome-terminal --title="$titel" -- bash -c "./inst_cmd.sh; bash" 2>/dev/null || Fehler
 exit
;;
 mate)
 titel="Installer für Bild verändern"
 mate-terminal --title="$titel" -- bash -c "./inst_cmd.sh; bash" 2>/dev/null || Fehler
 exit
;;
 xfce)
 xfce4-terminal --command=./inst_cmd.sh 2>/dev/null || Fehler
 exit
;;
esac
;;
esac



