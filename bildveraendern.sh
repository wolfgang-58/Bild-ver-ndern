#! /bin/bash
#V2.23 >bildveraendern.sh< ->Nachfolger von >jpg-quality< letzte Version V0.6b
#-------------------------------------------------------------------------------------------------------------------------------
#Voraussetzung:
#>ImageMagick< muss installiert sein. INFO: https://wiki.ubuntuusers.de/ImageMagick/
#>yad< muss installiert sein. INFO: https://wiki.ubuntuusers.de/yad/
#Um die Apple >*.HEIC< Fotos zu konvertieren muss >libheif-example< installiert werden. 
#--------------------------------------------------------------------------------------------------------------------------------
#Funktion:
#Erweiterung für die Dateimanager: Nemon, Caja, Nautilus, Thunar um Bilddateien zu konvertieren
#und/oder die Größe (Pixel) zu reduzieren um damit die Dateigröße zu verkleinern
#Aufruf über das Kontextmenü
#Die Komprimierung/Skalierung kann mit Schiebereglern verändert werden und der >Appendix< 
#kann angegeben werden. 
#Wird kein Appendix angegeben wird >modifiziert< angehängt um ein überschreiben der
#Originaldatei zu vermeiden. Auf Wunsch ist aber auch ein Überschreiben möglich
#Verarbeitet werden die Dateien mit der Erweiterung: 
#jpg, jpeg, png, webp, tiff, tif, gif, bmp, HEIC(optonal)
#*.Heic werden immer mit Q=100 mit dem gleichen Namen als >*.png< erstellt.
#--------------Feste Dateien im Verzeichnis: >~/.config< .------------------------------------------------------- 
#bildveraendern.dat< und >bildveraenden.style< 
#--------------Zur Laufzeit angelegte Dateien im Verzeichnis >~/.config<
#>BilderListe.dat< ; >ergebnis2.dat< ; >skalpix.dat<
#Die Dateien werden nach Ausführung gelöscht!
#-----------------Höhe und Breite anpassen---------------------------------------------------------------------------
#Bei einigen Themen und einer größeren Schrift kann es zu Problemen mit der Darstellung kommen. 
#Dann müssen Höhe und Breite des Programmfensters angepasst werden.
#Die Standardwerte sind Hoehe=300, Breite=300 
#Damit wird das Programmfenster im kleinstmöglichen Format dargestellt.
#Eine Einstellung von Höhe und Breite ist bei der Installation möglich
#--------------------Betriebsarten-----------------------------------------------------------------------------------------
#Nur beim Dateimanager  -Nemo- steht -Bild veändern- in zwei Betriebsarten zur Verfügung
#Dies ist zum einen die Betriebsart -action- und zum anderen die Betriebsart -script-.
#Bei der Betriebsart -action- steht -Bild verändern- direkt im Kontextmenü  zur Verfügung. 
#Bei der Betriebsart -script- muss -Bild verändern- im über den Kontextmenüpunkt über -Scripte- aufgerufen werden.
#Für die Dateimanager: Caja, Nautilus und Thunar steht nur die Betriebsart -script-  zur Verfügung .
#Aufruf von -Bild veändern- für die folgenden Dateimanager:
#Caja - im Kontextmenü über -Scripte-
#Nautilus - im Kontextmenü über -Scripte-
#Thunar - direkt im Kontextmenü
#----------------------------------------------------------------------------------------------------------------------------
#Kontakt: @wolfgang58 über https://www.linuxmintusers.de/ oder vulkan58@gmx.de
#-----------------------------------------------------------------------------------------
#Abbruch des Programms mit  >ESC< - verschieben des Fensters mit gedrückter linker Maustaste
#----------------------------------------------------------------------------------------------------------------------------
# V2.21 vom 22.11.2021 
# Ab dieser Version wird eine >.config/bildveraenden.style< vom Installationsprogramm angelegt
# Überarbeitet 24.11.2021: Fehler bei Pixelermittlung behoben => Leerzeichen im Dateinamen
# Überarbeitet 25.11.2021: GTK_Theme verändert und Programm auf on-top gesetzt
#
# V2.22 vom 6.12.2021
# 01.12.2021 *.gif und *.bmp Unterstützung eingebaut
# 03.13.2021 Abbruch wenn keine Datei oder keine gültige Bilddatei gewählt wird
# 04.12.2021 Auswahl von gemischten Dateien möglich -nur Bilddateien werden verarbeitet
# 04.12.2021 Verwendung als -action- und -script- Auswahl bei der Installation
#
# V2.23 vom 11.12.2021
# 09.12.2021 Unterstützung für die Dateinmanager -Caja, Nautilus und Thunar- hinzugefügt
#11.12.2021 Die Bilder mit Exif-Daten können auch ohne Exif-Ddaten gespeichert werden.
#
Version="Bild verändern 2.23" #vom 11.12.2021
#----------------------------------------------------------------------------------------------------------------------------
#-------Einrichten der Pipe und entferen nach Prog.ende----
export MeinKanal=$(mktemp -u --tmpdir meika.XXXXXXXX)
mkfifo "$MeinKanal"
trap "rm -f "$MeinKanal"" EXIT
KindId=$(($RANDOM * $$))
#---------Style-Datei einlesen---
if [ -e "/home/$USER/.config/bildveraendern.style" ];then
    read DateiManagerIn BetriebArtIN breiteIn hoeheIn StyleIn < "/home/$USER/.config/bildveraendern.style"
