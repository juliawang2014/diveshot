extends Area2D

export var healing = 10
export var speed = 200

func _process(delta):
	position.y -= speed * delta

func _on_Health_body_entered(body):
	if body.name == "Player":
		body.heal(healing)
		call_deferred('free')


func _on_VisibilityNotifier2D_screen_exited():
	call_deferred('free')
