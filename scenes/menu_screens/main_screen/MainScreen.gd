extends Control

onready var start = $Start
onready var quit = $Quit
onready var animation_player = $AnimationPlayer
onready var transition = $Transition
onready var title = $Title

# Called when the node enters the scene tree for the first time.
func _ready():
	start.connect("pressed", self, "on_startButton_pressed")
	quit.connect("pressed", self, "on_quitButton_pressed")
	transition.hide()
	
	yield(animation_player, "animation_finished")

func on_startButton_pressed():
	#get_tree().change_scene("res://scenes/level1/Level1.tscn")
	transition.show()
	start.hide()
	quit.hide()
	title.hide()
	LevelManager.CURRENT_LEVEL = 1
	transition.transition_to("res://scenes/level1/Level1.tscn")
	
func on_quitButton_pressed():
	animation_player.play("quit")
	yield(animation_player, "animation_finished")
	get_tree().quit()
	
