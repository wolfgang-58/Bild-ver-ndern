#! /bin/bash
#V2.24 >bildveraendern.sh< ->Nachfolger von >jpg-quality< letzte Version V0.6b
#-----------------------------------------------------------------------------------
#INSTALLATION:
#Vor dem Einrichten bzw. der Installation des Programmes müssen die Komponenten ausführbar gemacht
#werden. Dazu bitte im Verzeichnis in welchem sich die Programmdateien befinden folgenden 
#Befehl im Terminal ausführen:
#chmod +x bildveraendern.sh install.sh inst_cmd.sh
#Danach kann >install.sh< mit Doppelklick gestartet werden. 
#xfce-Nutzer starten die >install.sh< bitte im Teminal.
#Eine manuelle Installation ist nicht möglich.
#--------------------------------------------------------------------------------------
#Voraussetzungen:
#>ImageMagick< muss installiert sein. INFO: https://wiki.ubuntuusers.de/ImageMagick/
#>yad< muss installiert sein. INFO: https://wiki.ubuntuusers.de/yad/
#>img2pdf< muss intalliert sein. INFO: https://pypi.org/project/img2pdf/
#Um die Apple >*.HEIC< Fotos zu konvertieren muss >libheif-example< installiert werden. 
#----------------------------------------------------------------------------------
#Funktion:
#Script zum verändern der Bildqualität und/oder der Dateigröße. Das Programm wird aus dem
# Kontextmenü aufgerufen unterstützt werden die Dateimanager
# -Nemo  
# -Caja
# -Nutilus
# -Thunar
#Die Komprimierung/Skalierung kann mit Schiebereglern verändert werden und der >Appendix< 
#kann angegeben werden.
#Wird kein Appendix angegeben wird >modifiziert< angehängt um ein überschreiben der
#Originaldatei zu vermeiden.
#Auf Wunsch ist aber auch ein Überschreiben möglich
#Die Einstellungen im Programmfenster sind temporär, im Einstellungsfenster können die
#Funktionen eingestellt werden die bei jedem Start aktiv sein sollen. 
#Im Appendixeditor ist es möglich eigenen Appendixe anzulegen.
#Verarbeitet werden die Dateien mit diesen Erweiterungen: 
#jpg, jpeg, png, webp, tiff, tif, gif, bmp, HEIC(optonal)
#*.Heic werden immer mit Q=100 mit dem gleichen Namen als >*.png< erstellt.
#Aus den verarbeiteten Dateien ist es möglich eine PDF oder ein Archiv tar.gz zu 
#erzeugen. Die PDF-Dateien werden standardmäßig mit einem Inhaltsverzeichnis/Lesezeichen
#für jedes Bild angelegt. Diese PDF ist verlustbehaftet, in den Einstellungen ist es möglich    
#optional auch eine verlustfreie PDF-Datei zu erzeugen, diese hat keine Inhaltsverzeichnis/
#Lesezeichen.
#Die PDF-Dateien und das tar.gz Archiv werden mit einem Zeitstempel im Dateinamen
#erzeugt: JJMMDD-hhmmss.  
#---------------Optionen bei der Installation------------------------------
#Während der Installation wird geprüft ob die Voraussetzungen erfüllt sind. 
#Wenn nicht, ist es möglich fehlende externe Programme während der Installation
#zu installieren.
#-----------------Höhe und Breite anpassen------------------------------
# Bei einigen Themen und eine größeren Schrift kann es zu Problemen 
# mit der Darstellung kommen. Dann müssen Höhe und Breite des 
# Programmfensters angepasst werden
# Hoehe=300, Breite=300 sind die Standardvorgaben
# Damit wird das Programmfenster im kleinstmöglichen Format dargestellt.
# Eine Einstellung von Höhe und Breite ist bei der Installation möglich
#--------------------Position des Programmfensters-----------------------
#Hier wird die Position des Programmfensters beim Start angegeben. Es stehen
#die Optionen m=Mausposition oder c=Central d.h.mittig auf dem Bildschirm.
#--------------------Betriebsarten----------------------------------------
# "Unter -Nemo- steht -Bild veändern- in zwei Betriebsarten zur Verfügung
# Dies ist zum einen die Betriebsart -action- und zum anderen die Betriebsart -script-.
# Bei der Betriebsart -action- steht -Bild verändern- im Kontextmenü unmittelbar 
# zur Verfügung. 
# Bei der Betriebsart -script- muss -Bild verändern- über den 
# Kontextmenüpunkt -Scripte- aufgerufen werden. 
# Für die Dateimanager: Caja, Nautilus und Thunar
# steht lediglich der -Script-Modus- zur Verfügung 
#--------------Feste Dateien im .config-------------- 
#Eine >bildveraendern.dat< wird im Verzeichnis: >~/.config< angelegt.
#Eine >bildveraenden.style< wird im Verzeichnis: >~/.config< angelegt.
#Eine >bildveraendern-info.txt< wird im Verzeichnis: >~/.config< angelegt.
#--------------Zur Laufzeit angelegte Dateien in >~/.config<
#>BilderListe.dat
#>ergebnis2.dat<
#>skalpix.dat<
#>PDF-Liste.dat<
#>ZIP-Liste.dat<
#>Lesezeichen.txt<
#>bv-rs<
#Die Dateien werden nach Ausführung gelöscht!
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
# V2.22 vom 6.12.2021
# 01.12.2021 *.gif und *.bmp Unterstützung eingebaut
# 03.13.2021 Abbruch wenn keine Datei oder keine gültige Bilddatei gewählt wird
# 04.12.2021 Auswahl von gemischten Dateien möglich -nur Bilddateien werden verarbeitet
# 04.12.2021 Verwendung als -action- und -script- Auswahl bei der Installation
# V2.23 vom 11.12.2021
# 09.12.2021 Unterstützung für die Dateinmanager -Caja, Nautilus und Thunar- hinzugefügt
# 11.12.2021 Die Bilder mit Exif-Daten können auch ohne Exif-daten gespeichert werden.
# V.2.24 vom 27.12.2021 
# PDF-Unterstützung hinzugefügt. Benötigt wird >img2pdf< 
# Basiseinstellungsfenster hinzugefügt
# Nach den Einstellungen wird mit den gewählten Bilder das Programm neu gestartet
# Kleinere Fehler behoben
Version="Bild verändern 2.24" #vom 05.01.2022
#----------------------------------------------------------------------------------------------
#-------Einrichten der Pipe und entferen nach Prog.ende----
export MeinKanal=$(mktemp -u --tmpdir meika.XXXXXXXX)
mkfifo "$MeinKanal"
trap "rm -f "$MeinKanal"" EXIT
KindId=$(($RANDOM * $$))
#---------Style-Datei einlesen---
if [ -e "/home/$USER/.config/bildveraendern.style" ];then
    read DateiManagerIn BetriebArtIN breiteIn hoeheIn ProgPosIn StyleIn < "/home/$USER/.config/bildveraendern.style"
