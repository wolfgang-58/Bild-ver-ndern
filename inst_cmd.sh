#!/bin/bash
# V2.24 Installationsscript für >>Bild verändern< als Erweiterung für -Nemo, Caja, Nautilus, Thunar vom 25.12.2021
# Dieses Script ist ab -Bild verändern- 2.24 erforderlich
# NEU 3.12.2021 Bei der Installation kann die Betriebsart ausgewählt werden "action" oder "script"
# Neu 5.12.2021 Die Breite und Höhe des Programmfensters kann eingestellt werden 
# Uberarbeitung aus V2.21 am 25.11.2021: Auslesen des GTK-Themas auskommentiert da es nicht zuverlässig funktioniert
# NEU 11.12.2021 Unterstützung für -Caja, Nautilus und Thunar- hinzugefügt
# 23.12.2021 Überarbeitung und Ergänzung der Installationsroutine für die externen Programme
# 25.12.2021 Programmstartposition hinzugefügt
cd $(dirname $0)
ScriptPfad="$PWD"
cd "$ScriptPfad"
clear
#echo -e "\033[1mInstallation für -Bild verändern- ab Version 2.24\033[0m"
#echo "---------------------------------------------------------"
#----------Prüfen ob alle benötigten Dateien des Scripts vorhanden sind
if [ -f "$PWD"/bildveraendern.sh ];then bvs="True";else echo "bildveraendern.sh fehlt";fi
if [ -f "$PWD"/Thema/nemo/bildveraendern.nemo_action ];then bva="True";else echo "bildveraendern.nemo_action fehlt";fi
if [ -f "$PWD"/Thema/flaechig_mint/gtk-3.0/gtk.css ];then bvt1="True";else echo "css-Thema fehlt";fi
if [ -f "$PWD"/Thema/rand_mint/gtk-3.0/gtk.css ];then bvt2="True";else echo "css-Thema fehlt";fi

if [ ! -n "$bvs" ] || [ ! -n "$bva" ] || [ ! -n "$bvt1" ] || [ ! -n "$bvt2" ]
then
read -p "Die Dateien für Bild verändern sind nicht vollständig! 
die Installation wird abgebrochen! - Weiter mit >Enter< -"
exit
killall bash inst_cmd.sh
fi
#echo
#-----------------Dateimanager auslesen festlegen------------
#dm=$(xdg-mime query default inode/directory) --Geht nicht---
while ((dm != 5)) 
do
#clear
echo -e "\033[1mInstallation für -Bild verändern- ab Version 2.24\033[0m"
echo
echo -e "\033[1m----------------Auswahl des verwendeten Dateimanagers--------------------------\033[0m"
echo "-Bild verändern- kann für verschiedene Dateimanager als Erweiterung
installiert werden."
read -p "Bitte den Dateimanager auswählen:
Nemo                                    (1)
Caja                                    (2)
Thunar                                  (3)
Nautilus                                (4)
Abbruch der Installation                (5)
Bitte den Dateimanager wählen >Enter< :  " dm

case $dm in
1)
DateiManager="nemo"
;;
2)
DateiManager="caja"
;;
3)
DateiManager="thunar"
;;
4)
DateiManager="nautilus"
;;
5)
killall bash inst_cmd.sh
;;
*)
echo "Es wurde kein Dateimanager ausgewählt"
read -p "Bitte eine Auswahl treffen! Weiter mit >Enter<..."
#killall bash inst_cmd.sh
;;
esac
command -v "$DateiManager" >/dev/null && i_DM="OK" || i_DM="Fehlt" 
if [ ! -z $dm ]; then
 if [ $i_DM = "Fehlt" ]; then 
 read -p "Auf dem System ist "$DateiManager" nicht installiert. 
Bitte einen Dateimanager auswählen!
Weiter mit >Enter<..." x
#killall bash inst_cmd.sh
 fi
if [ $i_DM = "OK" ]; then dm=5;fi 
fi
clear
done


#-----------Deinstallation--------
echo -e "\033[1m----------------Prüfen der Installation und Deinstallation------------------\033[0m"
echo
echo "Es wird geprüft ob schon eine Version installiert ist..."
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
     rm -f "/home/$USER/.config/"bildveraendern-info.txt
    fi
