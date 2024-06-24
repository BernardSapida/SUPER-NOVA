extends Control

onready var continue_button = $Continue
onready var title = $Title
onready var home = $Home
onready var quit = $Quit
onready var transition = $Transition
onready var animation_player = $AnimationPlayer
onready var level_scene = get_node("/root/Level" + str(LevelManager.CURRENT_LEVEL))
onready var parallax_bg = get_node("/root/Level" + str(LevelManager.CURRENT_LEVEL) + "/ParallaxBackground")
onready var ui = get_node("/root/Level" + str(LevelManager.CURRENT_LEVEL) + "/CanvasLayer/UI")
# Called when the node enters the scene tree for the first time.
func _ready():
	continue_button.connect("pressed", self, "on_continueButton_pressed")
	home.connect("pressed", self, "on_homeButton_pressed")
	quit.connect("pressed", self, "on_quitButton_pressed")
	
	
	pause_mode = Node.PAUSE_MODE_PROCESS
	
func _input(event):
	if Input.is_action_just_pressed("ui_cancel"):
		if not self.is_visible_in_tree():
			self.show()
			get_tree().paused = true
		else:
			self.hide()
			get_tree().paused = false


func on_continueButton_pressed():
	self.hide()
	get_tree().paused = false


func on_homeButton_pressed():
	title.hide()
	continue_button.hide()
	home.hide()
	quit.hide()
	get_tree().paused = false	
	transition.transition_to("res://scenes/menu_screens/main_screen/MainScreen.tscn")

func on_quitButton_pressed():
	level_scene.hide()
	parallax_bg.hide()
	ui.hide()
	animation_player.play("quit")
	yield(animation_player, "animation_finished")
	get_tree().quit()