else
    StyleIn=" "
fi

#-------------Funktionen Deklaration-------------
export speichern_cmd='@bash -c "speichern '%1' '%2' '%3' '%4' '%5' '%6' '%7' '%8' '%9'"'
export berechnen_cmd='@bash -c "berechnen '%1' '%2' '%3' '%4' '%5' '%6' '%7' '%8' '%9'"'
#export information_cmd="@bash -c information" 
#-------------Konstanten/Variablen------------------------
DateiManager="$DateiManagerIn"
BetriebArt="$BetriebArtIN" 
breite="$breiteIn"
hoehe="$hoeheIn"
Style="$StyleIn"
progpos="$ProgPosIn"
KindId=$(($RANDOM * $$))
conf="/home/$USER/.config/bildveraendern.dat"
bilderliste="/home/$USER/.config/BilderListe.dat"
SkalPix="/home/$USER/.config/skalpix.dat"
Ergebnis_2="/home/$USER/.config/ergebnis2.dat"
gtkt="GTK_THEME="
icon_tb="/home/$USER/.icons/bv-icon_tb.png"
pdf_liste="/home/$USER/.config/PDF_Liste.dat"
zip_liste="/home/$USER/.config/ZIP_Liste.dat"
lesezeichen="/home/$USER/.config/Lesezeichen.txt"
#-------------Löschen der Hifsdateien
if [ -f /home/$USER/.config/bv-rs ];then
rm -f "$Ergebnis_2" "$SkalPix" "$pdf_liste" "$zip_liste" "$lesezeichen" 
rm -f /home/$USER/.config/bv-rs
else
rm -f "$bilderliste" "$Ergebnis_2" "$SkalPix" "$pdf_liste" "$zip_liste" "$lesezeichen" 
fi
#-----------------Funktionen-------------------
function lesezeichen
{
BildNr=$1
BildTitel=$2
echo "[/Page "$BildNr"   /View [/XYZ null null null] /Title ("$BildTitel")         /OUT pdfmark" >> "$lesezeichen"
}
#-----------------------------------------------
function ausgabe
{
read skal < "$SkalPix"
skal=$(echo $skal | awk -F "|" '{ print $1 }')
read bvdat < "$conf"
appeLst=$(echo $bvdat | awk -F " " '{ print $3 }')
pdfl=$(echo $bvdat | awk -F " " '{ print $6 }')
pdfn=$(echo $bvdat | awk -F " " '{ print $7 }')

read erg < "$Ergebnis_2"
    qual=$(echo $erg | awk -F "|" '{ print $2 }')
    appe=$(echo $erg | awk -F "|" '{ print $3 }')
    Ziel=$(echo $erg | awk -F "|" '{ print $4 }')
    uebr=$(echo $erg | awk -F "|" '{ print $5 }')
    epdf=$(echo $erg | awk -F "|" '{ print $6 }')
    komp=$(echo $erg | awk -F "|" '{ print $7 }')
    exif=$(echo $erg | awk -F "|" '{ print $8 }')
    vorg=$(echo $erg | awk -F "|" '{ print $9 }')
    Ziel="$Ziel""/"
    appe=$(tr -d " " <<< "$appe")
    
#-------Einlesen der Bilder in Array FILES----------
bn=0
i=0
while read Line ; do
FILES2[i]="$Line"
((i++))
done < "/home/$USER/.config/BilderListe.dat"
#----------Ende Bilder einlesen------
if [ -z $appe ]; then appe="_modifiziert"; fi 
appe_ges="$appe"",""$appeLst"

    if [ -z $appe ]; then appe="_modifiziert"; fi 
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
            if [ $epdf = "TRUE" ]; then echo "$Ziel""$nq""$appe.jpg" >> "$pdf_liste";fi
            if [ $komp = "TRUE" ]; then echo  "$nq""$appe.jpg" >> "$zip_liste";fi
            else
            convert "$i" -resize "$skal""%" -quality $qual ${s} "$Ziel""$nq""."$ext""
            if [ $epdf = "TRUE" ]; then echo "$Ziel""$nq""."$ext"" >> "$pdf_liste";fi
            if [ $komp = "TRUE" ]; then echo "$nq""."$ext"" >> "$zip_liste";fi
            fi
            ((bn++)) #Bildnummer für Lesezeichen
            if [ $epdf = "TRUE" ];then lesezeichen "$bn" "$nq"".""$ext";fi

           ;;
            heic|HEIC)
            command -v heif-convert >/dev/null && i_Hconvert="OK"  || i_Hconvert="FALSE"
            if [ $i_Hconvert = "FALSE" ]; then
             yad --text=" heif-convert - ist nicht installiert! Die Datei(en)*.heic werden nicht verarbeitet!"\
            --skip-taskbar --on-top --image=info --button="gtk-ok" --width=200 --height=80 --fixed --borders=5
            else
             qualH="100"
             heif-convert -q $qualH "$i" "$Ziel""$nq"".png" #HEIC von iPhone Bildern umwandeln
             if [ $epdf = "TRUE" ]; then echo "$Ziel""$nq"".png" >> "$pdf_liste";fi
             if [ $komp = "TRUE" ]; then echo "$nq"".png" >> "$zip_liste";fi
             ((bn++))  #Bildnummer für Lesezeichen
             if [ $epdf = "TRUE" ];then lesezeichen "$bn" "$nq"".""$ext";fi
            fi
           ;;
           esac