#---Entfernen Script-Modus-----------
case $DateiManager in
nemo)
   if [ -f "/home/$USER/.local/share/nemo/scripts/"bildveraendern.sh ];then
     rm -f "/home/$USER/.local/share/nemo/scripts/"bildveraendern.sh
     rm -f "/home/$USER/.config/"bildveraendern.dat
     rm -f -r "/home/$USER/.themes/bildveraendern"
     rm -f "/home/$USER/.config/"bildveraendern.style
     rm -f "/home/$USER/.icons/bv-icon.png"
     rm -f "/home/$USER/.config/"bildveraendern-info.txt
   fi
;;
caja)
if [ -f "/home/$USER/.config/caja/scripts/"bildveraendern.sh ];then
     rm -f "/home/$USER/.config/caja/scripts/"bildveraendern.sh
     rm -f "/home/$USER/.config/"bildveraendern.dat
     rm -f -r "/home/$USER/.themes/bildveraendern"
     rm -f "/home/$USER/.config/"bildveraendern.style
     rm -f "/home/$USER/.icons/bv-icon.png"
     rm -f "/home/$USER/.config/"bildveraendern-info.txt
   fi
;;
nautilus)
if [ -f "/home/$USER/.local/share/nautilus/scripts/"bildveraendern.sh ];then
     rm -f "/home/$USER/.local/share/nautilus/scripts/"bildveraendern.sh
     rm -f "/home/$USER/.config/"bildveraendern.dat
     rm -f -r "/home/$USER/.themes/bildveraendern"
     rm -f "/home/$USER/.config/"bildveraendern.style
     rm -f "/home/$USER/.icons/bv-icon.png"
     rm -f "/home/$USER/.config/"bildveraendern-info.txt
   fi

;;
thunar)
if [ -f "/home/$USER/.config/Thunar/scripts/"bildveraendern.sh ];then
     rm -f "/home/$USER/.config/Thunar/scripts/"bildveraendern.sh
     rm -f "/home/$USER/.config/"bildveraendern.dat
     rm -f -r "/home/$USER/.themes/bildveraendern"
     rm -f "/home/$USER/.config/"bildveraendern.style
     rm -f "/home/$USER/.icons/bv-icon.png"
     rm -f "/home/$USER/.config/"bildveraendern-info.txt
     Num1="$(grep -n "Bild verändern" /home/$USER/.config/Thunar/uca.xml | head -n 1 | cut -d: -f1)"
    if [ ! -z $Num1 ]; then 
     x=$(($Num1 -2 ))
     Num2=$(tail -n+$x /home/$USER/.config/Thunar/uca.xml | grep -n "</action>" | head -n 1 | cut -d: -f1) 
     for ((i=1;i<=$Num2;i++));do
      sed -i "$x"d /home/$USER/.config/Thunar/uca.xml
     done
     thunar --quit
    fi
fi
;;
esac

#------Icons löschen----------------
rm -f "/home/$USER/.icons/bv-icon_tb.png"
rm -f "/home/$USER/.icons/bv-icon.png"
rm -f "/home/$USER/.config/"bildveraendern-info.txt
echo "Es wurden alle vorhandenen Dateien von >Bild verändern< deinstalliert"
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
>J(a)<empfohlen >N(ein) die Installation wird beendet!" inst
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
clear
while [ true ];do
command -v convert >/dev/null && i_convert="OK" && t1="OK!"  || i_convert="Fehlt"  t1="ImageMagick muss installiert werden"
command -v yad >/dev/null && i_yad="OK"&& t2="OK!" || i_yad="Fehlt"  t2="yad muss installiert werden" 
command -v heif-convert >/dev/null && i_Hconvert="OK" && t3="OK!" || i_Hconvert="Fehlt"  t3="heif-convert (optional) kann installiert werden."
command -v img2pdf >/dev/null && i_pdf="OK"&& t4="OK!" || i_pdf="Fehlt"  t4="img2pdf muss installiert werden." 
#while [ true ];do
if [ $i_convert = "OK" -a $i_yad = "OK" -a $i_Hconvert = "OK" -a $i_pdf = "OK" ]
then
    echo -e "\033[1mInstallationsprüfung der externen Programme\033[0m" 
    echo "ImageMagick:      ""$t1"
    echo
    echo "yad:              ""$t2"
    echo
    echo "img2pdf           ""$t4"
    echo
    echo "libheif-examples: ""$t3"
    echo
    echo "Die erforderlichen Programme sind installiert"
    echo "---------------------------------------------"
