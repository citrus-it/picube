
proc tcl::autocomplete {prefix} {
	if {[string match "* " $prefix]} {
		set cmd [string range $prefix 0 end-1]
		if {$cmd in {info tcl::prefix socket namespace array clock file package string dict signal history cube.colour cube.begin cube.commit cube.plane cube.text} || [info channel $cmd] ne ""} {
			# Add any results from -commands
			return [lmap p [$cmd -commands] {
				function "$cmd $p"
			}]
		}
	}
	if {[string match "source *" $prefix]} {
		set path [string range $prefix 7 end]
		return [lmap p [glob -nocomplain "${path}*"] {
			function "source $p"
		}]
	}
	# Find matching commands, omitting results containing spaces
	return [lmap p [lsort [info commands $prefix*]] {
		if {[string match "* *" $p]} {
			continue
		}
		function $p
	}]
}

