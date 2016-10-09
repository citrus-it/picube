
set tcl::autocomplete_commands {info tcl::prefix socket namespace array clock file package string dict signal history cube.colour cube.begin cube.commit cube.plane cube.text cube.anim anim}

proc tcl::autocomplete {prefix} {
	if {[set space [string first " " $prefix]] != -1} {
		set cmd [string range $prefix 0 $space-1]
		if {$cmd in $::tcl::autocomplete_commands || [info channel $cmd] ne ""} {
			set arg [string range $prefix $space+1 end]
			return [lmap p [$cmd -commands] {
				if {![string match "${arg}*" $p]} continue
				function "$cmd $p"
			}]
		}
	}

	# Find matching files.
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

