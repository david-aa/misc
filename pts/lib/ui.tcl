if {$tcl_platform(platform) == "unix"} {
    set font {Lucida 10}
} else {
    set font {Tahoma 8} 
}

# BUILDING THE UI

frame .main -relief groove -border 2
pack .main -padx 5 -pady 5 -fill both

    frame .main.tunning -relief groove -border 2
    pack .main.tunning -side top -padx 5 -pady 5 -fill both

        frame .main.tunning.up -border 5
        pack .main.tunning.up -side top -fill both

            message .main.tunning.up.msg -text "Select a tunning system:" \
            -width 300 -font $font
            button .main.tunning.up.help -text "Help" -font $font \
            -command {TunningHelp $font} -width 10
            pack .main.tunning.up.msg -side left
            pack .main.tunning.up.help -side right

        frame .main.tunning.down -border 5
        pack .main.tunning.down -side bottom -fill both

            foreach tun {pythagorean just tempered} {
                radiobutton .main.tunning.down.$tun -text [string totitle $tun] \
                                                           -variable tunning \
                                                           -value $tun -font $font
                pack .main.tunning.down.$tun -side left
            }
            button .main.tunning.down.quit -text "Exit" -command {exit} \
                                           -font $font -width 10
            pack .main.tunning.down.quit -side right


    frame .main.notes -relief groove -border 2
    pack .main.notes -side top -fill both  -padx 5 -pady 5
		
		frame .main.notes.left
		pack .main.notes.left -side left -fill both  -padx 5 -pady 5
        
			message .main.notes.left.msg -text "Root note:" -font $font -width 100
	        tk_optionMenu .main.notes.left.rootnote rootnote C C# D Eb E F F# G G# A Bb B
			message .main.notes.left.rootnotefreq -textvar rootnotefreq \
	                                 -font $font -border 2 -relief groove -width 100
			pack .main.notes.left.msg -side left -padx 5 -pady 5
			pack .main.notes.left.rootnotefreq -side right -padx 5 -pady 5
			pack .main.notes.left.rootnote -side right
		
		frame .main.notes.right
		pack .main.notes.right -side left -fill both  -padx 5 -pady 5

			message .main.notes.right.msg -text "Note duration:" -font $font -width 100
			pack .main.notes.right.msg -side left -padx 5 -pady 5
			spinbox .main.notes.right.noteduration -from 1 -to 50 -textvariable noteduration -width 5
			pack .main.notes.right.noteduration -side left
   			set noteduration 10
			message .main.notes.right.msg2 -text "Mode (intervals & chords):" -font $font -width 200
			pack .main.notes.right.msg2 -side left -padx 5 -pady 5
            tk_optionMenu .main.notes.right.mode mode Melodic Armonic
			pack .main.notes.right.mode -side left
			set mode Armonic

    
    frame .main.player -relief groove -border 2
    pack .main.player -side top -fill both  -padx 5 -pady 5

        button .main.player.start -text "Start" -font $font -width 10 
        button .main.player.stop -text "Stop" -font $font -width 10
        message .main.player.msg -text "Select a module:" -font $font -width 300
        pack .main.player.start -side left -padx 5 -pady 5
        pack .main.player.stop -side left -padx 5 -pady 5
        foreach mod {chords intervales scales} {
            radiobutton .main.player.$mod -text [string totitle $mod] -variable module \
                                            -value $mod -font $font \
                                            -command {LoadModule $module $font}
            pack .main.player.$mod -side right
        }
        pack .main.player.msg -side right -padx 5 -pady 5
		if {![info exists interval]} {
			# We need a variable called "interval" (only available
			# in module intervals.
			set interval ""
		}
        .main.player.start configure \
                    -command {StartSound $rootnote $module $tunning $moduletype $noteduration $mode}
        .main.player.stop configure -command StopSound

wm title . "Pitch & Tunning Studio"