#if [ $epdf = "TRUE" ];then lesezeichen "$z" "$nq"".""$ext";fi


     done | GTK_THEME=$Style yad --progress --auto-close auto-kill --text="Bearbeite Bild:" --title="$Version" --percentage=0 \
                                 --skip-taskbar --no-buttons --on-top --geometry=600x80 --fixed
#------------------Erzeugen eines PDF-Dokumentes-----------------------------
command -v img2pdf >/dev/null && i_pdf="OK"  || i_pdf="FALSE"
if [ $epdf = "TRUE" ];then
 if [ $i_pdf = "OK" ]; then
  sed -i '1i\ ' "$pdf_liste"
  Ziel1=$(echo "$Ziel" |  sed 's/ /\\ /g')
  Ziel2="$Ziel1""$(date +%y%m%d-%H%M%S-Ausgabe_VF.pdf)"
  Ziel3="$Ziel""$(date +%y%m%d-%H%M%S-Ausgabe_VF.pdf)"
  Ziel4="$Ziel""$(date +%y%m%d-%H%M%S-Ausgabe.pdf)"
  cat "$pdf_liste" |  xargs -d $'\n' bash -c 'img2pdf "$@" -o '"$Ziel2"''
#------PDF-mit-Lesezeichen------------------------
  gs -o "$Ziel4" \
        -sDEVICE=pdfwrite \
        "$lesezeichen" \
         -f "$Ziel3"
