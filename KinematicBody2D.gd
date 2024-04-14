extends KinematicBody2D

var score: int = 0
var fire_remaining: int = 0
var life_remaining: int = 0
var key = null
var is_recovered = true
var is_entering_door = false

export var speed: int = 200
export var jumpForce: int = 400
export var gravity: int = 400

var velocity: Vector2 = Vector2()
var fire_scene = preload("res://scenes/shot/Shot.tscn")

onready var current_level = int(get_tree().current_scene.name)
onready var ui = get_node("/root/Level" + str(current_level) + "/CanvasLayer/UI")
onready var animated_sprite = $AnimatedSprite
onready var animation_player = $AnimationPlayer
onready var jump_sound = $JumpSound
onready var laser_sound = $LaserSound
onready var dead_sound = $DeadSound
onready var power_up_sound = $PowerUpSound
onready var key_sound = $KeySound

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _physics_process(delta):
	velocity.x = 0
	
	if is_entering_door or animated_sprite.animation == "pick" or animated_sprite.animation == "dead":
		return null
		
	if Input.is_action_pressed("move_left"):
		move_left()
	elif Input.is_action_pressed("move_right"):
		move_right()
	elif is_on_floor():
		idle()
	
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		jump()
			
	velocity = move_and_slide(velocity, Vector2.UP)
	
	velocity.y += gravity * delta
	
	if velocity.x < 0:
		face_left()
	elif velocity.x > 0:
		face_right()
	
	attack()

func enter_door(x):
	if !is_on_floor():
		return
		
	is_entering_door = true
	position.x = x
	animated_sprite.play("goingin")
	animation_player.play("enter_door")

func idle():
	animated_sprite.play("idle")

func move_left():
	velocity.x -= speed
	
	if is_on_floor():
		animated_sprite.play("walking")
	else:
		animated_sprite.play("jump")

func move_right():
	velocity.x += speed
	
	if is_on_floor():
		animated_sprite.play("walking")
	else:
		animated_sprite.play("jump")

func jump():
	velocity.y -= jumpForce
	animated_sprite.play("jump")
	jump_sound.play()
	
func face_right():
	animated_sprite.flip_h = false

func face_left():
	animated_sprite.flip_h = true
	
func collect_coin(value):
	score += value
	ui.set_score_text(score)

func collect_key(key_color):
	key_sound.play()
	animated_sprite.play("pick")
	yield(get_tree().create_timer(.5), "timeout")
	animated_sprite.play("idle")
	ui.set_key(key_color)
	key = key_color

func collect_fire(value):
	fire_remaining += value
	ui.set_fire_remaining_text(fire_remaining)
	power_up_sound.play()
	
func collect_life(value):
	life_remaining += value
	ui.set_life_remaining_text(life_remaining)
	power_up_sound.play()

func get_key():
	return key

func reduce_life():
	if !is_recovered:
		return null
		
	life_remaining -= 1
	
	if life_remaining < 0:
		die()
		return null
	
	recover_player()

func recover_player():
	ui.set_life_remaining_text(life_remaining)
	
	is_recovered = false
	animation_player.play("recovering")
	yield(get_tree().create_timer(2), "timeout") 
	
	is_recovered = true

func die():
	dead_sound.play()
	animated_sprite.play("dead")
	yield(get_tree().create_timer(0.5), "timeout") 
	get_tree().reload_current_scene()
	
func attack():
	if fire_remaining <= 0:
		return null
	
	if Input.is_action_just_pressed("fire"):
		var fire_instance = fire_scene.instance()
		
		laser_sound.play()
		fire_instance.position = position
		
		if animated_sprite.flip_h:
			fire_instance.direction = Vector2(-1, 0)
		else:
			fire_instance.direction = Vector2(1, 0)
			
		get_parent().add_child(fire_instance)
		
		fire_remaining -= 1
		ui.set_fire_remaining_text(fire_remaining)
