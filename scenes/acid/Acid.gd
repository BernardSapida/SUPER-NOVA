extends Area2D

var damage = 20
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Acid_body_entered(body):
	if body.name == "Nova":
		var knockback_x_direction = (global_position.x - body.global_position.x)
		if knockback_x_direction >= 0:
			body.hit(-1, damage)
		else:
			body.hit(1, damage)
