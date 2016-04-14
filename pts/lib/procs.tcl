# PROCEDURES

proc uniqkey { } {
	set key   [ expr { pow(2,31) + [ clock clicks ] } ]
	set key   [ string range $key end-8 end-3 ]
	set key   [ clock seconds ]$key
	return $key
}

proc sleep { ms } {
	set uniq [ uniqkey ]
	set ::__sleep__tmp__$uniq 0
	after $ms set ::__sleep__tmp__$uniq 1
	vwait ::__sleep__tmp__$uniq
	unset ::__sleep__tmp__$uniq
}


proc PlayNotes {notes timing} {
	### puts "Playing a note with $note Hz."
	set snd [snack::sound]
	foreach note $notes {
		set f [snack::filter generator $note 30000 0.0 sine $timing]
		$snd play -filter $f -command "$f destroy"
		unset f
		sleep 1000
	}
}

proc PlayChord {notes timing} {
	if {[llength $notes] == 2} {
		set snd1 [snack::sound -channels 2]
		set leftmap [snack::filter map 1 0 0 0]
		set leftgenerator [snack::filter generator [lindex $notes 0] 20000 0.0 sine -1] ; # [expr $timing * 2]] 
		set leftfilter [snack::filter compose $leftgenerator $leftmap]

		set snd2 [snack::sound -channels 2]
		set rightmap [snack::filter map 0 0 0 1]
		set rightgenerator [snack::filter generator [lindex $notes 1] 20000 0.0 sine -1] ; # [expr $timing * 2]]
		set rightfilter [snack::filter compose $rightgenerator $rightmap]

		$snd1 play -filter $leftfilter ; #-command "$snd destroy; $f destroy"		
		$snd2 play -filter $rightfilter ; #-command "$snd destroy; $f destroy"
		
	} elseif {[llength $notes] == 3} {
		set snd1 [snack::sound -channels 2]
		set centermap [snack::filter map 1 0 0 1]
		set centergenerator [snack::filter generator [lindex $notes 0] 20000 0.0 sine -1] ; # [expr $timing * 2]] 
		set centerfilter [snack::filter compose $centergenerator $centermap]

		set snd2 [snack::sound -channels 2]
		set leftmap [snack::filter map 1 0 0 0]
		set leftgenerator [snack::filter generator [lindex $notes 1] 20000 0.0 sine -1] ; # [expr $timing * 2]]
		set leftfilter [snack::filter compose $leftgenerator $leftmap]

		
		set snd3 [snack::sound -channels 2]
		set rightmap [snack::filter map 0 0 0 1]
		set rightgenerator [snack::filter generator [lindex $notes 2] 20000 0.0 sine -1] ; # [expr $timing * 2]]
		set rightfilter [snack::filter compose $rightgenerator $rightmap]

		$snd1 play -filter $centerfilter ; #-command "$snd destroy; $f destroy"		
		$snd2 play -filter $leftfilter ; #-command "$snd destroy; $f destroy"		
		$snd3 play -filter $rightfilter ; #-command "$snd destroy; $f destroy"
	}
	
}

proc GetTemperedInterval {rootfreq halftones} {
	set multiplier [expr pow(2, (1.0/12))]
	return [format %.2f [expr $rootfreq * [expr pow($multiplier, $halftones)]]]
}

proc GetJustInterval {rootfreq halftones} {
	### http://www.phy.mtu.edu/~suits/scales.html
	switch $halftones {
		1 { return [expr 1.0417 * $rootfreq] }
		2 { return [expr 1.1250 * $rootfreq] }
		3 { return [expr 1.2000 * $rootfreq] }
		4 { return [expr 1.2500 * $rootfreq] }
		5 { return [expr 1.3333 * $rootfreq] }
		6 { return [expr 1.4063 * $rootfreq] }
		7 { return [expr 1.5000 * $rootfreq] }
		8 { return [expr 1.6000 * $rootfreq] }
		9 { return [expr 1.6667 * $rootfreq] }
		10 { return [expr 1.8000 * $rootfreq] }
		11 { return [expr 1.8750 * $rootfreq] }
		12 { return [expr 2.0 * $rootfreq] }
		default { return $rootfreq }
	}
}

proc GetPythagoreanInterval {rootfreq halftones} {
	### http://www.phy.mtu.edu/~suits/fifths.html
	switch $halftones {
		1 { return [expr 1.067871 * $rootfreq] }
		2 { return [expr 1.1250 * $rootfreq] }
		3 { return [expr 1.201355 * $rootfreq] }
		4 { return [expr 1.265625 * $rootfreq] }
		5 { return [expr 1.351524 * $rootfreq] }
		6 { return [expr 1.423828 * $rootfreq] }
		7 { return [expr 1.5000 * $rootfreq] }
		8 { return [expr 1.601807 * $rootfreq] }
		9 { return [expr 1.687500 * $rootfreq] }
		10 { return [expr 1.802032 * $rootfreq] }
		11 { return [expr 1.898438 * $rootfreq] }
		# The octave is wider !!!
		12 { return [expr 2.027286* $rootfreq] } 
		default { return $rootfreq }
	}
	
} 

proc GetTemperedFreq {note} {
    global notes   ; # list with C, C#, D, 
    set multiplier [expr pow(2, (1.0/12))]
    set aindex [lsearch $notes "A"]
    set noteindex [lsearch $notes $note]
    set difference [expr $noteindex - $aindex]
    return [format %.2f [expr 440.0 * [expr pow($multiplier, $difference)]]]
}

