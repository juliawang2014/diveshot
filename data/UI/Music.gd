extends AudioStreamPlayer

onready var main_song = preload("res://assets/Sounds/TheWayDown.wav")
onready var beginning = preload("res://assets/Sounds/Beginning.wav")

var was_slowed = false
var times_entered = 0

func _ready():
	Globals.connect('changed_scene', self, 'change_music')
	change_music(Globals.current_level)

func _process(delta):
	if Engine.get_time_scale() == 1.0 and was_slowed:
		times_entered = 0
		stream_paused = false
		$Slow.stop()
	else:
		was_slowed = true
		stream_paused = true
		if times_entered == 0:
			times_entered += 1
			$Slow.play()

func change_music(part_of_stage):
	if part_of_stage == Globals.ledge:
		stream = beginning
	elif part_of_stage == Globals.game:
		stream = main_song
	play()
