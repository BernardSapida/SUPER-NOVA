extends Area2D

onready var current_level = int(get_tree().current_scene.name)
onready var animated_sprite = $AnimatedSprite
onready var boss_room = get_node("/root/Level"+str(current_level)+"/BossRoom")
onready var animation_player = $AnimationPlayer
onready var transition = get_node("/root/Level"+str(current_level)+"/CanvasLayer/Transition")
var active: bool = false

export var is_portal = false

func _ready():
	match current_level:
		1:
			if is_portal:
				animated_sprite.play("gray")
			else:
				animated_sprite.play("green")
		2:
			if is_portal:
				animated_sprite.play("yellow")
			else:
				animated_sprite.play("gray")
		3:
			if is_portal:
				animated_sprite.play("red")
			else:
				animated_sprite.play("yellow")
		4:
			if is_portal:
				animated_sprite.play("rainbow")
			else:
				animated_sprite.play("red")
	
	if is_portal:
		self.modulate = "00ffffff"
		monitoring = false

func _process(_delta):
	if LevelManager.CURRENT_LEVEL == 4:
		if boss_room.get_child(2).get_child_count() == 0:
			animation_player.play("appear")
			yield(animation_player, "animation_finished")
			active = true
			monitoring = true
			set_process(false)
	else:
		if boss_room.get_child_count() <= 2:
			animation_player.play("appear")
			yield(animation_player, "animation_finished")
			active = true
			monitoring = true
			set_process(false)

func _on_Portal_body_entered(_body):
	if not active:
		return
	LevelManager.level_cleared()
	get_tree().paused = true
	if current_level != 4:
		transition.transition_to("res://scenes/menu_screens/next_level_screen/NextLevelScreen.tscn")
	else:
		transition.transition_to("res://scenes/menu_screens/gameover_screen/GameOverScreen.tscn")
