extends Area2D

var touched: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _on_ThornyVines_body_entered(body):
	if body.name == "Nova" and not body.is_unvulnerable:
		touched = true
		body.reduce_speed()
	
		while touched:
			body.reduce_life(1)
			if body.health <= 0:
				return
			yield(get_tree().create_timer(2), "timeout")

func _on_ThornyVines_body_exited(body):
	if body.name == "Nova":
		touched = false
		body.restore_speed()
