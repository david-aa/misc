/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package net.davidasorey.j2me;

import java.io.InputStream;
import java.util.TimerTask;
import javax.microedition.media.Manager;
import javax.microedition.media.Player;

/**
 *
 * @author David Asorey Álvarez
 */
class ClickPlayer extends TimerTask {
    Player p;
    public ClickPlayer(String archivo) {
        try {
            InputStream in = getClass().getResourceAsStream(archivo);
            p = Manager.createPlayer(in, "audio/mpeg");
            p.prefetch();
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }
    
    public void run() {
        try {
            p.start();
            //System.out.println(Calendar.getInstance().toString());
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }
}


