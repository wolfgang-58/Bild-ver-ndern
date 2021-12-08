# Bild verändern 2.22
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
- >install.sh< zum installieren des Programms
- >inst_cmd.sh< das eigentliche Installationscript
- >Thema< in diesem Ordner sind GTK-Themen für das Programmscript.

Nach dem Download von Github müssen die Scripe noch ausführbar gemacht werden
Im Terminal: 
- >chmod +x bildveraendern.sh install.sh inst_cmd.sh 

Für die Installation liegt dem gepacktem Paket eine >install.sh< bei, mit dieser ist die Installation schnell erledigt.
Auch eine >Deinstallation< ist damit möglich.
Das Script entweder im Terminal oder mit doppelklick & ausführen starten.
Das Script führt durch die Installation und die Schritte sind selbsterklärend.
Eine manuellen Installation ist nicht möglich!
Höhe und Breite anpassen
Bei einigen Themen und einer größeren Schrift kann es zu Problemen mit der Darstellung kommen. Dann müssen Höhe und Breite des Programmfensters angepasst werden
Höhe=300, Breite=300 sind die Standardvorgaben
Damit wird das Programmfenster im kleinstmöglichen Format dargestellt.
Eine Einstellung von Höhe und Breite ist während der Installation möglich.
Betriebsarten
Die Betriebsart >action< oder >script< wird während der Installation festgelegt.
Grundsätzlich kann -Bild veändern- in zwei Betriebsarten ausgeführt werden.
Dies ist zum einen die Betriebsart -action- und zum anderen die Betriebsart -script-.
Bei der Betriebsart -action- steht -Bild verändern- im Kontextmenü unmittelbar zu Verfügung. 
Bei der Betriebsart -script- muss -Bild verändern- über den Kontexmenüpunkt -Scripte- aufgerufen werden.
Die Betriebsarten sind in ihrer Funktionalität völlig gleichwertig.
Die Betriebsart wird während der Installation festgelegt.
Verarbeitet werden die folgenden Dateiformate:
jpg:	Skalierung und Qualität frei wählbar - Konvertierung ->Ja< überschreiben ->Ja< 
jepg:	Skalierung und Qualität frei wählbar - Konvertierung ->Ja< überschreiben ->Ja< 
bmp:	Skalierung und Qualität frei wählbar - Konvertierung ->Ja< überschreiben ->Ja< 
gif:	Skalierung und Qualität frei wählbar - Konvertierung ->Ja< überschreiben ->Ja< 
webp:	Skalierung und Qualität frei wählbar - Konvertierung ->Ja< überschreiben ->Ja< 
png:	Skalierung und Qualität frei wählbar - Konvertierung ->Ja< überschreiben ->Nein< *
tif:	Skalierung und Qualität frei wählbar - Konvertierung ->Ja< überschreiben ->Nein< *
tiff:	Skalierung und Qualität frei wählbar - Konvertierung ->Ja< überschreiben ->Nein< *
HEIC(optional): Wird immer verlustfrei nach *.png konvertiert.
*) Bei *.png *.tif und *.tiff ist beim überschreiben nur die Skalierung wirksam, eine Komprimierung mit der Qualitätseinstellung ist nicht wirksam.
