#!/bin/bash
# V2.22 Installationsscript für >>Bild verändern< als Nemo-Erweiterung vom 3.12.2021
# Dieses Script ist ab -Bild verändern- 2.22 erforderlich
# NEU 3.12.2021 Bei der Installation kann die Betriebsart ausgewählt werden "action" oder "script"
# Neu 5.12.2021 Die Breite und Höhe des Programmfensters kann eingestellt werden 
# Uberarbeitung aus V2.21 am 25.11.2021: Auslesen des GTK-Themas auskommentiert da es nicht zuverlässig funktioniert
cd $(dirname $0)
ScriptPfad="$PWD"
cd "$ScriptPfad"
clear
echo "Installationsscript für >Bild verändern ab Version 2.22< als Nemo-Erweiterung"
echo "---------------------------------------------------------"
#----------Prüfen ob alle benötigten Dateien des Scripts vorhanden sind
if [ -f "$PWD"/bildveraendern.sh ];then bvs="True";else echo "bildveraendern.sh fehlt";fi
if [ -f "$PWD"/bildveraendern.nemo_action ];then bva="True";else echo "bildveraendern.nemo_action fehlt";fi
if [ -f "$PWD"/Thema/flaechig_mint/gtk-3.0/gtk.css ];then bvt1="True";else echo "css-Thema fehlt";fi
if [ -f "$PWD"/Thema/rand_mint/gtk-3.0/gtk.css ];then bvt2="True";else echo "css-Thema fehlt";fi

if [ ! -n "$bvs" ] || [ ! -n "$bva" ] || [ ! -n "$bvt1" ] || [ ! -n "$bvt2" ]
then
read -p "Die Dateien für Bild verändern sind nicht vollständig! 
die Installation wird abgebrochen! - Weiter mit >Enter< -"
exit
killall bash inst_cmd.sh
fi
echo
#-----------Deinstallation--------
echo "Es wird gepüft ob schon eine Version installiert ist..."
read -p "Sollen erkannte Versionen deinstalliert werden?
>J(a)<empfohlen >N(ein) die Installation wird abgebrochen!" deInst
case $deInst in
    J|j)
    if [ -f "/home/$USER/.local/share/nemo/actions/"jpg-quality.sh ];then
     rm -f "/home/$USER/.local/share/nemo/actions/"jpg-quality.sh
     rm -f "/home/$USER/.local/share/nemo/actions/"jpg-quality.nemo_action
     rm -f "/home/$USER/.config/"jpg-quality.dat
     rm -f -r "/home/$USER/.themes/"jpg-quality
    fi
#-------Entfernen Action-Modus-----
    if [ -f "/home/$USER/.local/share/nemo/actions/"bildveraendern.sh ];then
     rm -f "/home/$USER/.local/share/nemo/actions/"bildveraendern.sh
     rm -f "/home/$USER/.local/share/nemo/actions/"bildveraendern.nemo_action
     rm -f "/home/$USER/.config/"bildveraendern.dat
     rm -f -r "/home/$USER/.themes/bildveraendern"
     rm -f "/home/$USER/.config/"bildveraendern.style
     
    fi
#---Entfernen Script-Modus-----------
   if [ -f "/home/$USER/.local/share/nemo/scripts/"bildveraendern.sh ];then
     rm -f "/home/$USER/.local/share/nemo/scripts/"bildveraendern.sh
     rm -f "/home/$USER/.config/"bildveraendern.dat
     rm -f -r "/home/$USER/.themes/bildveraendern"
     rm -f "/home/$USER/.config/"bildveraendern.style
     rm -f "/home/$USER/.icons/bv-icon.png"
   fi
#------Icons löschen----------------
rm -f "/home/$USER/.icons/bv-icon_tb.png"
rm -f "/home/$USER/.icons/bv-icon.png"
echo "Es wurden alle vorhanden Dateien von >Bild verändern< deinstalliert"
;;
    N|n)
    read -p "Die Installation wird beendet! Weiter mit >Enter<..."
    killall bash inst_cmd.sh
;;
    *)
    read -p "Die Installation wird beendet! Weiter mit >Enter<..."
    killall bash inst_cmd.sh
;;
esac

#------------Ende deinstallation----------------------
echo
read -p "Soll eine neue Version installiert werden?
>J(a)<empfohlen >N(ein) die Installation wird abgebrochen!" inst
case $inst in
    J|j)
    read -p "Die Installation wird durchgeführt! Weiter mit >Enter<..."  
;;
    N|n)
    read -p "Die Installation wird beendet! Weiter mit >Enter<..."
    killall bash inst_cmd.sh
