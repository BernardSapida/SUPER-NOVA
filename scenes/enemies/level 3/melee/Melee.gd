extends EnemyBase

export var gravity: int = 400

var velocity: Vector2
var attacking: bool = false
var player_within_attacking_range: bool = false
var speed_ref

onready var ground_detection = $GroundDetect

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

	if velocity.x == 0 and not attacking:
		animated_sprite.play("default")
	elif velocity.x != 0 and not attacking:
		animated_sprite.play("run")
		
	if animated_sprite.animation != "attack":
		animated_sprite.offset.x = 0
		animated_sprite.offset.y = 0
	else:
		animated_sprite.offset.x = -20
		animated_sprite.offset.y = -11
		
	if not attacking:
		speed = speed_ref
		
		
func move():
	if player_within_attacking_range:
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
		$AttackRange.position.x = 155
	else:
		facing = FACING.LEFT
		$AttackRange.position.x = 0 

func die():
	if dying:
		return
		
	dying = true
	
	set_physics_process(false)
	animation_player.play("Die")
	animated_sprite.play("die")
	
	LevelManager.add_current_points(points)
	
func attack():
	pass


func _on_AttackRange_body_entered(body):
	if body.name == "Nova" and not dying and is_on_floor():
		player_within_attacking_range = true
		speed = 0
		while player_within_attacking_range:
			attacking = true
			animated_sprite.play("attack")
			yield(get_tree().create_timer(0.4), "timeout")
			if player_within_attacking_range:
				var knockback_x_direction = global_position.x - body.global_position.x
				if knockback_x_direction >= 0:
					body.hit(-1, damage)
				else:
					body.hit(1, damage)
			yield(get_tree().create_timer(0.6), "timeout")
			attacking = false
			animated_sprite.play("default")
			yield(get_tree().create_timer(1.0), "timeout")

func _on_AttackRange_body_exited(body):
	player_within_attacking_range = false
