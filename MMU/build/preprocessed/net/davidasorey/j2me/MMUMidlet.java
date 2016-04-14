/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package net.davidasorey.j2me;

import java.util.Timer;
import javax.microedition.media.MediaException;
import javax.microedition.midlet.*;
import javax.microedition.lcdui.*;

/**
 * @author david
 */
public class MMUMidlet extends MIDlet implements CommandListener {
    Display pantalla;
    List menu0;
    List menuInstruments;
    TextBox textoTempo;
    List menuGuitar;
    List menuBass;
    List menuCelloViola;
    List menuViolin;
    List menu6Bass;
    List menuChrom;
    Command salir;
    Command atras;
    Command startstop;
    boolean tocadoractivo = false;
    Timer timer = null;
    String[] guitTunnings = {"E 1", "A 1", "D 2", "G 2", "B 2", "E 3"};
    String[] bassTunnings = {"E 1", "A 1", "D 2", "G 2"};
    String[] celloviolaTunnings = {"C 1", "G 1", "D 2", "A 2"};
    String[] violinTunnings = {"G 1", "D 2", "A 2", "E 3"};
    String[] bass6Tunnings = {"B 0", "E 1", "A 1", "D 2", "G 2", "C 3"};
    String[] chromTunnings = {"C 1", "Db 1", "D 1", "Eb 1", "E 1", "F 1",
        "F# 1", "G 1", "G# 1", "A 1", "Bb 1", "B 1"
    };
    ClickPlayer player;

    public MMUMidlet() {

        // Constantes
        String[] etiquetas0 = {
            "Tuner",
            "Metronome"
        };
        String[] etiquetasInstrumentos = {
            "Guitar",
            "Bass (up/el)",
            "Cello/Viola",
            "Violin",
            "5/6 string bass",
            "Chromatic"
        };
        pantalla = Display.getDisplay(this);
        try {
            Image[] imagenes0 = {
                Image.createImage("/diapason.png"),
                Image.createImage("/metronomo.png")
            };
            Image[] imagenes1 = {
                Image.createImage("/guitar.png"),
                Image.createImage("/dbass.png"),
                Image.createImage("/cello.png"),
                Image.createImage("/violin.png"),
                Image.createImage("/6bass.png"),
                Image.createImage("/diapason.png")
            };

            // Pantallas
            menu0 = new List("Choose a tool", List.IMPLICIT, etiquetas0, imagenes0);
            menuInstruments = new List("Choose your instrument", List.IMPLICIT, etiquetasInstrumentos, imagenes1);
            menuGuitar = new List("Guitar", List.IMPLICIT, cleanTunnings(guitTunnings), null);
            menuBass = new List("Bass (Upright/Electric)", List.IMPLICIT, cleanTunnings(bassTunnings), null);
            menuCelloViola = new List("Cello/Viola", List.IMPLICIT, cleanTunnings(celloviolaTunnings), null);
            menuViolin = new List("Violin", List.IMPLICIT, cleanTunnings(violinTunnings), null);
            menu6Bass = new List("5/6 String Bass", List.IMPLICIT, cleanTunnings(bass6Tunnings), null);
            menuChrom = new List("Chromatic", List.IMPLICIT, cleanTunnings(chromTunnings), null);
            textoTempo = new TextBox("Set the tempo", "120", 3, TextField.NUMERIC);

        } catch (Exception ex) {
            ex.printStackTrace();
        }
        atras = new Command("Back", Command.BACK, 1);
        salir = new Command("Exit", Command.EXIT, 1);
        startstop = new Command("PlayStop", Command.SCREEN, 1);

        menu0.addCommand(salir);
        menuInstruments.addCommand(salir);
        menuInstruments.addCommand(atras);
        textoTempo.addCommand(startstop);
        textoTempo.addCommand(atras);
        menuGuitar.addCommand(atras);
        menuBass.addCommand(atras);
        menuCelloViola.addCommand(atras);
        menuViolin.addCommand(atras);
        menu6Bass.addCommand(atras);
        menuChrom.addCommand(atras);

        menu0.setCommandListener(this);
        menuInstruments.setCommandListener(this);
        textoTempo.setCommandListener(this);
        menuGuitar.setCommandListener(this);
        menuBass.setCommandListener(this);
        menuCelloViola.setCommandListener(this);
        menuViolin.setCommandListener(this);
        menu6Bass.setCommandListener(this);
        menuChrom.setCommandListener(this);

    }

