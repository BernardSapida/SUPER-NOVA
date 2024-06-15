extends EnemyBase

export var gravity: int = 400

var velocity: Vector2
var speed_ref = speed
var attacking: bool = false
var can_attack: bool = true
var bullet_scene = preload("res://scenes/enemies/bullets/laser/LaserBullet.tscn")

onready var ground_detection = $GroundDetect
onready var attack_range = $AttackRange
onready var attack_timer = $AttackTimer
onready var fire_timer = $FireTimer

func _ready():
	animated_sprite.play("default")
	speed_ref = speed

func _physics_process(delta):
	velocity.x = 0

	if not is_on_floor():
		velocity.y += gravity * delta
		
	if not player_detected and is_on_floor() and is_on_wall():
		flip_me()

	move()
	
	velocity = move_and_slide(velocity, Vector2.UP)

	if velocity.x == 0 and is_on_floor() and not attacking:
		animated_sprite.play("default")
	elif not attacking:
		animated_sprite.play("run")
		
	if attacking:
		speed = 0
	else:
		speed = speed_ref
	
	if animated_sprite.animation == "attack":
		animated_sprite.offset.x = -28
		animated_sprite.offset.y = 7
	else:
		animated_sprite.offset.x = 0
		animated_sprite.offset.y = 0
		
	if player_detected and can_attack and attacking:
		deferred_attack()
		
func move():
	if player_detected:
		if not abs(player_ref.global_position.x - global_position.x) >= 10:	
			return
			
		face_player()
	elif not ground_detection.is_colliding() and is_on_floor():
		flip_me()
	
	velocity.x = speed * facing
	
	
func face_player():
	if player_ref.global_position.x > global_position.x and facing == FACING.LEFT:
		flip_me()
	elif player_ref.global_position.x < global_position.x and facing == FACING.RIGHT:
		flip_me()


func flip_me():
	animated_sprite.flip_h = !animated_sprite.flip_h
	ground_detection.position.x = ground_detection.position.x * -1
	
	if facing == FACING.LEFT:
		facing = FACING.RIGHT
		attack_range.position.x = 572
	else:
		facing = FACING.LEFT
		attack_range.position.x = 0 

func die():
	if dying:
		return
		
	dying = true
	
	set_physics_process(false)
	animation_player.play("Die")
	animated_sprite.play("die")
	
func deferred_attack():
	call_deferred("attack")
	
func attack():
	if not can_attack:
		return
	
	can_attack = false
	animated_sprite.play("attack")
	fire_timer.start()
	
func create_bullet():
	var bullet = bullet_scene.instance()
	var dir: float
	if facing == FACING.LEFT:
		dir = 180
	elif facing == FACING.RIGHT:
		dir = 0	
	bullet.setup(dir, 20, 400, damage, "gunner")
	bullet.position.x = 55 * facing
	bullet.position.y = -7
	add_child(bullet)

func _on_AttackRange_body_entered(body):
	if body.name == "Nova" and not dying and is_on_floor():
		speed = 0
		attacking = true

func _on_AttackRange_body_exited(body):
	attacking = false

func _on_FireTimer_timeout():
	can_attack = false
	attack_timer.start()
	create_bullet()

func _on_AttackTimer_timeout():
	can_attack = true