else
    StyleIn=" "
fi

#-------------Funktionen Deklaration-------------
export speichern_cmd='@bash -c "speichern '%1' '%2' '%3' '%4' '%5' '%6' '%7' '%8' '%9'"'
export berechnen_cmd='@bash -c "berechnen '%1' '%2' '%3' '%4' '%5' '%6' '%7' '%8' '%9'"'
#-------------Konstanten/Variablen------------------------
DateiManager="$DateiManagerIn"
BetriebArt="$BetriebArtIN" 
breite="$breiteIn"
hoehe="$hoeheIn"
Style="$StyleIn"
KindId=$(($RANDOM * $$))
conf="/home/$USER/.config/bildveraendern.dat"
bilderliste="/home/$USER/.config/BilderListe.dat"
SkalPix="/home/$USER/.config/skalpix.dat"
Ergebnis_2="/home/$USER/.config/ergebnis2.dat"
gtkt="GTK_THEME="
icon_tb="/home/$USER/.icons/bv-icon_tb.png"

#-------------Löschen der Hifsdateien
rm -f "$bilderliste" "$Ergebnis_2" "$SkalPix"
#-----------------Funktionen-------------------
function ausgabe
{
read skal < "$SkalPix"
skal=$(echo $skal | awk -F "|" '{ print $1 }')

read erg < "$Ergebnis_2"
    qual=$(echo $erg | awk -F "|" '{ print $2 }')
    appe=$(echo $erg | awk -F "|" '{ print $3 }')
    Ziel=$(echo $erg | awk -F "|" '{ print $4 }')
    uebr=$(echo $erg | awk -F "|" '{ print $5 }')
    exif=$(echo $erg | awk -F "|" '{ print $6 }')
    vorg=$(echo $erg | awk -F "|" '{ print $7 }')
    Ziel="$Ziel""/"
    appe=$(tr -d " " <<< "$appe")

#-------Einlesen der Bilder in Array FILES----------
i=0
while read Line ; do
FILES2[i]="$Line"
((i++))
done < "/home/$USER/.config/BilderListe.dat"
#----------Ende Bilder einlesen------

    if [ $vorg = "TRUE" ]; then echo $qual $skal $appe $uebr $exif > /home/$USER/.config/bildveraendern.dat; fi
    if [ -z $appe ]; then appe="_modifiziert"; fi 
#if [ $appe = "pdf" ];then expdf=".pdf";else expdf="";fi #Geht so nicht -Sicherheit- 
    for i in "${FILES2[@]}"; do
        ext=${i##*\.}
        d=$(dirname "$i")
        nq=$(basename "$i" ."$ext")
        ext=$(echo $ext |tr "[:upper:]" "[:lower:]")
#------------Progessbar---------------
        ((z++))
        nqp=$(cut -c 1-12 <<< "$nq")
        Anz=${#FILES2[@]}    
        echo "#$nqp "" Bild $z  von  $Anz"
        p=$(( z * 100 / Anz ))
        echo $p
#----------Ende Progessbar----
           case $ext in       
            jpg|jpeg|png|webp|tif|tiff|gif|bmp)
            if [ $exif = "TRUE" ]; then s="-strip";else s=" ";fi
            if [ $uebr = "FALSE" ]; then            
            convert "$i" -resize "$skal""%" -quality $qual ${s} "$Ziel""$nq""$appe.jpg" 
            else
            #if [ $appe = "pdf" ];then ext="pdf";fi #Geht so nicht -Sicherheit- 
            convert "$i" -resize "$skal""%" -quality $qual ${s} "$Ziel""$nq""."$ext""
            fi
           ;;
            heic|HEIC)
            command -v heif-convert >/dev/null && i_Hconvert="OK"  || i_Hconvert="FALSE"
            if [ $i_Hconvert = "FALSE" ]; then
            yad --text=" heif-convert - ist nicht installiert! Bitte installieren mit sudo apt install libheif-example "
            exit; fi
            qualH="100"
            heif-convert -q $qualH "$i" "$Ziel""$nq"".png" #HEIC von iPhone Bildern umwandeln
           ;;
           esac
     done | GTK_THEME=$Style yad --progress --auto-close auto-kill --text="Bearbeite Bild:" --title="$Version" --percentage=0 \
                                 --skip-taskbar --no-buttons --on-top --geometry=600x80 --fixed
} #---------Ende Ausgabe-----------------------------
function speichern
{
yad --text="Wird nur benötigt, wenn ein Button gewünscht ist" 
}
function berechnen 
{
read skpi < "$SkalPix"
Wert=$(echo "$skpi" | awk -F "|" '{ print $1 }')
x=$(echo "$skpi" | awk -F "|" '{ print $2 }')
y=$(echo "$skpi" | awk -F "|" '{ print $3 }')

xn=$((x*$Wert/100))
yn=$((y*$Wert/100))
}
#---------------Ende Funktionen----------------------
#---------------Export Funktionen und Pipe öffenen-------
export -f ausgabe
export -f speichern
export -f berechnen
exec 8<> "$MeinKanal"
#-----Prüfen und einlesen der bildveraendern.dat-----------------------------
if [ ! -e "$conf" ];then
echo "20 " "100" "_eMail" "FALSE" "FALSE" > "$conf"
fi
read vq vs va vu ve < "$conf"
va=$(tr -d " " <<< "$va")