    public void startApp() {
        pantalla.setCurrent(menu0);
    }

    public void pauseApp() {
    }

    public void destroyApp(boolean unconditional) {
    }

    String[] cleanTunnings(String[] tunnings) {
        int nelemens = tunnings.length;
        String[] retVal = new String[nelemens];
        for (int i = 0; i < nelemens; i++) {
            retVal[i] = tunnings[i].substring(0, tunnings[i].indexOf(" "));
        }
        return retVal;
    }

    public void commandAction(Command c, Displayable d) {
        if (c == salir) {
            destroyApp(false);
            notifyDestroyed();
        } else if (c == atras) {
            if (d.equals(menuInstruments) || d.equals(textoTempo)) {
                pantalla.setCurrent(menu0);
                if (timer != null)
                    timer.cancel();
            } else {
                pantalla.setCurrent(menuInstruments);
            }
        } else {
            if (d.equals(menu0) && c == List.SELECT_COMMAND) {
                switch (menu0.getSelectedIndex()) {               //opcion del menu
                    case 0: {
                        pantalla.setCurrent(menuInstruments);
                        break;
                    }
                    case 1: {
                        pantalla.setCurrent(textoTempo);
                        break;
                    }
                }
            } else if (d.equals(textoTempo)) {
                player = null;
                int tempo = 120;
                try {
                    tempo = Integer.parseInt(textoTempo.getString());
                } catch (Exception e) {
                    textoTempo.setString("120");
                    tempo = 120;
                }
                if (tempo < 30 || tempo > 300) {
                    Alert aviso = new Alert("Bad value", "You must set a tempo in the range 30 - 300", null, AlertType.ERROR);
                    aviso.setTimeout(Alert.FOREVER);
                    textoTempo.setString("120");
                    tocadoractivo = false;
                    if (timer != null) timer.cancel();
                    pantalla.setCurrent(aviso);
                } else {
                    int ms = (int)(60000/tempo);
                    if (!tocadoractivo) {
                        player = new ClickPlayer("/click.mp3");
                        timer = new Timer();
                        timer.scheduleAtFixedRate(player, 0, ms);
                        tocadoractivo = true;
                    } else {
                        if (timer != null) timer.cancel();
                        tocadoractivo = false;
                    }
                }
            } else if (d.equals(menuInstruments) && c == List.SELECT_COMMAND) {
                switch (menuInstruments.getSelectedIndex()) {               //opcion del afinador

                    case 0: {
                        pantalla.setCurrent(menuGuitar);
                        break;
                    }
                    case 1: {
                        pantalla.setCurrent(menuBass);
                        break;
                    }
                    case 2: {
                        pantalla.setCurrent(menuCelloViola);
                        break;
                    }
                    case 3: {
                        pantalla.setCurrent(menuViolin);
                        break;
                    }
                    case 4: {
                        pantalla.setCurrent(menu6Bass);
                        break;
                    }
                    case 5: {
                        pantalla.setCurrent(menuChrom);
                        break;
                    }
                }
            } else {
                String[] tunnings = null;
                if (d.equals(menuGuitar)) {
                    tunnings = guitTunnings;
                } else if (d.equals(menuBass)) {
                    tunnings = bassTunnings;
                } else if (d.equals(menuCelloViola)) {
                    tunnings = celloviolaTunnings;
                } else if (d.equals(menuViolin)) {
                    tunnings = violinTunnings;
                } else if (d.equals(menu6Bass)) {
                    tunnings = bass6Tunnings;
                } else if (d.equals(menuChrom)) {
                    tunnings = chromTunnings;
                }
                if (tunnings != null) {
                    int selected = ((List) d).getSelectedIndex();
                    String noteoctave = tunnings[selected];
                    String note = noteoctave.substring(0, noteoctave.indexOf(" "));
                    try {
                        int octave = Integer.parseInt(noteoctave.substring(noteoctave.indexOf(" ") + 1));
                        MidiPlayer.playNote(note, octave);
                    } catch (MediaException ex) {
                        Alert a = new Alert("Error: " + ex.getMessage());
                        pantalla.setCurrent(a);
                    }
                }
            }
        }
    }
}

