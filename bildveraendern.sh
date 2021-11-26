#! /bin/bash
#V2.21 >bildveraendern.sh< ->Nachfolger von >jpg-quality< letzte Version V0.6b
#-----------------------------------------------------------------------------------
#Voraussetzung:
#>ImageMagick< muss installiert sein. INFO: https://wiki.ubuntuusers.de/ImageMagick/
#>yad< muss installiert sein. INFO: https://wiki.ubuntuusers.de/yad/
#Um die Apple >*.HEIC< Fotos zu konvertieren muss >libheif-example< installiert werden. 
#----------------------------------------------------------------------------------
#Funktion:
#Script zum verändern der JPG-Qualität aus dem Kontexmenü von Nemo in Verbindung mit
#>bildveraendern.nemo.action< der Scriptname muss >bildveraendern.sh< lauten
#Die Komprimierung/Skalierung kann mit Schiebereglern verändert werden und der >Appendix< 
#kann angegeben werden.
#Wird kein Appendix angegeben wird >modifiziert< angehangen um ein überschreiben der
#Originaldatei zu vermeiden.
#Auf wunsch ist aber auch ein Überschreiben möglich
#Beide Dateien, >bildveraendern.nemo.action< und >bildveraendern.sh<, müssen sich im Verzeichnis
#>~/.local/share/nemo/actions< befinden.
#Verarbeitet werden die Dateinen mit der Erweiterung: jpg,png,jepg,webp,tiff,tif HEIC(optonal)
#*.Heic werden immer mit Q=100 mit dem gleichen Namen als >*.png< erstellt.
#--------------Feste Dateien im .config-------------- 
#Eine >bildveraendern.dat< wird im Verzeichnis: >~/.config< angelegt.
#Eine >bildveraenden.style< wird im Verzeichnis: >~/.config< angelegt.
#--------------Zur Laufzeit angelegte Dateien in >~/.config<
#>BilderListe.dat
#>ergebnis2.dat<
#>skalpix.dat<
#Die Dateien werden nach Ausführung gelöscht!
#--------------------------------------------------------
#Verwendung auf eigene Gefahr
#Kontakt: @wolfgang58 über https://www.linuxmintusers.de/ oder vulkan58@gmx.de
#-----------------------------------------------------------------------------------------
#Abbruch des Programms mit  >ESC< - verschieben des Fensters mit >ALT<&>LinkeMausTaste<
#--------------------------------------------------------------------------------------------
# V2.21 vom 22.11.2021 
# Ab dieser Version wird eine >.config/bildveraenden.style< vom Installationsprogramm angelegt
# Überarbeitet 24.11.2021: Fehler bei Pixelermittlung behoben => Leerzeichen im Dateinamen
# Überarbeitet 25.11.2021: GTK_Theme verändert und Programm auf on-top gesetzt
# 
Version="Bild verändern 2.21" #vom 22.11.2021
#----------------------------------------------------------------------------------------------
#-------Einrichten der Pipe und entferen nach Prog.ende----
export MeinKanal=$(mktemp -u --tmpdir meika.XXXXXXXX)
mkfifo "$MeinKanal"
trap "rm -f "$MeinKanal"" EXIT
KindId=$(($RANDOM * $$))
#---------Style-Datei einlesen---
if [ -e "/home/$USER/.config/bildveraendern.style" ];then
    read StyleIn < "/home/$USER/.config/bildveraendern.style"
else
    StyleIn=" "
fi

#-------------Funktionen Deklaration-------------
export speichern_cmd='@bash -c "speichern '%1' '%2' '%3' '%4' '%5' '%6' '%7' '%8' '%9'"'
export berechnen_cmd='@bash -c "berechnen '%1' '%2' '%3' '%4' '%5' '%6' '%7' '%8' '%9'"'
#-------------Konstanten------------------------
Style="$StyleIn"
KindId=$(($RANDOM * $$))
conf="/home/$USER/.config/bildveraendern.dat"
bilderliste="/home/$USER/.config/BilderListe.dat"
SkalPix="/home/$USER/.config/skalpix.dat"
Ergebnis_2="/home/$USER/.config/ergebnis2.dat"
gtkt="GTK_THEME="

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
    vorg=$(echo $erg | awk -F "|" '{ print $6 }')
    Ziel="$Ziel""/"
    appe=$(tr -d " " <<< "$appe")

