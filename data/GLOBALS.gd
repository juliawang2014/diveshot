extends Node

var break_pattern = {'big' : 'small', 'small': null}
var stages = ["res://data/Stages/Ledge.tscn",
			"res://data/Stages/Main.tscn"]
var current_level = 0

var ledge = 0
var game = 1
var deadzone = 0.2

var player_color = Color(1.0,1.0,1.0,1.0)

signal changed_scene

func _ready():
	Pause.connect('new_color', self, '_store_color')

func pause():
	get_tree().paused = true

func unpause():
	get_tree().paused = false

func next_level():
	current_level += 1
	if current_level < stages.size():
		emit_signal("changed_scene", current_level)
		get_tree().change_scene(stages[current_level])

func _store_color(new_color):
	player_color = new_color
		
