extends Area2D

onready var current_level = int(get_tree().current_scene.name)
onready var nova = get_node("/root/Level"+str(current_level)+"/Nova")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x = nova.position.x-50

func _on_DeadEnd_body_entered(body):
	if body.name == "Nova":
		body.die()
