# Bild verändern 2.24
Dieses Script funktioniert mit den Dateimanagern Nemo, Caja, Nautilus und Thunar.

Damit - Bild verändern - ordentlich arbeiten kann braucht es einige installierte Programme auf dem Rechner:
- **ImageMagick** Softwarepaket zur Erstellung und Bearbeitung von Rastergrafiken.
- **yad** (Yet Another Dialog) ermöglicht das Erzeugen grafischer Dialoge.
- **img2pdf** zum erzeugen von PDF-Dateien
- **libheif-example** um Apple HEIC Fotos zu konvertieren


Die benötigten Scripte und Dateien für - Bild verändern - sind:

- **bildveraendern.sh** Programmscript
- **bildveraendern.nemo_action** zum einbinden und Steuerung des Scriptes in >Nemo<
- **xfce-action.txt** zum einbinden und Steuerung des Scriptes in >xfce<
- **install.sh** zum installieren des Programms
- **inst_cmd.sh** das eigentliche Installationscript
- **Thema** in diesem Ordner sind GTK-Themen für das Programmscript.

Nach dem Download von Github müssen die Scripe noch ausführbar gemacht werden
Im Terminal:

_chmod +x bildveraendern.sh install.sh inst_cmd.sh_

Für die Installation liegt dem gepacktem Paket eine >install.sh< bei, mit dieser ist die Installation schnell erledigt.
Auch eine >Deinstallation< ist damit möglich.
Das Script entweder im Terminal oder mit doppelklick & ausführen starten.
Unter >xfce< muss die >install.sh< im Terminal gestartet werden:

_./install.sh_

Sollte die Installation nicht starten ist eventuell das Terminalprogramm nicht mit dem Desktop kompatibel.
In diesem Fall kann die Installation, unter jedem Desktop, mit folgendem Befehl gestartet werden:

_./install.sh -simple_

Das Script führt durch die Installation und die Schritte sind selbsterklärend.
Eine manuellen Installation ist nicht möglich!

**Folgende Einstellungen können während der Installation festgelegt werden:**

Fehlende externe Programm können während der Installation installiert werden.

**Höhe und Breite anpassen**

Bei einigen Themen und einer größeren Schrift kann es zu Problemen mit der Darstellung kommen. Dann müssen Höhe und Breite des Programmfensters angepasst werden
Höhe=300, Breite=300 sind die Standardvorgaben damit wird das Programmfenster im kleinstmöglichen Format dargestellt.

**Festlegen der Position des Programmfensters**

Wird >Bild verändern< über das Kontextmenü aufgerufen kann die Position des Programmfenster festgelegt werden.
Es besteht die Möglichkeit das Programmfenster an der Mausposition oder in der Bildschirmmitte zu platzieren

**Festlegen der Betriebsart**
 
Die Betriebsart >action< oder >script< wird während der Installation festgelegt. 
Folgende Betriebsarten können gewählt werden:

Nemo:		action		script

Caja:				    script

Nautilus:			    script

Thunar:			        script

Betriebsarten:

Nur beim Dateimanager -Nemo- steht -Bild veändern- in zwei Betriebsarten zur Verfügung
Dies ist zum einen die Betriebsart -action- und zum anderen die Betriebsart -script-.
Bei der Betriebsart -action- steht -Bild verändern- direkt im Kontextmenü  zur Verfügung. 
Bei der Betriebsart -script- muss -Bild verändern- über den Kontextmenüpunkt -Scripte- aufgerufen werden.
Für die Dateimanager: Caja, Nautilus und Thunar steht nur die Betriebsart -script-  zur Verfügung .
Aufruf von -Bild veändern- für die folgenden Dateimanager:

Caja - im Kontextmenü über -Scripte-

Nautilus - im Kontextmenü über -Scripte-

Thunar - direkt im Kontextmenü

Die Betriebsarten sind in ihrer Funktionalität völlig gleichwertig.

**Verwendung**
Aufruf des Programms, es können eine oder mehrere Bilddateien unterschiedlicher Formate im Dateimanager markiert werden. Nach betätigen der >rechten Maustaste< ist - Bild verändern - im Kontextmenü direkt oder über Scripte auswählbar.


