
proc pprint {grid {mask ""}} {} {
	loop y 0 8 {
		loop x 0 8 {
			set char [lindex $grid $x $y]
			set d { }
			if {$mask ne "" && $char eq $mask} {
				set d "*"
			}
			if {$mask eq "" & $char ne "0 0 0"} {
				set d "*"
			}
			puts -nonewline "$d "
		}
		puts ""
	}
}

