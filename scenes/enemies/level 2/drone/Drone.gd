extends EnemyBase

var can_attack: bool = true
var attacking: bool = false
var laser_scene = preload("res://scenes/enemies/bullets/laser/LaserBullet.tscn")
var facing_dir: float

onready var attack_timer = $AttackTimer
onready var fire_timer = $FireTimer
# Called when the node enters the scene tree for the first time.
func _ready():
	facing_dir = rotation + 90
	
func _physics_process(delta):
	if attacking:
		animated_sprite.play("attack")
	elif not attacking:
		animated_sprite.play("default")
		
	if player_detected and can_attack:
		deferred_attack()
		
		
func deferred_attack():
	call_deferred("attack")

func attack():
	if not can_attack:
		return
	
	can_attack = false
	attacking = true
	fire_timer.start()

func create_bullet():
	var laser = laser_scene.instance()	
	laser.setup(facing_dir, 20, 400, damage, "drone")
	add_child(laser)
	

func _on_AttackTimer_timeout():
	can_attack = true

func _on_FireTimer_timeout():
	attacking = false
	create_bullet()
	attack_timer.start()
	