else  
    echo -e "\033[1mInstallationsprüfung der externen Programme\033[0m"    
    echo "Bitte die notwendigen oder optionalen Programme installieren"
    echo
    echo "ImageMagick:"         "$t1"
    echo
    echo "yad: "                "$t2"
    echo
    echo "img2pdf:"             "$t4"
    echo
    echo "libheif-examples: "   "$t3"
    echo
    if [ $i_convert = "Fehlt" -o $i_yad = "Fehlt" -o $i_pdf = "Fehlt" ];then notwendig="FALSE";else notwendig="TRUE"; fi
    if [ $i_Hconvert = "Fehlt" ];then optional="FALSE";else optional="TRUE"; fi
    #if [ $i_convert = "Fehlt" ];then p1="ImageMagick";fi
    #if [ $i_yad = "Fehlt" ];then p2="Yad";fi
    #if [ $i_pdf = "Fehlt" ];then p3="img2pdf";fi
    echo "Die erforderlichen Programme können jetzt installiert werden,
hierfür wird das >sudo< Passwort benötigt..."
    read -p "Weiter mit >Enter< "  

#clear
echo -e "\033[1mFür die Verwendung von -Bild verändern- werden weitere
externe Programme benötigt.\033[0m"
echo
echo "Notwendig für den Betrieb:
yad (Yet Another Dialog) - Ermöglicht das Erzeugen 
                           grafischer Dialoge
ImageMagick              - Softwarepaket zur Erstellung und 
                           Bearbeitung von Rastergrafiken 
img2pdf                  - Zum erzeugen von PDF-Dateien"
echo "Optional für den Betrieb:
libheif-examples         - Zum konvertieren von Apple HEIC-Format"
if [ $notwendig = "FALSE" ];then
echo
echo -e "\033[43m  Sind die notwendigen Programme nicht installiert kann die   \033[0m"    
echo -e "\033[43m Installation von -Bild verändern- nicht durchgeführt werden! \033[0m"
echo -e "\033[43m   Mindestens 1 notwendiges Programm ist nicht installiert!   \033[0m"
else
echo
echo -e "\033[42m------------------------------------------------------------- \033[0m"
echo -e "\033[42m         Die notwendigen Programme sind installiert!          \033[0m"
echo -e "\033[42m------------------------------------------------------------- \033[0m"
fi
if [ $optional = "FALSE" ];then
echo -e "\033[43m        Das optionale Programm ist nicht installiert!         \033[0m"
fi
#echo
#echo "Optional für den Betrieb:
#libheif-examples         - Zum konvertieren von Apple HEIC-Format
#Dieses Programm ist Optional."
echo
read -p "Welche Installation soll durchgeführt werden:
Yad, ImageMagick, img2pdf und libheif-examples (Notwendig und Optional)..(1)
Yad,ImageMagick und img2pdf (Notwendig)..................................(2)
libheif-examples (Optional)..............................................(3)
Manuelle Installation (Die Installation wird abgebrochen)................(4)
Keine Auswahl (Die Installation von -Bild verändern- wird fortgesetzt)...( )
Bitte wählen weiter mit >Enter<                                           " PrgIns
    case $PrgIns in
    1)
    sudo apt install yad imagemagick imagemagick-doc libheif-examples img2pdf
    ;;
    2)
    sudo apt install yad imagemagick imagemagick-doc img2pdf
    ;;
    3)
    sudo apt install  libheif-examples
    ;;
    4)
    clear
