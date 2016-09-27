
proc pprint {grid {mask ""}} {} {
	foreach line $grid {
		foreach char $line {
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

