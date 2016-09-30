
proc bump_colour {{bump 30}} {{colour 0}} {
	incr colour $bump
	if {$colour > 189} { incr colour -190 }
	if {$colour < 0} { incr colour 189 }
	return [cube.colour $colour]
}