echo "Die Installation der gewünschten Programme muss manuell durchgefürt werden:
sudo apt install yad imagemagick imagemagick-doc libheif-examples img2pdf"
    read -p "Weiter mit >Enter<" x
    killall bash inst_cmd.sh
    ;;
    *)
    #read -p "Die Installation wird fortgesetzt weiter mit >Enter<" x     
     
    ;;
    esac
fi
echo 
#-------------------------------überprüfung ob Yad und ImageMagick und img2pdf installiert sind-----------------
command -v convert >/dev/null && ic="TRUE" || ic="FALSE"
command -v yad >/dev/null && iy="TRUE" || iy="FALSE" 
command -v img2pdf >/dev/null && i_p="TRUE" || i_p="FALSE"

if [ $ic = "FALSE" -o $iy = "FALSE" -o $i_p = "FALSE" ]; then
clear
echo "Für die weitere Installation müssen alle notwendigen Programme
installiert sein."
read -p "Es sind nicht alle notwendigen Programme installiert
Bitte die notwendigen Programme installieren. Weiter mit >Enter<" x 
#killall bash inst_cmd.sh
clear
else
clear
echo -e "\033[1mDie notwendigen externen Programme sind installiert.\033[0m"
read -p "
Die Installation von -Bild verändern- beginnt....
Weiter mit >Enter<" x
break
fi
done
clear 
#----------------------------------Installation der Icons----------------
mkdir -p "/home/$USER/.icons"
cp "$PWD"/Thema/icons/bv-icon.png "/home/$USER/.icons"
cp "$PWD"/Thema/icons/bv-icon_tb.png "/home/$USER/.icons"
cp "$PWD"/Thema/bv-info/bildveraendern-info.txt "/home/$USER/.config"
#----------Installiertes GTK-Thema wird nicht ausgelesen---------
#$(gsettings get org.gnome.desktop.interface gtk-theme)

#Gtk3ThemeName=/tmp/$RANDOM$$ && gcc -o $Gtk3ThemeName -include stdio.h -include gtk/gtk.h -xc <(echo 'int main() {gchar *prop; gtk_init(0, 0); \
# g_object_get(gtk_settings_get_default(), "gtk-theme-name", &prop, 0); \
#return !printf("%s\n", prop);}') $(pkg-config gtk+-3.0 --cflags --libs 2>/dev/null) 2>/dev/null && Gtk3ThemeName="$($Gtk3ThemeName && rm #$Gtk3ThemeName)" \
#|| unset Gtk3ThemeName

#InsStyle="$Gtk3ThemeName"
#if [ -z $InsStyle ];then InsStyle="GtK-Thema konnte nicht ermittelt werden.";fi 
#echo -e "Das installierte GTK-Thema ist:" "\033[31m\033[1m"$InsStyle"\033[0m"

