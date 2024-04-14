extends Area2D

var direction = Vector2.ZERO
var speed = 400
var shot_color = "Green"

onready var shot = $AnimatedShot

# Called when the node enters the scene tree for the first time.
func _ready():
	match shot_color:
		"Green":
			shot.play("GreenShot")
		"Blue":
			shot.play("BlueShot")
		"Violet":
			shot.play("VioletShot")
		"Red":
			shot.play("RedShot")
		"Rage":
			shot.play("RageShot")
	pass # Replace with function body.

func set_shot_color(color: String):
	shot_color = color

func _process(delta):
	position += direction.normalized() * speed * delta
	
	if direction.normalized().x == 1:
		shot.flip_h = false
	else:
		shot.flip_h = true

func _on_Shot_body_entered(body):
	if body.name.find("Tile"):
		queue_free()