#-------Einlesen der Bilder in Array FILES----------
i=0
while read Line ; do
FILES[i]="$Line"
((i++))
done < "/home/$USER/.config/BilderListe.dat"
#----------Ende Bilder einlesen------

    if [ $vorg = "TRUE" ]; then echo $qual $skal $appe $uebr > /home/$USER/.config/bildveraendern.dat; fi
    if [ -z $appe ]; then appe="_modifiziert"; fi   
    for i in "${FILES[@]}"; do
        ext=${i##*\.}
        d=$(dirname "$i")
        nq=$(basename "$i" ."$ext")
        ext=$(echo $ext |tr "[:upper:]" "[:lower:]")
#------------Progessbar---------------
        ((z++))
        nqp=$(cut -c 1-12 <<< "$nq")
        Anz=${#FILES[@]}    
        echo "#$nqp "" Bild $z  von  $Anz"
        p=$(( z * 100 / Anz ))
        echo $p
#----------Ende Progessbar----
           case $ext in       
            jpg|jpeg|png|webp|tif|tiff)
            if [ $uebr = "FALSE" ]; then            
            convert "$i" -resize "$skal""%" -quality $qual "$Ziel""$nq""$appe.jpg"
            else
            convert "$i" -resize "$skal""%" -quality $qual "$Ziel""$nq""."$ext""
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
#echo "$xn"" x ""$yn" " Pixel" > "$MeinKanal"
}
#---------------Ende Funktionen----------------------
#---------------Export Funktionen und Pipe öffenen-------
export -f ausgabe
export -f speichern
export -f berechnen
exec 8<> "$MeinKanal"
#-----Prüfen und einlesen der bildveraendern.dat-----------------------------
if [ ! -e "$conf" ];then
echo "20 " "100" "_eMail" "FALSE" > "$conf"
fi
read vq vs va vu  < "$conf"
va=$(tr -d " " <<< "$va")
#-------Einlesen der Bilder in Array FILES----------
IN=$*
IFS=";" read -ra FILES <<< "$IN"
for i in "${FILES[@]}"; do
#echo "Files-read ""$i"
echo "$i" >> "$bilderliste"
done
#----------Aktuelles Verzeichnis ermitteln------
ErstFile="${FILES[0]}"
AktDir=$(dirname "$ErstFile")
#----------Pixel ermitteln----------
anz=${#FILES[@]}
if [ $anz -eq 1 ]; then
#----------cd wegen Leerzecihen im Pfad-----------------------
cd "$AktDir"
bn=$(basename "$ErstFile")
spw=$(identify -format '%w' "$bn")
sph=$(identify -format '%h' "$bn")
sp=""$spw" x "$sph" Pixel"
else 
sp="Mehrfachauswahl"
fi

#--------Texte--------------
BildInfo="<span><b>Info zum Original\n"$bn"\n"$sp"</b></span>\n\n""Skalieren [%]:"
#------Ende Texte-----------
#----Dekalaration der Felder
declare -i a="$vq" #Qualität
declare b="$va" #Appendix
declare c="$AktDir" #Verzeichnis
declare d="$vu" #überschreiben
declare e="False" 
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
done &

GTK_THEME="$Style" \
     yad --plug="$KindId" --tabnum=2 --form --text-align=center  --focus-field=8 --cycle-read \
    --field="Skalierung [%] -> Pixel:":RO \
    --field="Qualität [%]:":scl \
    --field="Appendix": \
    --field="Zielverzeichnis:":dir \
    --field="Datei(en) Überschreiben":chk  \
    --field="Einstellungen speichern":chk <&8> "$Ergebnis_2" &


GTK_THEME="$Style" \
    yad --paned --key="$KindId" --window-icon=star --title="$Version" \
        --borders=3 --button="gtk-cancel:1" --button="gtk-apply:0" --buttons-layout=center --mouse --fixed --on-top
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