if [ $pdfl = "FALSE" ];then
rm -f "$Ziel3"
else
rm -f "$Ziel4"
fi
#---------pdf_appendix----
if [ $pdfn = "TRUE" ];then
   if [ -f "$Ziel3" ];then mv "$Ziel3" "$Ziel""$(date +%y%m%d-%H%M%S-Ausgabe"$appe"_VF.pdf)";fi
   if [ -f "$Ziel4" ];then mv "$Ziel4" "$Ziel""$(date +%y%m%d-%H%M%S-Ausgabe"$appe".pdf)";fi
fi
#---------PDF-Lesezeichen-Ende-------------------
  sed -i -e '1d' "$pdf_liste"   
 else
 yad --text=" img2pdf - ist nicht installiert! Bitte installieren mit sudo apt install img2pdf "
 fi
fi
#---------------------Erzeuegen eines zip-Archiv---------------------------------
Ziel1=$(echo "$Ziel" |  sed 's/ /\\ /g')
Ziel2="$Ziel1""$(date +%y%m%d-%H%M%S-Bildarchiv.tar.gz)"
if [ $komp = "TRUE" ];then 
 sed -i '1i\ ' "$zip_liste"
 cat "$zip_liste" |  xargs -d $'\n' bash -c 'tar -C '"$Ziel1"' -zvchf '"$Ziel2"' "$@"'
 sed -i -e '1d' "$zip_liste"
fi
#---------------------löschen der dateien und listen---------------
if [ $uebr = "FALSE" ];then
 if [ -f "$pdf_liste" ];then cat "$pdf_liste" | xargs -d $'\n' rm;fi
 if [ -f "$zip_liste" ];then 
  cd "$Ziel"
  cat "$zip_liste" | xargs -d $'\n' rm
fi
fi
if [ -f "$pdf_liste" ];then rm "$pdf_liste" "$lesezeichen";fi
if [ -f "$zip_liste" ];then rm "$zip_liste";fi
#----------------------------------Ende PDF und zip--------------------------------------

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
#----------------Hilfe und Info------------------------skip-taskbar
function information
{

GTK_THEME="$Style" yad --text-info --on-top  --fontname="Monospace 9" --title="$Version -Hilfe-" \
    --width=600 --height=600 --wrap --justify=fill --back=gray --fore=white \
    --button="gtk-ok" --center --fixed --borders=5 --window-icon=$icon_tb \
      < /home/$USER/.config/bildveraendern-info.txt
} #----------------------------------------------
#---------------Ende Funktionen----------------------
#---------------Export Funktionen und Pipe öffenen-------
export -f ausgabe
export -f speichern
export -f berechnen
export -f information
exec 8<> "$MeinKanal"
#-----Prüfen und einlesen der bildveraendern.dat-----------------------------
if [ ! -e "$conf" ];then
#-----skal---qual----Appendix------über-----pdf-  pdf-VF--pdf-app---komp---spei------
echo "100" "20 " "_eMail,_klein" "FALSE" "FALSE" "FALSE" "FALSE" "FALSE" "FALSE" > "$conf"
fi
read vs vq va vu vp vp1 vp2 vk ve < "$conf"
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
  case $DateiManager in
   nemo) # Dateimanager Nemo
    for i in "${NEMO_SCRIPT_SELECTED_FILE_PATHS[@]}"; do
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
declare e="$vp" #pdf
declare f="$vk" #komprimieren
declare g="$ve" #Exif-Daten löschen
#declare h="False" #speichern
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
        if [ "${g}" ]; then
            echo "${g}" > "$MeinKanal"
            unset g
        else
            echo "" > "$MeinKanal"
        fi

       # if [ "${h}" ]; then
       #     echo "${h}" > "$MeinKanal"
       #     unset h
       # else
       #     echo "" > "$MeinKanal"
       # fi
done &

GTK_THEME="$Style" \
     yad --plug="$KindId" --tabnum=2 --form --text-align=center --focus-field=8 --cycle-read --item-separator=","\
    --field="Skalierung [%] -> Pixel:":RO \
    --field="Qualität [%]:":scl \
    --field="Appendix":cbe \
    --field="Zielverzeichnis:":dir \
    --field="Datei(en) Überschreiben":chk  \
    --field="PDF-Datei erzeugen":chk \
    --field="Komprimieren":chk \
    --field="Exif-Daten löschen":chk <&8> "$Ergebnis_2" &


