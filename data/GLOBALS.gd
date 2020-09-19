extends Node

var break_pattern = {'big' : 'small', 'small': null}

func pause():
	get_tree().paused = true

func unpause():
	get_tree().paused = false
