extends EnemyBase

export var gravity: int = 400

var velocity: Vector2
var attacking: bool = false
var can_attack: bool = true
var bullet_scene = preload("res://scenes/enemies/projectiles/laser/LaserBullet.tscn")

onready var ground_detection = $GroundDetect
onready var attack_range = $AttackRange
onready var state = $State

func _ready():
	animated_sprite.play("default")

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
	elif velocity.x != 0 and not attacking:
		animated_sprite.play("run")
		
	if animated_sprite.animation == "attack":
		animated_sprite.offset.x = -28
		animated_sprite.offset.y = 7
	else:
		animated_sprite.offset.x = 0
		animated_sprite.offset.y = 0
	
func move():
	if attacking:
		return
		
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
		attack_range.position.x = 498
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
	
	LevelManager.add_current_points(points)
	
func deferred_attack():
	call_deferred("attack")
	
func attack():
	var bullet = bullet_scene.instance()
	var dir: float
	if facing == FACING.LEFT:
		dir = 180
	elif facing == FACING.RIGHT:
		dir = 0	
	bullet.setup(dir, 20, 400, damage, "gunner")
	bullet.position.x = position.x + 55 * facing
	bullet.position.y = position.y - 7
	get_parent().add_child(bullet)
	

func _on_AttackRange_body_entered(body):
	if body.name == "Nova" and not dying and is_on_floor():
		state.get_animation("attack").loop = true
		state.play("attack")
		attacking = true
		velocity = Vector2.ZERO

func _on_AttackRange_body_exited(body):
	state.get_animation("attack").loop = false
	yield(state, "animation_finished")
	state.stop()
	attacking = false

func attack_finished():
	attacking = false
