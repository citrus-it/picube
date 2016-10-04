
proc bump_colour {{bump 30} {fc 0}} {{colour 0}} {
	if {!$bump} {
		set colour $fc
	} else {
		incr colour $bump
	}
	if {$colour > 189} { incr colour -190 }
	if {$colour < 0} { incr colour 189 }
	return [cube.colour $colour]
}