#-------Einlesen der Bilder in Array FILES BetriebArt=action----------
case $BetriebArt in
action)
    IN=$*
    IFS=";" read -ra FILES <<< "$IN"
    for i in "${FILES[@]}"; do
    ext=${i##*\.}
    echo "$i" >> "$bilderliste"
    done
;;
#-------Einlesen der Bilder in BetriebArt=script----------
script)
#--------Einlesen mit Script
  case $DateiManager in
   nemo) # Dateimanager Nemo
    for i in "${NEMO_SCRIPT_SELECTED_FILE_PATHS[@]}"
    do
    echo "$i" > "$bilderliste"
    done
   ;;
   caja) # Dateimanager Caja --GETESTET--
    for i in "${CAJA_SCRIPT_SELECTED_FILE_PATHS[@]}"; do
    echo "$i" > "$bilderliste"
    done
    ;;
   nautilus) # Dateimanager Nautilus --UNGETESTET--
    for i in "${NAUTILUS_SCRIPT_SELECTED_FILE_PATHS[@]}"; do
    echo "$i" > "$bilderliste"
    done
   ;;
   thunar) # Dateimanager Thunar 
   while (( "$#" ));do
   echo $1 >> "$bilderliste"
   shift
   done
   ;;
  esac
;;
esac
# Prüfung ob es sich um gültige Bildateien handelt
i=0
while read Line ; do
FILES[i]="$Line"
((i++))
done < "/home/$USER/.config/BilderListe.dat"

rm -f "$bilderliste"

for i in "${FILES[@]}"; do
        ext=${i##*\.}
        ext=$(echo $ext |tr "[:upper:]" "[:lower:]") 
 case $ext in
    jpg|jpeg|png|webp|tif|tiff|heic|gif|bmp)
    echo $i >> "$bilderliste"

    ;;
    *)
    echo $i > /dev/NULL
    ;;
 esac
done

if [ ! -f "/home/$USER/.config/BilderListe.dat" ];then
    GTK_THEME="$Style" yad --text="Es wurde keine Bilddatei ausgewählt. Das Programm wird beendet!" \
                       --image=info --title="$Version" --borders=5 --on-top --button="gtk-ok" \
                       --width=200 --height=80 --fixed --skip-taskbar
    rm -f "$bilderliste" "$Ergebnis_2" "$SkalPix"
    exit
