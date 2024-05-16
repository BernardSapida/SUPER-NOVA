extends Area2D


export var speed = 10
export var reverse = false
export var player_detected = false



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	if player_detected:
		return null
	else:
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Dinosaur_body_entered(body):
	if body.name.find("Tile"):
		reverse = !reverse


func _on_DetectionRange_body_entered(body):
	if body.name.find("Nova"):
		player_detected = true


func _on_GroundDetect_body_exited(body):
	pass # Replace with function body.
