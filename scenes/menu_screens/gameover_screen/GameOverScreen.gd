extends Control

onready var title = $Title
onready var score = $Score
onready var home = $Home
onready var quit = $Quit
onready var transition = $Transition
onready var animation_player = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	home.connect("pressed", self, "on_homeButton_pressed")
	quit.connect("pressed", self, "on_quitButton_pressed")
	score.text = "SCORE: " + str(ScoreCounter.FINAL_SCORE)

func on_homeButton_pressed():
	title.hide()
	score.hide()
	home.hide()
	quit.hide()
	transition.transition_to("res://scenes/menu_screens/main_screen/MainScreen.tscn")

func on_quitButton_pressed():
	animation_player.play("quit")
	yield(animation_player, "animation_finished")
	get_tree().quit()
