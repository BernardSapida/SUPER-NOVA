extends Area2D

export(
	String, 
	"Heart,Cloak,Shield,Rage,Speed,Fuel"
) var item = "Heart"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_GlowingOrb_body_entered(body):
	if body.name == "Nova":
		body.obtain_item(item)
		queue_free()
