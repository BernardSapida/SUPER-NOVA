extends KinematicBody2D

var score: int = 0

var fuel: float = 100
var is_raging: bool = false
var is_unvulnerable: bool = false
var is_invisible: bool = false
var is_recently_hit: bool = false
var is_allowed_to_move: bool = false
var is_poisoned: bool = false
var poison_duration: int = 0
var is_dead: bool = false

# Nova items
var heart_item = 0
var cloak_item = 0
var shield_item = 0
var rage_item = 0
var speed_item = 0
var fuel_item = 0

export var health: float = 100
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
onready var poison_tick_timer = $PoisonTickTimer
onready var transition = get_node("/root/Level" + str(current_level) + "/CanvasLayer/Transition")
onready var sound_player = $AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	LevelManager.CURRENT_LEVEL = 4
	heart_item = InventoryManager.heart_item
	cloak_item = InventoryManager.cloak_item
	shield_item = InventoryManager.shield_item
	rage_item = InventoryManager.rage_item
	speed_item = InventoryManager.speed_item
	fuel_item = InventoryManager.fuel_item
	ui.set_item_count()

func _process(delta):
	regen_fuel()
	regen_health()

func _physics_process(delta):
	
	if animated_sprite.animation == "dead":
		return null
	
	if not is_allowed_to_move:
		velocity.x = 0
		
		if Input.is_action_pressed("ui_left"):
			move_left()
		elif Input.is_action_pressed("ui_right"):
			move_right()
		elif is_on_floor():
			idle()
		
		if Input.is_action_pressed("rocket"):
			fly(delta)
		
		if is_on_floor() and Input.is_action_just_pressed("ui_up"):
			jump()
		
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
	

	velocity = move_and_slide(velocity, Vector2.UP)
	
	velocity.y += gravity * delta
	
	if velocity.x < 0:
		face_left()
	elif velocity.x > 0:
		face_right()
	
	if Input.is_action_just_released("fire"):
		deferred_attack()
	sync_gun()

func use_heart_item():
	if heart_item <= 0:
		return null
	
	if health < 50:
		health += 50
	else:
		health = 100
	
	heart_item -= 1
	InventoryManager.heart_item -= 1
	ui.reduce_item("Heart")
	ui.set_health(health)
	
func use_cloak_item():
	if cloak_item <= 0:
		return null
	
	cloak_item -= 1
	InventoryManager.cloak_item -= 1
	ui.reduce_item("Cloak")
	
	animation_player.play("invisible")
	
	is_invisible = true
	set_collision_layer_bit(7, false)
	yield(get_tree().create_timer(10), "timeout")
	set_collision_layer_bit(7, true)
	is_invisible = false
	
func use_shield_item():
	if shield_item <= 0:
		return null
	
	shield_item -= 1
	InventoryManager.shield_item -= 1
	ui.reduce_item("Shield")
	animation_player.play("Barrier")
	
	is_unvulnerable = true
	yield(get_tree().create_timer(10), "timeout") 
	is_unvulnerable = false
	
func use_rage_item():
	if rage_item <= 0:
		return null
	
	rage_item -= 1
	InventoryManager.rage_item -= 1
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
	InventoryManager.speed_item -= 1
	ui.reduce_item("Speed")
	
	is_boosted = true
	speed = 200
	yield(get_tree().create_timer(10), "timeout") 
	is_boosted = false
	speed = 120

func use_fuel_item():
	if fuel_item <= 0:
		return null
	
	if fuel >= 75:
		fuel += 25
	else:
		fuel = 100

	fuel_item -= 1
	InventoryManager.fuel_item -= 1
	ui.reduce_item("Fuel")
	ui.set_fuel(fuel)

func regen_fuel():
	if fuel < 100:
		fuel += .01
		ui.set_fuel(fuel)

func regen_health():
	if health < 100:
		health += .001
		ui.set_health(health)

func obtain_item(item: String):
	match item:
		"Heart":
			heart_item += 1
			InventoryManager.heart_item += 1
		"Cloak":
			cloak_item += 1
			InventoryManager.cloak_item += 1
		"Shield":
			shield_item += 1
			InventoryManager.shield_item += 1
		"Rage":
			rage_item += 1
			InventoryManager.rage_item += 1
		"Speed":
			speed_item += 1
			InventoryManager.speed_item += 1
		"Fuel":
			fuel_item += 1
			InventoryManager.fuel_item += 1
	
	SoundManager.play_clip(sound_player, SoundManager.SOUND_POWERUP)
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
	SoundManager.play_clip(sound_player, SoundManager.SOUND_LOOT)

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
	is_dead = true
	set_physics_process(false)
	animated_sprite.stop()
	animation_player.play("Die")
	SoundManager.play_clip(sound_player, SoundManager.SOUND_LOSE)
	
func replay():
	ui.hide()
	transition.transition_to("res://scenes/menu_screens/death_screen/DeathScreen.tscn")

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

func deferred_attack():
	call_deferred("attack")

func attack():
	SoundManager.play_clip(sound_player, SoundManager.SOUND_SHOOT)
	var shot = shot_scene.instance()
	
#		laser_sound.play()
	
	shot.position.y = position.y-10
	shot.damage = damage
	
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

func hit(enemyDirection: int, damage: int):
	if is_recently_hit or is_unvulnerable or is_dead:
		return
	
	animation_player.play("Hit")
	
	reduce_life(damage)
	
	set_allowed_to_move()
	set_recently_hit()
	velocity.x = 70 * enemyDirection
	velocity.y = -200

func poisoned():
	if is_unvulnerable:
		return
	is_poisoned = true
	poison_duration = 10
	poison_tick_timer.start()
	
func set_recently_hit():
	if health <= 0:
		return
	is_recently_hit = true
	yield(get_tree().create_timer(2), "timeout")
	is_recently_hit = false 

func set_allowed_to_move():
	if health <= 0:
		return
	is_allowed_to_move = true
	yield(get_tree().create_timer(0.5), "timeout")
	is_allowed_to_move = false


func _on_PoisonTickTimer_timeout():
	if poison_duration == 0 or is_dead:
		poison_tick_timer.stop()
		return
	
	reduce_life(1)
	animation_player.play("Poisoned")
	poison_duration -= 1
	
