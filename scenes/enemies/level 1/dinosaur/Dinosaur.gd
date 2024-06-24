extends EnemyBase

export var gravity: int = 400

var velocity: Vector2

onready var ground_detection = $GroundDetect

func _physics_process(delta):
	if not active:
		return
	
	velocity.x = 0

	if not is_on_floor():
		velocity.y += gravity * delta
		
	if not player_detected and is_on_floor() and is_on_wall():
		flip_me()

	move()
	
	velocity = move_and_slide(velocity, Vector2.UP)

	if velocity.x == 0:
		animated_sprite.play("default")
	else:
		animated_sprite.play("walk")

func move():
	if player_detected:
		if not abs(player_ref.global_position.x - global_position.x) >= 10:	
			return
			
		face_player()
	elif not ground_detection.is_colliding():
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
	else:
		facing = FACING.LEFT

