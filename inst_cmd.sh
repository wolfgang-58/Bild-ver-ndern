#!/bin/bash
#V2.21 Installationsscript für >>Bild verändern< als Nemo-Erweiterung vom 22.11.2021 
# Uberarbeitet am 25.11.2021: Auslesen des GTK-Themas auskommentiert da es nicht zuverlässig funktioniert
cd $(dirname $0)
ScriptPfad="$PWD"
cd "$ScriptPfad"
clear
echo "Installalationsscript für >Bild verändern ab Version 2.21< als Nemo-Erweiterung"
echo "---------------------------------------------------------"
#----------Prüfen ob alle benotigten Dateien des Scripts vorhanden sind
if [ -f "$PWD"/bildveraendern.sh ];then bvs="True";else echo "bildveraendern.sh fehlt";fi
if [ -f "$PWD"/bildveraendern.nemo_action ];then bva="True";else echo "bildveraendern.nemo_action fehlt";fi
if [ -f "$PWD"/Thema/flaechig_mint/gtk-3.0/gtk.css ];then bvt1="True";else echo "css-Thema fehlt";fi
if [ -f "$PWD"/Thema/rand_mint/gtk-3.0/gtk.css ];then bvt2="True";else echo "css-Thema fehlt";fi

if [ ! -n "$bvs" ] || [ ! -n "$bva" ] || [ ! -n "$bvt1" ] || [ ! -n "$bvt2" ]
then
read -p "Die Dateien für Bild verändern sind nicht vollstandig! 
die Installation wird abgebrochen! - Weiter mit >Enter< -"
exit
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
#-------bildverändern-----
    if [ -f "/home/$USER/.local/share/nemo/actions/"bildveraendern.sh ];then
     rm -f "/home/$USER/.local/share/nemo/actions/"bildveraendern.sh
     rm -f "/home/$USER/.local/share/nemo/actions/"bildveraendern.nemo_action
     rm -f "/home/$USER/.config/"bildveraendern.dat
     rm -f -r "/home/$USER/.themes/bildveraendern"
     rm -f "/home/$USER/.config/"bildveraendern.style
    fi
echo "Es wurden alle vorhanden Dateien von >Bild verändern< deinstalliert"
;;
    N|n)
    read -p "Die Installation wird beendet! Weiter mit >Enter<..."
    exit
;;
    *)
    read -p "Die Installation wird beendet! Weiter mit >Enter<..."
    exit
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
    exit
;;
    *)
    read -p "Die Installation wird beendet! Weiter mit >Enter<..."
    exit
;;
esac 
command -v nemo >/dev/null && i_nemo="OK" || i_nemo="Fehlt" 
command -v convert >/dev/null && i_convert="OK" && t1="OK!"  || i_convert="Fehlt"  t1="ImageMagick muss installiert werden: >sudo apt install imagemagick imagemagick-doc<"
command -v yad >/dev/null && i_yad="OK"&& t2="OK!" || i_yad="Fehlt"  t2="yad muss installiert werden: >sudo apt install yad<" 
command -v heif-convert >/dev/null && i_Hconvert="OK" && t3="OK!" || i_Hconvert="Fehlt"  t3="heif-convert (optional) ist nicht installiert! >sudo apt install libheif-examples<"
if [ $i_nemo = "Fehlt" ]; then 
read -p "Auf dem System ist >Nemo< nicht installiert. Die Installation wird abgebrochen!" x
exit;fi
if [ $i_convert = "OK" -a $i_yad = "OK" ]
then
    echo "ImageMagick:      ""$t1"
    echo
    echo "yad:              ""$t2"
    echo
    echo "libheif-examples: ""$t3"
    echo
    echo "Die erfoderlichen Programme sind installiert"
    echo "---------------------------------------------"
else  
    echo "Bitte die notwendigen Programme installiern"
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
    exit
    ;;
    *)
echo "Die Installation der erforderlichen Programme muss manuell durchgefürt werden:
sudo apt install yad imagemagick imagemagick-doc libheif-examples"
    exit
    ;;
    esac
  #exit
fi
echo 
echo "Installation beginnt...."
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
-flächig Mintfarben         (1)
-Umrandung Mintfarben       (2) 
-Installiertes GTK-Thema    (3) 
Bitte den Style wählen:      " style
conf="/home/$USER/.config/bildveraendern.style"
case $style in
1)
mkdir -p /home/$USER/.themes/bildveraendern/gtk-3.0
cp "$PWD"/Thema/flaechig_mint/gtk-3.0/gtk.css /home/$USER/.themes/bildveraendern/gtk-3.0
echo "bildveraendern" > "$conf"
;;
2)
mkdir -p /home/$USER/.themes/bildveraendern/gtk-3.0
cp "$PWD"/Thema/rand_mint/gtk-3.0/gtk.css /home/$USER/.themes/bildveraendern/gtk-3.0
echo "bildveraendern" > "$conf"
;;
3)
rm -f -r /home/$USER/.themes/bildveraendern/
rm -f /home/$USER/.config/bildveraendern.dat
InsStyle=""
echo "$InsStyle" > "$conf"
;;
*)
read -p "Es wurde kein Style ausgewählt. Die Installation wird abgebrochen. Weiter mit Enter..."
exit
;;
esac
echo "------------------------------------------------------------------------"
echo "Nun werden die Scripte in das Nemo-Action-Verzeichnis kopiert"
read -p "Weiter mit Enter"
cp bildveraendern.nemo_action bildveraendern.sh /home/$USER/.local/share/nemo/actions
echo "Die Scripte sind kopiert"
echo "- Viel Spass -"
read -p "Die Installation ist abgeschlossen - Weiter mit Enter -"
exit
