extends Node

var FINAL_SCORE: float

# Called when the node enters the scene tree for the first time.
func _ready():
	FINAL_SCORE = 0

func add_to_final_score(score: float):
	FINAL_SCORE += score
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
