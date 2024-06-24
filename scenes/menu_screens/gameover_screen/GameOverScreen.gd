extends Control

onready var play_again = $PlayAgain
onready var title = $Title
onready var final_score = $FinalScore
onready var home = $Home
onready var quit = $Quit
onready var transition = $Transition
onready var animation_player = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	play_again.connect("pressed", self, "on_playAgainButton_pressed")
	home.connect("pressed", self, "on_homeButton_pressed")
	quit.connect("pressed", self, "on_quitButton_pressed")
	final_score.text = str(ScoreCounter.FINAL_SCORE)

func on_playAgainButton_pressed():
	title.hide()
	final_score.hide()
	play_again.hide()
	home.hide()
	quit.hide()
	LevelManager.try_again()
	transition.transition_to("res://scenes/level1/Level1.tscn")
	

func on_homeButton_pressed():
	title.hide()
	final_score.hide()
	play_again.hide()
	home.hide()
	quit.hide()
	transition.transition_to("res://scenes/menu_screens/main_screen/MainScreen.tscn")

func on_quitButton_pressed():
	animation_player.play("quit")
	yield(animation_player, "animation_finished")
	get_tree().quit()
