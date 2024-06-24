extends Node

var DIFFICULTY: float
var CURRENT_LEVEL: int = 1
var current_points: float
var is_player_in_boss_room: bool = false


const EASY: float = 0.8
const NORMAL: float = 1.0
const HARD: float = 1.2

# Called when the node enters the scene tree for the first time.
func _ready():
	DIFFICULTY = HARD
	
func player_entered_boss_room():
	is_player_in_boss_room = true

func try_again():
	current_points = 0
	set_difficulty()
	
func set_difficulty():
	match DIFFICULTY:
		HARD:
			DIFFICULTY = NORMAL
		NORMAL:
			DIFFICULTY = EASY
		EASY:
			DIFFICULTY = EASY

func reset_difficulty():
	DIFFICULTY = HARD
	
func add_current_points(points: int):
	current_points += points
	
func level_cleared():
	ScoreCounter.add_to_final_score(current_points)
	current_points =  0
	
	if CURRENT_LEVEL < 4:
		CURRENT_LEVEL += 1
		
	reset_difficulty()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
