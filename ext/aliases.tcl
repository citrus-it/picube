
alias cube.color cube.colour
alias anim cube.anim
alias cube.shift cube.translate
alias cube.off cube.clear
alias led cube.led

proc cube.distance {x y} {
	return [cube.lookup -distance $x $y]
}