echo -e "\033[1m--------------------Welcher Style soll installiert werden--------------------\033[0m"
read -p " 
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
echo
echo -e "\033[1m---------------------Breite und Höhe anpassen--------------------\033[0m"
echo "Bei einigen Themen und einer größeren Schrift kann es zu Problemen 
bei der Darstellung des Programmfensters kommen.
Dann müssen Höhe und Breite des Programmfensters angepasst werden.
Mit den Vorgabewerten:
Breite = 300
Höhe = 300
wird das kleinstmögliche Fenster dargestellt"
echo
read -p "Sollen die Breite und die Höhe des Programmfensters angepasst werden
>J(a)< 
>Enter< Vorgabewerte (Breite=300; Höhe=300)?" bh
typeset -i breite
typeset -i hoehe
case $bh in
J|j)
read -p "Bitte den Wert für die Breite eingeben und mit >Enter< bestätigen:" breite
read -p "Bitte den Wert für die Höhe eingeben und mit >Enter< bestätigen:" hoehe

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
clear
#------------------------------Programm-Position------------------
echo -e "\033[1m----------Festlegen der Position bei Programmstart---------------\033[0m"
echo "Festlegen der Position des Programmfensters beim Programmstart
Wird >Bild verändern< über das Kontextmenü aufgerufen kann
hier die Position des Programmfenster festgelegt werden.
Es besteht die Möglichkeit das Programmfenster an der
Mausposition oder in der Bildschirmmitte zu platzieren"
echo
read -p "Bitte auswählen:
Position des Programmfensters an den Mausposition                     (m)ouse
Position des Programmfensters in der Bildschirmmitte                  (c)enter
Startposition wählen (Vorgabe->Mausposition) mit >Enter< bestätigen:   " pp
case $pp in
M|m)
Progpos="mouse"
;;
c|C)
Progpos="center"
;;
*)
Progpos="mouse"
;;
esac 
#------------------------------------Betriebsart---------------
if [ $DateiManager = "nemo" ];then
betartvor=1
betartname="action"
else
betartvor=2
betartname="script"
fi
while ((ActMod != 1)) 
do
clear
#echo -e "\033[43m\033[1mACHTUNG! Die Betriebsart -action- steht nur unter -Nemo- zur Verfügung!\033[0m"
echo -e "\033[1m---------------------------Festlegen der Betriebsart---------------------------\033[0m"
echo "Unter -Nemo- steht -Bild verändern- in zwei Betriebsarten zur Verfügung
Dies ist zum einen die Betriebsart -action- und zum anderen
die Betriebsart -script-.
Bei der Betriebsart -action- steht -Bild verändern- im Kontextmenü unmittelbar 
zur Verfügung. 
Bei der Betriebsart -script- muss -Bild verändern- über den 
Kontextmenüpunkt -Scripte- aufgerufen werden."
echo
#echo -e "\033[5m\033[1mACHTUNG! Die Betriebsart -action- steht nur unter -Nemo- zur Verfügung!\033[0m"
echo -e "\033[43m\033[1mACHTUNG! Die Betriebsart -action- steht nur unter -Nemo- zur Verfügung!\033[0m"
echo -e "\033[1mDie Installation erfolgt für den gewählten Dateimanager: - $DateiManager -
Die Vorgabe für die Betriebsart ist: - $betartname - \033[0m"
echo
read -p "Welche Betriebsart soll installiert werden
Betriebsart -action- Nemo                              (1)
Betriebsart -script- Nemo, Caja, Thunar, Nautilus      (2)
Bitte die Betriebsart wählen - Vorgabe [$betartname] >Enter<:" betart
betart=${betart:-$betartvor}
case  $betart in
1)
if [ $DateiManager = "nemo" ];then
echo "------------------------------------------------------------------------"
echo "Nun werden die Scripte in das Nemo-Action-Verzeichnis kopiert"
read -p "Weiter mit Enter"
cp bildveraendern.sh /home/$USER/.local/share/nemo/actions
cp "$PWD"/Thema/nemo/bildveraendern.nemo_action bildveraendern.sh /home/$USER/.local/share/nemo/actions
echo "$DateiManager" "action" "$breite" "$hoehe" "$Progpos" "$InsStyle" > "$conf"
echo "Die Scripte wurden kopiert"
echo "Die Betriebsart -action- wurde gewählt"
echo "- Viel Spaß -"
read -p "Die Installation ist abgeschlossen - Weiter mit Enter -"
ActMod=1
else
echo "Für ihren Dateimanager "$DateiManager" steht der -Action-Modus- nicht zur Verfügung"
read -p "Weiter mit >Enter< Abbruch der Installation mit >1<: " ActMod
fi
;;
2)
 case "$DateiManager" in
   nemo)
    echo "------------------------------------------------------------------------"
    echo "Nun werden die Scripte in das Nemo-Script-Verzeichnis kopiert"
    read -p "Weiter mit Enter"
    cp bildveraendern.sh /home/$USER/.local/share/nemo/scripts
    echo "$DateiManager" "script" "$breite" "$hoehe" "$Progpos" "$InsStyle" > "$conf"
    echo "Die Scripte wurden kopiert"
    echo "Die Betriebsart -script- wurde gewählt"
    echo "- Viel Spaß -"
    read -p "Die Installation ist abgeschlossen - Weiter mit Enter -"
    ActMod=1
   ;;
   caja)
    echo "------------------------------------------------------------------------"
    echo "Nun werden die Scripte in das Caja-Script-Verzeichnis kopiert"
    read -p "Weiter mit Enter"
    mkdir -p /home/$USER/.config/caja/scripts/
    cp bildveraendern.sh /home/$USER/.config/caja/scripts/
    echo "$DateiManager" "script" "$breite" "$hoehe" "$Progpos" "$InsStyle" > "$conf"
    echo "Die Scripte wurden kopiert"
    echo "Die Betriebsart -script- wurde gewählt"
    echo "- Viel Spaß -"
    read -p "Die Installation ist abgeschlossen - Weiter mit Enter -"
    ActMod=1

   ;;
   nautilus)
    echo "------------------------------------------------------------------------"
    echo "Nun werden die Scripte in das Nautilus-Script-Verzeichnis kopiert"
    read -p "Weiter mit Enter"
    cp bildveraendern.sh /home/$USER/.local/share/nautilus/scripts
    echo "$DateiManager" "script" "$breite" "$hoehe" "$Progpos" "$InsStyle" > "$conf"
    echo "Die Scripte wurden kopiert"
    echo "Die Betriebsart -script- wurde gewählt"
    echo "- Viel Spaß -"
    read -p "Die Installation ist abgeschlossen - Weiter mit Enter -"
    ActMod=1
   ;;
   thunar)
    echo "------------------------------------------------------------------------"
    echo "Nun werden die Scripte in das Thunar-Script-Verzeichnis kopiert"
    read -p "Weiter mit Enter"
    mkdir -p /home/$USER/.config/Thunar/scripts/
    cp bildveraendern.sh /home/$USER/.config/Thunar/scripts/
    echo "$DateiManager" "script" "$breite" "$hoehe" "$Progpos" "$InsStyle" > "$conf"
    #-------------Kopie der uca.xml anlegen-----------------
    if [ ! -f /home/$USER/.config/Thunar/uca.xml.org ];then
    cp /home/$USER/.config/Thunar/uca.xml /home/$USER/.config/Thunar/uca.xml.org
    fi
    #------------xfce - Action einrichten-------------
    uniid=$(date +%s%3N)
    sed "4i <unique-id>"$uniid"-1</unique-id>" "$PWD"/Thema/xfce/xfce-action.txt > "$PWD"/Thema/xfce/xfce-action1.txt
    while read line; do
        if [[ "$line" == "</actions>" ]]; then
        cat "$PWD"/Thema/xfce/xfce-action1.txt  >>/home/$USER/.config/Thunar/uca1.xml
        fi
        echo "$line" >>/home/$USER/.config/Thunar/uca1.xml
    done < /home/$USER/.config/Thunar/uca.xml
    mv /home/$USER/.config/Thunar/uca1.xml /home/$USER/.config/Thunar/uca.xml
    thunar --quit