proc GetChordsNotes {basenote triad tunningtype} {
	set rootfreq [GetTemperedFreq $basenote]
	set finalnotes $rootfreq
	set command "Get[string totitle $tunningtype]Interval $rootfreq "
	if {$triad == "major"} {
		set halftones {4 7}
	} else {
		set halftones {3 7}
	}
	foreach hf $halftones {
		lappend finalnotes [eval "$command $hf"]
	}
	return $finalnotes
}

proc GetIntervalesNotes {basenote intervalname tunningtype} {
	set rootfreq [GetTemperedFreq $basenote]
	set command "Get[string totitle $tunningtype]Interval $rootfreq "
	switch $intervalname {
		2m { set finalcmd [lappend command 1]}
		2M {set finalcmd [lappend command 2]}
		3m {set finalcmd [lappend command 3]}
		3M {set finalcmd [lappend command 4]}
		4 {set finalcmd [lappend command 5]}
		4# {set finalcmd [lappend command 6]}
		5 {set finalcmd [lappend command 7]}
		6m {set finalcmd [lappend command 8]}
		6M {set finalcmd [lappend command 9]}
		7m {set finalcmd [lappend command 10]}
		7M {set finalcmd [lappend command 11]}
		8 {set finalcmd [lappend command 12]}
	}
	return "$rootfreq [eval $finalcmd]"
}

proc GetScalesNotes {basenote scaletype tunningtype} {
	set rootfreq [GetTemperedFreq $basenote]
	set command "Get[string totitle $tunningtype]Interval $rootfreq "
	set finalnotes $rootfreq
	if {$scaletype == "major"} {
		set halftones {2 4 5 7 9 11 12}
	} else {
		set halftones {2 3 5 7 8 10 12}
	}
	foreach hf $halftones {
			lappend finalnotes [eval "$command $hf"]
	}
	return $finalnotes
}

proc StopSound {} {
	snack::audio stop
}

proc StartSound {basenote module tunningtype moduletype noteduration mode} {
	snack::audio stop
	set notes [eval "Get[string totitle $module]Notes $basenote $moduletype $tunningtype"]	
	if {($module == "intervales" || $module == "chords") && $mode == "Armonic"} {
		PlayChord $notes $noteduration
	} else {
        PlayNotes $notes [expr $noteduration * 1000]
	}
}

proc TraceRootNote {varname args} {
    upvar #0 $varname var
    global rootnotefreq   ; # associated to .main.notes.rootnotefreq widget
    set rootnotefreq [GetTemperedFreq $var]
}

proc LoadModule {module font} {
    global moduletype 
    destroy .main.module
    frame .main.module -relief groove -border 2
    pack .main.module -side top -padx 5 -pady 5 -fill both
    message .main.module.msg -text "Type:" -font $font -width 100
    pack .main.module.msg -side left -padx 5 -pady 5 
    if {$module == "scales"} {
        foreach s {minor major} {
             radiobutton .main.module.$s -text "Diatonic $s scale" \
             -variable moduletype -font $font -value $s
             pack .main.module.$s -side right
        }        
        set moduletype major
    } elseif {$module == "intervales"} {
        tk_optionMenu .main.module.interval moduletype 3M 3m 5 4 6m 6M 7m 7M 2m 2M 4# 8
        pack .main.module.interval -side right
        set moduletype 3M
    } elseif {$module == "chords"} {
        foreach i {minor major} {
             radiobutton .main.module.$i -text "[string totitle $i] triad" \
             -variable moduletype -font $font -value $i
             pack .main.module.$i -side right
        }
        set moduletype major
    } else {
        puts "Unknown module !!!"
    }
}

proc TunningHelp {font} {
    destroy .help
    set w .help
    toplevel .help
    wm title .help {Pitch & Tunning Studio Help}
    frame .help.top
    pack .help.top -side top
    frame .help.bottom
    pack .help.bottom -side bottom
    scrollbar .help.top.scroll -command ".help.top.text yview"
    text .help.top.text -wrap word -width 60 -height 20 \
    -yscrollcommand ".help.top.scroll set"
    button .help.bottom.ok -text Ok -font $font -command {destroy .help} -width 10
    pack .help.top.scroll -side right -fill y
    pack .help.top.text -side top -fill both -padx 5 -pady 5 -expand yes
    pack .help.bottom.ok -side bottom -pady 5
    .help.top.text insert end {The 'Just Scale' (sometimes referred to as 'harmonic tuning' or 'Helmholtz's scale') occurs naturally as a result of the overtone series for simple systems such as vibrating strings or air columns. 
All the notes in the scale are related by rational numbers. 
Unfortunately, with Just tuning, the tuning depends on the scale you are using - the tuning for C Major is not the same as for D Major, for example. 
Just tuning is often used by ensembles (such as for choral or orchestra works) as the players match pitch with each other 'by ear.'

The 'equal tempered scale' was developed for keyboard instruments, such as the piano, so that they could be played equally well (or badly) in any key. 
It is a compromise tuning scheme. The equal tempered system uses a constant frequency multiple between the notes of the chromatic scale. 
Hence, playing in any key sounds equally good (or bad, depending on your point of view).

One can create a musical scale based solely on the 'fifth' and the octave. 
First, pick a starting pitch, now go up a fifth (multiply the frequency by 3/2), then go up another fifth and convert this back down an octave, go up a fifth from that - if the result is beyond the octave, go back down an octave. 
Scales based on this procedure were introduced by Pythagoras and can also be found in Chinese history.

Sources: 
http://www.phy.mtu.edu/~suits/scales.html
http://www.phy.mtu.edu/~suits/fifths.html
http://en.wikipedia.org/wiki/Mathematics_of_musical_scales
        
Credits:
Program written by David Asorey Álvarez (forodejazz@gmail.com)
http://davidasorey.net/static/pts/}}
