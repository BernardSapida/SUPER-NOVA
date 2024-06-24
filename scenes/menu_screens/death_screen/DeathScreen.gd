extends Control

onready var try_again = $TryAgain
onready var title = $Title
onready var home = $Home
onready var quit = $Quit
onready var transition = $Transition
onready var animation_player = $AnimationPlayer
onready var sound_player = $AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	SoundManager.play_clip(sound_player, SoundManager.SOUND_GAMEOVER)
	try_again.connect("pressed", self, "on_tryAgainButton_pressed")
	home.connect("pressed", self, "on_homeButton_pressed")
	quit.connect("pressed", self, "on_quitButton_pressed")


func on_tryAgainButton_pressed():
	sound_player.stop()
	title.hide()
	try_again.hide()
	home.hide()
	quit.hide()
	LevelManager.try_again()
	transition.transition_to("res://scenes/level"+str(LevelManager.CURRENT_LEVEL)+"/Level"+str(LevelManager.CURRENT_LEVEL)+".tscn")
	

func on_homeButton_pressed():
	sound_player.stop()
	title.hide()
	try_again.hide()
	home.hide()
	quit.hide()
	transition.transition_to("res://scenes/menu_screens/main_screen/MainScreen.tscn")

func on_quitButton_pressed():
	animation_player.play("quit")
	yield(animation_player, "animation_finished")
	get_tree().quit()