;;
    *)
    read -p "Die Installation wird beendet! Weiter mit >Enter<..."
    killall bash inst_cmd.sh
;;
esac 
command -v nemo >/dev/null && i_nemo="OK" || i_nemo="Fehlt" 
command -v convert >/dev/null && i_convert="OK" && t1="OK!"  || i_convert="Fehlt"  t1="ImageMagick muss installiert werden: >sudo apt install imagemagick imagemagick-doc<"
command -v yad >/dev/null && i_yad="OK"&& t2="OK!" || i_yad="Fehlt"  t2="yad muss installiert werden: >sudo apt install yad<" 
command -v heif-convert >/dev/null && i_Hconvert="OK" && t3="OK!" || i_Hconvert="Fehlt"  t3="heif-convert (optional) ist nicht installiert! >sudo apt install libheif-examples<"
if [ $i_nemo = "Fehlt" ]; then 
read -p "Auf dem System ist >Nemo< nicht installiert. Die Installation wird abgebrochen!" x
killall bash inst_cmd.sh
fi
if [ $i_convert = "OK" -a $i_yad = "OK" ]
then
    echo "ImageMagick:      ""$t1"
    echo
    echo "yad:              ""$t2"
    echo
    echo "libheif-examples: ""$t3"
    echo
    echo "Die erforderlichen Programme sind installiert"
    echo "---------------------------------------------"
else  
    echo "Bitte die notwendigen Programme installieren"
    echo
    echo "ImageMagick:"         "$t1"
    echo
    echo "yad: "                "$t2"
    echo
    echo "libheif-examples: "   "$t3"
    echo    
    echo "Die erforderlichen Programme können jetzt installiert werden, hierfür wird das >sudo< Passwort benötigt..."
    read -p "Welche Installation soll durchgeführt werden:
Yad und ImageMagick     (1)
Yad und ImageMagick und
>libheif-examples       (2)
Manuelle Installation   (3)
Bitte wählen             " PrgIns
    case $PrgIns in
    1)
    sudo apt install yad imagemagick imagemagick-doc
    ;;
    2)
    sudo apt install yad imagemagick imagemagick-doc libheif-examples
    ;;
    3)
echo "Die Installation der erforderlichen Programme muss manuell durchgefürt werden:
sudo apt install yad imagemagick imagemagick-doc libheif-examples"
    killall bash inst_cmd.sh
    ;;
    *)
echo "Die Installation der erforderlichen Programme muss manuell durchgefürt werden:
sudo apt install yad imagemagick imagemagick-doc libheif-examples"
    killall bash inst_cmd.sh
    ;;
    esac
  #exit
fi
echo 
echo "Installation beginnt...."
#----------------------------------Installation der Icons----------------
mkdir -p "/home/$USER/.icons"
cp "$PWD"/Thema/icons/bv-icon.png "/home/$USER/.icons"
cp "$PWD"/Thema/icons/bv-icon_tb.png "/home/$USER/.icons"

#----------Installiertes GTK-Thema wird nicht ausgelesen---------
#$(gsettings get org.gnome.desktop.interface gtk-theme)

#Gtk3ThemeName=/tmp/$RANDOM$$ && gcc -o $Gtk3ThemeName -include stdio.h -include gtk/gtk.h -xc <(echo 'int main() {gchar *prop; gtk_init(0, 0); \
# g_object_get(gtk_settings_get_default(), "gtk-theme-name", &prop, 0); \
#return !printf("%s\n", prop);}') $(pkg-config gtk+-3.0 --cflags --libs 2>/dev/null) 2>/dev/null && Gtk3ThemeName="$($Gtk3ThemeName && rm #$Gtk3ThemeName)" \
#|| unset Gtk3ThemeName

#InsStyle="$Gtk3ThemeName"
#if [ -z $InsStyle ];then InsStyle="GtK-Thema konnte nicht ermittelt werden.";fi 
#echo -e "Das installierte GTK-Thema ist:" "\033[31m\033[1m"$InsStyle"\033[0m"


