# Bild verändern 2.22
Dieses Script funktioniert mit den Dateimanagern Nemo, Caja, Nautilus und Thunar.
Damit - Bild verändern - ordentlich arbeiten kann braucht es einige installierte Programme auf dem Rechner:

Damit - Bild verändern - ordentlich arbeiten kann braucht es einige installierte Programme auf dem Rechner:
- >Linux Mint Cinnamon< (bringt alles mit) ansonsten muss >Nemo< installiert sein.
- >ImageMagick< Softwarepaket zur Erstellung und Bearbeitung von Rastergrafiken.
- >yad< (Yet Another Dialog) ermöglicht das Erzeugen grafischer Dialoge.
- >libheif-example< um Apple HEIC Fotos zu konvertieren 

Die benötigten Scripte und Dateien für - Bild verändern - sind:
- >bildveraendern.sh< Programmscript
- >bildveraendern.nemo_action< zum einbinden und Steuerung des Scriptes in >Nemo<
- >xfce-action.txt< zum einbinden und Steuerung des Scriptes in >xfce<
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
Höhe=300, Breite=300 sind die Standardvorgaben damit wird das Programmfenster im kleinstmöglichen Format dargestellt.

Eine Einstellung von Höhe und Breite ist während der Installation möglich.

Betriebsarten

Nur beim Dateimanager -Nemo- steht -Bild veändern- in zwei Betriebsarten zur Verfügung

Dies ist zum einen die Betriebsart -action- und zum anderen die Betriebsart -script-.

Bei der Betriebsart -action- steht -Bild verändern- direkt im Kontextmenü  zur Verfügung. 

Bei der Betriebsart -script- muss -Bild verändern- über den Kontextmenüpunkt -Scripte- aufgerufen werden.

Für die Dateimanager: Caja, Nautilus und Thunar steht nur die Betriebsart -script-  zur Verfügung.

Aufruf von -Bild veändern- für die folgenden Dateimanager:

Caja - im Kontextmenü über -Scripte-

Nautilus - im Kontextmenü über -Scripte-

Thunar - direkt im Kontextmenü

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
