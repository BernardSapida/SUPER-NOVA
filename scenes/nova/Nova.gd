extends KinematicBody2D

var score: int = 0
var health: float = 100
var fuel: float = 100
var is_raging: bool = false
var is_unvulnerable: bool = false

# Nova items
var heart_item = 0
var cloak_item = 0
var shield_item = 0
var rage_item = 0
var speed_item = 0
var fuel_item = 0

export var rocket_burst: int = 200
export var damage: int = 10
export var speed: int = 120
export var jumpForce: int = 300
export var gravity: int = 400
export var is_boosted: bool = false

var velocity: Vector2 = Vector2()
var shot_scene = preload("res://scenes/shot/Shot.tscn")

onready var current_level = int(get_tree().current_scene.name)
onready var ui = get_node("/root/Level" + str(current_level) + "/CanvasLayer/UI")
onready var animated_sprite = $AnimatedSprite
onready var animated_gun = animated_sprite.get_node("AnimatedGun")
onready var animation_player = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _process(delta):
	regen_fuel()
	regen_health()

func _physics_process(delta):
	velocity.x = 0
	
	if animated_sprite.animation == "dead":
		return null
		
	if Input.is_action_pressed("ui_left"):
		move_left()
	elif Input.is_action_pressed("ui_right"):
		move_right()
	elif is_on_floor():
		idle()
	
	if Input.is_action_just_pressed("heart_item"):
		use_heart_item()
		
	if Input.is_action_just_pressed("cloak_item"):
		use_cloak_item()
		
	if Input.is_action_just_pressed("shield_item"):
		use_shield_item()
	
	if Input.is_action_just_pressed("rage_item"):
		use_rage_item()
	
	if Input.is_action_just_pressed("speed_item"):
		use_speed_item()
		
	if Input.is_action_just_pressed("fuel_item"):
		use_fuel_item()
	
	if Input.is_action_pressed("rocket"):
		fly(delta)
	
	if is_on_floor() and Input.is_action_just_pressed("ui_up"):
		jump()

	velocity = move_and_slide(velocity, Vector2.UP)
	
	velocity.y += gravity * delta
	
	if velocity.x < 0:
		face_left()
	elif velocity.x > 0:
		face_right()
	
	attack()
	sync_gun()

func use_heart_item():
	if heart_item <= 0:
		return null
	
	if health < 50:
		health += 50
	else:
		health = 100
	
	heart_item -= 1
	ui.reduce_item("Heart")
	
func use_cloak_item():
	if cloak_item <= 0:
		return null
	
	cloak_item -= 1
	ui.reduce_item("Cloak")
	
	animation_player.play("invinsible")
	
func use_shield_item():
	if shield_item <= 0:
		return null
	
	shield_item -= 1
	ui.reduce_item("Shield")
	animation_player.play("Barrier")
	
	is_unvulnerable = true
	yield(get_tree().create_timer(10), "timeout") 
	is_unvulnerable = false
	
func use_rage_item():
	if rage_item <= 0:
		return null
	
	rage_item -= 1
	ui.reduce_item("Rage")
	
	damage = 20
	is_raging = true
	yield(get_tree().create_timer(10), "timeout") 
	damage = 10
	is_raging = false
	
func use_speed_item():
	if speed_item <= 0:
		return null
	
	speed_item -= 1
	ui.reduce_item("Speed")
	
	is_boosted = true
	speed = 200
	yield(get_tree().create_timer(10), "timeout") 
	is_boosted = false
	speed = 120

func use_fuel_item():
	if fuel_item <= 0:
		return null
	
	if fuel < 75:
		fuel += 25
	else:
		fuel = 100

	fuel_item -= 1
	ui.reduce_item("Fuel")
	ui.set_fuel(fuel)

func regen_fuel():
	if fuel < 100:
		fuel += .001
		ui.set_fuel(fuel)

func regen_health():
	if health < 100:
		health += .001
		ui.set_health(health)

func obtain_item(item: String):
	match item:
		"Heart":
			heart_item += 1
		"Cloak":
			cloak_item += 1
		"Shield":
			shield_item += 1
		"Rage":
			rage_item += 1
		"Speed":
			speed_item += 1
		"Fuel":
			fuel_item += 1
	
	ui.add_item(item)
	
func reduce_speed():
	speed = 30

func restore_speed():
	if is_boosted:
		speed = 200
	else:
		speed = 120

func enter_door(x):
	if !is_on_floor():
		return
		
	position.x = x
#	animated_sprite.play("goingin")
#	animation_player.play("enter_door")

func idle():
	animated_sprite.play("idle")

func move_left():
	velocity.x -= speed
	
	if is_on_floor():
		animated_sprite.play("walk")
	else:
		animated_sprite.play("fly")

func move_right():
	velocity.x += speed
	
	if is_on_floor():
		animated_sprite.play("walk")
	else:
		animated_sprite.play("fly")
		
func fly(delta):
	if floor(fuel) <= 0:
		return null
	
	fuel -= .1
	velocity.y = delta * gravity - rocket_burst
	animated_sprite.play("fly")
	ui.set_fuel(fuel)

func jump():
	velocity.y -= jumpForce
	animated_sprite.play("jump")
#	jump_sound.play()
	
func face_right():
	animated_sprite.flip_h = false
	animated_gun.flip_h = false
	animated_gun.position.x = 35

func face_left():
	animated_sprite.flip_h = true
	animated_gun.flip_h = true
	animated_gun.position.x = -35

func collect_coin(value):
	score += value
	ui.set_coin_count(score)

func collect_life(value):
	health += value
	ui.set_health(health)
#	power_up_sound.play()

func reduce_life(damage: int):
	if is_unvulnerable:
		return null
	
	health -= damage
	
	ui.set_health(health)
	
	if health <= 0:
		die()
		return null

func die():
#	dead_sound.play()
#	animated_sprite.play("dead")
#	yield(get_tree().create_timer(0.5), "timeout") 
	get_tree().reload_current_scene()

func sync_gun():
	if is_raging:
		animated_gun.play("Rage")
	else:
		match current_level:
			1:
				animated_gun.play("Green")
			2:
				animated_gun.play("Blue")
			3:
				animated_gun.play("Violet")
			4:
				animated_gun.play("Red")

func attack():
	if Input.is_action_just_pressed("fire"):
		var shot = shot_scene.instance()
		
#		laser_sound.play()
		
		shot.position.y = position.y-10
		
		if is_raging:
			shot.set_shot_color("Rage")
		else:
			match current_level:
				1:
					shot.set_shot_color("Green")
				2:
					shot.set_shot_color("Blue")
				3:
					shot.set_shot_color("Violet")
				4:
					shot.set_shot_color("Red")

		if animated_sprite.flip_h:
			shot.direction = Vector2(-1, 0)
			shot.position.x = position.x-50
		else:
			shot.direction = Vector2(1, 0)
			shot.position.x = position.x+50
			
		get_parent().add_child(shot)