read -p "Welcher Style soll installiert werden 
-flächig Mintfarben                      (1)
-Umrandung Mintfarben                    (2) 
-Installiertes GTK-Thema (Vorgabe)       (3) 
Bitte den Style wählen >Enter< (Vorgabe): " style
conf="/home/$USER/.config/bildveraendern.style"
case $style in
1)
mkdir -p /home/$USER/.themes/bildveraendern/gtk-3.0
cp "$PWD"/Thema/flaechig_mint/gtk-3.0/gtk.css /home/$USER/.themes/bildveraendern/gtk-3.0
InsStyle="bildveraendern"
;;
2)
mkdir -p /home/$USER/.themes/bildveraendern/gtk-3.0
cp "$PWD"/Thema/rand_mint/gtk-3.0/gtk.css /home/$USER/.themes/bildveraendern/gtk-3.0
InsStyle="bildveraendern"
;;
3)
rm -f -r /home/$USER/.themes/bildveraendern/
rm -f /home/$USER/.config/bildveraendern.dat
InsStyle=""
;;
*)
rm -f -r /home/$USER/.themes/bildveraendern/
rm -f /home/$USER/.config/bildveraendern.dat
InsStyle=""
;;
esac
echo "---------------------Breite und Höhe anpassen--------------------"
echo "Bei einigen Themen und einer größeren Schrift kann es zu Problemen 
bei der Darstellung des Programmfensters kommen.
Dann müssen Höhe und Breite des Programmfensters angepasst werden.
Mit den Vorgabewerten:
Breite = 300
Höhe = 300
wird das kleinstmögliche Fenster dargestellt
Für eine Anpassung muss die Installation erneut durchgeführt werden!"
echo
read -p "Sollen die Breite und die Höhe des Programmfensters angepasst werden
>J(a)< 
>Enter< Vorgabewerte (Breite=300; Höhe=300)?" bh
typeset -i breite
typeset -i hoehe
case $bh in
J|j)
read -p "Bitte den Wert für die Breite eingeben Vorgabe (300):" breite
read -p "Bitte den Wert für die Höhe eingeben Vorgabe (300):" hoehe

if [ -z $breite ];then
breite=300
echo "Breite auf Vorgabe (300) gesetzt!"
fi

if [ -z $hoehe ];then 
hoehe=300
echo "Höhe auf Vorgabe (300) gesetzt!"
fi

if [ $breite = 0 ];then
breite=300
echo "Breite auf Vorgabe (300) gesetzt!"
fi

if [ $hoehe = 0 ];then
hoehe=300
echo "Höhe auf Vorgabe (300) gesetzt!"
fi
read -p "Die Breite wurde auf "$breite" und die Höhe auf "$hoehe" gesetzt. 
weiter mit >Enter<" x
;;
*)
breite=300
hoehe=300
;;esac
echo
echo "------------------------------------------------------------------------"
read -p "Grundsätzlich kann -Bild veändern- in zwei Betriebsarten ausgeführt werden.
Dies ist zum einen die Betriebsart -action- und 
zum anderen die Betriebsart -script-.
Bei der Betriebsart -action- steht -Bild verändern- im Kontextmenü unmittelbar 
zu Verfügung. 
Bei der Betriebsart -script- muss -Bild verändern- über den 
Kontexmenüpunkt -Scripte- aufgerufen werden.
Welche Betriebsart soll installiert werden
Betriebsart -action-(Vorgabe)                (1)
Betriebsart -script-                         (2)
Bitte die Betriebsart wählen >Enter< Vorgabe  " betart
case  $betart in
1)
echo "------------------------------------------------------------------------"
echo "Nun werden die Scripte in das Nemo-Action-Verzeichnis kopiert"
read -p "Weiter mit Enter"
cp bildveraendern.nemo_action bildveraendern.sh /home/$USER/.local/share/nemo/actions
echo "action" "$breite" "$hoehe" "$InsStyle" > "$conf"
echo "Die Scripte sind kopiert"
echo "Die Betriebsart -action- wurde gewählt"
echo "- Viel Spaß -"
read -p "Die Installation ist abgeschlossen - Weiter mit Enter -"
;;
2)
echo "------------------------------------------------------------------------"
echo "Nun werden die Scripte in das Nemo-Script-Verzeichnis kopiert"
read -p "Weiter mit Enter"
cp bildveraendern.sh /home/$USER/.local/share/nemo/scripts
echo "script" "$breite" "$hoehe" "$InsStyle" > "$conf"
echo "Die Scripte sind kopiert"
echo "Die Betriebsart -script- wurde gewählt"
echo "- Viel Spaß -"
read -p "Die Installation ist abgeschlossen - Weiter mit Enter -"
;;

*)
echo "------------------------------------------------------------------------"
echo "Nun werden die Scripte in das Nemo-Action-Verzeichnis kopiert"
read -p "Weiter mit Enter"
echo "action" "$breite" "$hoehe" "$InsStyle" > "$conf"
cp bildveraendern.nemo_action bildveraendern.sh /home/$USER/.local/share/nemo/actions
echo "Die Scripte sind kopiert"
echo "Die Betriebsart -action- wurde gewählt"
echo "- Viel Spaß-"
read -p "Die Installation ist abgeschlossen - Weiter mit Enter -"
;;
esac
killall bash inst_cmd.sh

