# COMMON DATA
set notes {C C# D Eb E F F# G G# A Bb B}
foreach n $notes {
    set arrayfreqs($n) [GetTemperedFreq $n]
}
#~ puts [array get arrayfreqs]

# Default module
set module scales
LoadModule $module $font
# Default tunning
set tunning tempered
# Default root note
trace add variable rootnote write "TraceRootNote rootnote"
set rootnote C