fi
k=0
while read Line ; do
FILES1[k]="$Line"
((k++))
done < "/home/$USER/.config/BilderListe.dat"
#-------Ende Einlesen und Prüfen mit Script----------------------------------------
#----------Aktuelles Verzeichnis ermitteln------
ErstFile="${FILES1[0]}"
AktDir=$(dirname "$ErstFile")
anz=${#FILES1[@]}
#----------Pixel ermitteln----------
if [ $anz -eq 1 ]; then
#--cd wegen Leerzeichen im Pfad----
cd "$AktDir"
bn=$(basename "$ErstFile")
spw=$(identify -format '%w' "$bn")
sph=$(identify -format '%h' "$bn")
sp=""$spw" x "$sph" Pixel"
else 
sp="Mehrfachauswahl"
fi
#---------------------------------------------------------
#--------Texte--------------
BildInfo="<span><b>Info zum Original\n"$bn"\n"$sp"</b></span>\n\n""Skalieren [%]:"
#------Ende Texte-----------
#----Dekalaration der Felder
declare -i a="$vq" #Qualität
declare b="$va" #Appendix
declare c="$AktDir" #Verzeichnis
declare d="$vu" #überschreiben
declare e="$ve" #Exif-Daten löschen
declare f="False" #speichern
#---------------------------------------------------Hauptteil-------------------------------------
{ echo "$vs" ;GTK_THEME="$Style" yad --plug="$KindId" --tabnum=1 --scale \
                                     --mark=0:0 --mark=25:25 --mark=50:50 --mark=75:75 --mark=100:100 \
                                     --hide-value --text-align=center --text="$BildInfo" --print-partial \
                                     --value="$vs" --min-value=0 --max-value=100;} | \
while read -r Wert; do
        echo "$Wert|$spw|$sph" > "$SkalPix"
        berechnen $Wert
        echo ""$Wert % " -> "$xn" x "$yn"" > "$MeinKanal"
        if [ "${a}" ]; then
            echo "${a}" > "$MeinKanal"
            unset a
        else
            echo "" > "$MeinKanal"
        fi
        
        if [ "${b}" ]; then
            echo "${b}" > "$MeinKanal"
            unset b
        else
            echo "" > "$MeinKanal"
        fi

        if [ "${c}" ]; then
            echo "${c}" > "$MeinKanal"
            unset c
        else
            echo "" > "$MeinKanal"
        fi

        if [ "${d}" ]; then
            echo "${d}" > "$MeinKanal"
            unset d
        else
            echo "" > "$MeinKanal"
        fi

        if [ "${e}" ]; then
            echo "${e}" > "$MeinKanal"
            unset e
        else
            echo "" > "$MeinKanal"
        fi

        if [ "${f}" ]; then
            echo "${f}" > "$MeinKanal"
            unset f
        else
            echo "" > "$MeinKanal"
        fi
done &

GTK_THEME="$Style" \
     yad --plug="$KindId" --tabnum=2 --form --text-align=center  --focus-field=8 --cycle-read \
    --field="Skalierung [%] -> Pixel:":RO \
    --field="Qualität [%]:":scl \
    --field="Appendix": \
    --field="Zielverzeichnis:":dir \
    --field="Datei(en) Überschreiben":chk  \
    --field="Exif-Daten löschen":chk \
    --field="Einstellungen speichern":chk <&8> "$Ergebnis_2" &


GTK_THEME="$Style" \
    yad --paned --key="$KindId" --window-icon=$icon_tb --title="$Version" \
        --borders=3 --button="gtk-cancel:1" --button="gtk-apply:0" --buttons-layout=center --mouse --fixed --on-top \
        --width=$breite --height=$hoehe
ret=$?
case $ret in 
0)
ausgabe
rm -f "$bilderliste" "$Ergebnis_2" "$SkalPix"
exec 8>&-
exit
;;
1)
rm -f "$bilderliste" "$Ergebnis_2" "$SkalPix"
exec 8>&-
exit
;;
*)
rm -f "$bilderliste" "$Ergebnis_2" "$SkalPix"
exec 8>&-
exit
;;
esac