#------------xfce - Ende Action einrichten-------------
    echo "Die Scripte wurden kopiert"
    echo "Die Betriebsart -script- wurde gewählt"
    echo "- Viel Spaß -"
    read -p "Die Installation ist abgeschlossen - Weiter mit Enter -"
    ActMod=1
   ;;
 esac
;;

*)
if [ $DateiManager = "nemo" ];then
echo "------------------------------------------------------------------------"
echo "Nun werden die Scripte in das Nemo-Action-Verzeichnis kopiert"
read -p "Weiter mit Enter"
echo "$DateiManager" "action" "$breite" "$hoehe" "$Progpos" "$InsStyle" > "$conf"
cp bildveraendern.sh /home/$USER/.local/share/nemo/actions
cp "$PWD"/Thema/nemo/bildveraendern.nemo_action bildveraendern.sh /home/$USER/.local/share/nemo/actions
echo "Die Scripte wurden kopiert"
echo "Die Betriebsart -action- wurde gewählt"
echo "- Viel Spaß-"
read -p "Die Installation ist abgeschlossen - Weiter mit Enter -"
ActMod=1
else
echo "Für ihren Dateimanager "$DateiManager" steht der -Action-Modus- nicht zur Verfügung"
read -p "Weiter mit >Enter< Abbruch der Installation mit >1<: " ActMod
fi

;;
esac
done

killall bash inst_cmd.sh

