extends EnemyBase

export var gravity: int = 400

var velocity: Vector2
var speed_ref

onready var ground_detection = $GroundDetect

func _ready():
	animated_sprite.play("default")
	speed_ref = speed
	facing = default_facing

func _physics_process(delta):
	velocity.x = 0

	if not is_on_floor():
		velocity.y += gravity * delta
		
	move()
	
	if is_on_floor() and is_on_wall():
		flip_me()
	
	velocity = move_and_slide(velocity, Vector2.UP)
	
	if not player_detected:
		speed = speed_ref

	animated_sprite.play("default")


func move():
	if player_detected:
		if not abs(player_ref.global_position.x - global_position.x) >= 10:	
			return
		face_player()
		
		if not ground_detection.is_colliding():
			speed = 0
		else:
			speed = speed_ref
			
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
		animated_sprite.offset.x = 0
	else:
		facing = FACING.LEFT
		animated_sprite.offset.x = 1

func die():
	if dying:
		return
		
		
	dying = true
	
	set_physics_process(false)
	animation_player.play("Die")
	animated_sprite.play("die")
