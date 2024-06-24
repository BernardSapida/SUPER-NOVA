extends EnemyBase

export var gravity: int = 400

var velocity: Vector2
var attacking: bool = false
var player_within_attacking_range: bool = false

onready var ground_detection = $GroundDetect

func _ready():
	animated_sprite.play("default")
	facing = default_facing
	

func _physics_process(delta):
	velocity.x = 0

	if not is_on_floor():
		velocity.y += gravity * delta
		
	if not player_detected and is_on_floor() and is_on_wall():
		flip_me()

	move()
	
	velocity = move_and_slide(velocity, Vector2.UP)

	if not attacking:
		animated_sprite.play("default")

func move():
	if player_within_attacking_range:
		return
		
	if player_detected:
		if not abs(player_ref.global_position.x - global_position.x) >= 10:	
			return
			
		face_player()
	elif is_on_floor() and not ground_detection.is_colliding():
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
		$Body.position.x = -3
		$Hitbox.position.x = 0
		$Attack.position.x = 0
	else:
		facing = FACING.LEFT
		$Body.position.x = 3
		$Hitbox.position.x = 6
		$Attack.position.x = -64

func die():
	if dying:
		return
		
	dying = true
	
	set_physics_process(false)
	animation_player.play("Die")
	animated_sprite.play("die")
	
	LevelManager.add_current_points(points)

func _on_Attack_body_entered(body):
	if body.name == "Nova" and not dying:
		player_within_attacking_range = true
		while player_within_attacking_range:
			velocity.x = 0
			attacking = true
			animated_sprite.play("attack")
			yield(get_tree().create_timer(0.1), "timeout")
			var knockback_x_direction = global_position.x - body.global_position.x
			if knockback_x_direction >= 0:
				body.hit(-1, damage)
			else:
				body.hit(1, damage)
			attacking = false
			yield(get_tree().create_timer(1.0), "timeout")


func _on_Attack_body_exited(body):
	player_within_attacking_range = false
