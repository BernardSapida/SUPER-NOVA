extends Area2D

export var value = 1

var is_collected: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_collected:
		position.y -= 150 * .01

func _on_Coin_body_entered(body):
	if body.name == "Nova" and !is_collected:
		is_collected = true
#		animation.play("fade")
#		coin_sound.play()
		body.collect_coin(value)
		yield(get_tree().create_timer(0.3), "timeout") 
		queue_free()
