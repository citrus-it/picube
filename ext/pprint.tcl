
proc pprint {grid {mask ""}} {} {
	foreach col $grid {
		foreach char $col {
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