GTK_THEME="$Style" \
    yad --paned --key="$KindId" --window-icon=$icon_tb --title="$Version" --"$progpos" --buttons-layout=center --fixed --on-top\
        --width=$breite --height=$hoehe \
        --borders=3 --button="Einstellungen:2"\
        --button="gtk-cancel:1" \
        --button="gtk-apply:0"
        
ret=$?
case $ret in 
0)
ausgabe
rm -f "$bilderliste" "$Ergebnis_2" "$SkalPix" "$pdf_liste" "$zip_liste" "$lesezeichen" 
exec 8>&-
exit
;;
1)
rm -f "$bilderliste" "$Ergebnis_2" "$SkalPix" "$pdf_liste" "$zip_liste" "$lesezeichen" 
exec 8>&-
exit
;;
2)
read vorgabe < "$conf"
skal=$(echo $vorgabe | awk -F " " '{ print $1 }')
qual=$(echo $vorgabe | awk -F " " '{ print $2 }')
appl=$(echo $vorgabe | awk -F " " '{ print $3 }')
uebr=$(echo $vorgabe | awk -F " " '{ print $4 }')
epdf=$(echo $vorgabe | awk -F " " '{ print $5 }')
pdfl=$(echo $vorgabe | awk -F " " '{ print $6 }')
pdfn=$(echo $vorgabe | awk -F " " '{ print $7 }')
komp=$(echo $vorgabe | awk -F " " '{ print $8 }')
exif=$(echo $vorgabe | awk -F " " '{ print $9 }')

appl=$(echo $appl | tr ',' '\n')

while true; do
ed=$(GTK_THEME=$Style yad --form --title="$Version" --borders=5 --fixed --on-top --center \
    --window-icon=$icon_tb \
    --button="Hilfe":3 \
    --button="Abbruch":2 \
    --button="OK":0 \
    --field="<span foreground='blue'><b>Basiseinstellungen:</b></span>":lbl "c " \
    --field="Skalierung":num $skal[!0..100] \
    --field="Qualität":num $qual[!0..100] \
    --field="Appendixeditor:":txt "$appl" \
    --field="Überschreiben":chk $uebr \
    --field="PDF-Erzeugen":chk $epdf \
    --field="PDF-Verlustfrei -optional-":chk "$pdfl"  \
    --field="PDF-Name+Appendix -optional-":chk "$pdfn" \
    --field="Komprimieren":chk $komp \
    --field="Exif-Daten löschen":chk $exif)
ret1=$?

    case $ret1 in
    0)
    skal=$(echo $ed | awk -F "|" '{ print $2 }')
    qual=$(echo $ed | awk -F "|" '{ print $3 }')
    appl=$(echo $ed | awk -F "|" '{ print $4 }')
    uebr=$(echo $ed | awk -F "|" '{ print $5 }')
    epdf=$(echo $ed | awk -F "|" '{ print $6 }')
    pdfl=$(echo $ed | awk -F "|" '{ print $7 }')
    pdfn=$(echo $ed | awk -F "|" '{ print $8 }')
    komp=$(echo $ed | awk -F "|" '{ print $9 }')
    exif=$(echo $ed | awk -F "|" '{ print $10 }')


#-----pdf-optionen schaltet PDF-erzeugen ein----
if [ $pdfn = "TRUE" -o $pdfl = "TRUE" ];then
epdf="TRUE"
fi
#-----------------------------------------------

    n=$(echo -e "$appl" | grep -c '^')
    
    appl1=$(echo -e "$appl" | tr '\n' ','| sed '$s/.$//' | sed -e 's/ /_/g')
    if [ -z "$appl" ]; then appl1="_eMail,_klein"; fi
    echo $skal $qual "$appl1" $uebr $epdf $pdfl $pdfn $komp $exif > /home/$USER/.config/bildveraendern.dat
    rm -f  "$Ergebnis_2" "$SkalPix"
    if [ $ret1 = "0" ];then break;fi
    ;;
    
    2)
    break
    ;;
    3)
    information
    ;;
    esac
done
#---neustart----
echo "TRUE"":" > /home/$USER/.config/bv-rs
exec "$0"
#--------------
;;
*)
rm -f "$bilderliste" "$Ergebnis_2" "$SkalPix"
exec 8>&-
exit
;;
esac

