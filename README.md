# Bild verändern
Erweiterung für >Nemo&lt; um Bilddateien zu konvertieren und/oder die Dateigröße zu verkleinern.
Die Konvertierung und Reduzierung der Dateigröße kann mit dem Programm:
Bild verändern
durchgefürt werden.
Das Programm ist eine Erweiterung für den Dateimanager >Nemo< und wird als Nemo-action eingebunden. Der Start des Programmes erfolgt nach Markierung einer oder mehrerer Bilddateien aus dem Kontextmenü von >Nemo<.
Dieses Nemo Action funktioniert nur mit dem Dateimanager Nemo (Nemo ist beim Desktop Cinnamon der Standard) 
Bei Linux Mint Mate oder XFCE müsste also Nemo nachinstalliert werden (ACHTUNG das ist nicht getestet)

Damit - Bild verändern - ordentlich arbeiten kann braucht es einige installierte Programme auf dem Rechner:
- >Linux Mint Cinnamon< (bringt alles mit) ansonsten muss >Nemo< installiert sein.
- >ImageMagick< Softwarepaket zur Erstellung und Bearbeitung von Rastergrafiken.
- >yad< (Yet Another Dialog) ermöglicht das Erzeugen grafischer Dialoge.
- >libheif-example< um Apple HEIC Fotos zu konvertieren 

Die benötigten Scripte und Dateien für - Bild verändern - sind:
- >bildveraendern.sh< Programmscript
- >bildveraendern.nemo_action< zum einbinden und Steuerung des Scriptes in >Nemo<
- >install< zum installieren des Programms
- >ins_cmd.sh< das eigentliche Installationscript
- >Thema< in diesem Ordner sind GTK-Themen für das Programmscript.


Für die Installation liegt dem Paket eine >install.sh< bei, mit dieser ist die Installation schnell erledigt.
Auch eine >Deinstallation< ist damit möglich.
Das Script für die Installation (Install.sh) entweder im Terminal oder mit doppelklick & ausführen starten. 
Das Script führt durch die Installation und die Schritte sind selbsterklärend.

Verarbeitet werden die folgenden Dateiformate:

jpg:	Skalierung und Qualität frei wählbar - Konvertierung ->Ja< überschreiben->Ja< 

jepg:	Skalierung und Qualität frei wählbar - Konvertierung ->Ja< überschreiben->Ja< 

webp:	Skalierung und Qualität frei wählbar - Konvertierung ->Ja< überschreiben->Ja< 

png:	Skalierung und Qualität frei wählbar - Konvertierung ->Ja< überschreiben->Nein< *

tif:	Skalierung und Qualität frei wählbar - Konvertierung ->Ja< überschreiben->Nein *

HEIC(optional): Wird immer verlustfrei nach *.png konvertiert.

*) Bei *.png und *.tif ist beim überschreiben nur die Skalierung wirksam eine Komprimierung mit der Qualitätseinstellung ist nicht wirksam.
