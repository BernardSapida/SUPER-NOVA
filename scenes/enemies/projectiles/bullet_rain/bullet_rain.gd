extends Node2D

#var bullet = preload("res://scenes/enemies/projectiles/laser/LaserBullet.tscn")
var bullet_lifespan: float = 20.0
var bullet_speed = 400
var bullet_damage = 20
var bullet_attacker = "boss"

onready var warning = $warning
onready var animation_player = $AnimationPlayer
onready var bullet = $LaserBullet

#var bullet = preload("res://scenes/enemies/projectiles/laser/LaserBullet.tscn")

# Called when the node enters the scene tree for the first time.

func _ready():
	animation_player.play("default")
	bullet.set_process(false)
	bullet.visible = false
	bullet.setup(0, bullet_lifespan, bullet_speed, bullet_damage, bullet_attacker)
	bullet.animated_sprite.play(bullet_attacker)
	bullet.monitoring = false
	if position.y == -452 or position.y == 76:
		warning.rect_size.x = 528

func setup_bullet(start_position: Vector2, dir: float, life_span: float, speed: float, damage: int, attacker):
	position = start_position
	rotation = deg2rad(dir)
	
	bullet_lifespan = life_span
	bullet_speed = speed
	bullet_damage = damage
	bullet_attacker = attacker

func start_attack():
	bullet.monitoring = true
	bullet.set_process(true)
	bullet.visible = true
