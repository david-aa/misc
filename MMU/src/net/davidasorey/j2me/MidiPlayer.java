/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package net.davidasorey.j2me;
import javax.microedition.media.Manager;
import javax.microedition.media.MediaException;
/**
 *
 * @author David Asorey Álvarez
 */
public class MidiPlayer {
    static int DURACION = 1500;
    static int VOLUMEN = 100;
    static int calcularMidiNote (String note, int octave) {
        int base = 0;
        if (note.equals("C"))
                base = 48;
        else if (note.equals("C#") || (note.equals("Db")))
                base = 49;
        else if (note.equals("D"))
                base = 50;
        else if (note.equals("D#") || (note.equals("Eb")))
                base = 51;
        else if (note.equals("E"))
                base = 52;
        else if (note.equals("F"))
                base = 53;
        else if (note.equals("F#") || (note.equals("Gb")))
                base = 54;
        else if (note.equals("G"))
                base = 55;
        else if (note.equals("G#") || (note.equals("Ab")))
                base = 56;
        else if (note.equals("A"))
                base = 57;
        else if (note.equals("A#") || (note.equals("Bb")))
                base = 58;
        else if (note.equals("B"))
                base = 59;
        
        return base + (12*octave);        
    }
    public static void playNote(String note, int octave) throws MediaException {
        int midinote = calcularMidiNote (note, octave);
        Manager.playTone(midinote, DURACION, VOLUMEN);
    }
    
}
