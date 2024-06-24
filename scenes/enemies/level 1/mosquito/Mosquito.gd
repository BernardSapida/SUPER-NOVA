extends EnemyBase

var speed_ref: float
var velocity: Vector2

onready var reverse_timer = $ReverseTimer
onready var stop_timer = $StopTimer

func _ready():
	animated_sprite.play("default")
	speed_ref = speed
	
	health *= LevelManager.DIFFICULTY
	damage *= LevelManager.DIFFICULTY

func _physics_process(delta):
	if not active:
		return
	
	velocity = Vector2(0, 0)
		
	move()
	
	velocity = move_and_slide(velocity, velocity)

func move():
	if player_detected:
		if not abs(player_ref.global_position.x - global_position.x) >= 10:	
			return
		velocity = (player_ref.global_position - global_position).normalized() * speed
		face_player()
	else:
		velocity.x = speed * facing
		
func die():
	if dying:
		return
		
	dying = true
	
	set_physics_process(false)
	animation_player.play("Die")
	animated_sprite.play("die")
	
	LevelManager.add_current_points(points)
	
func face_player():
	if player_ref.global_position.x > global_position.x and facing == FACING.LEFT:
		flip_me()
	elif player_ref.global_position.x < global_position.x and facing == FACING.RIGHT:
		flip_me()
	
func flip_me():
	animated_sprite.flip_h = !animated_sprite.flip_h
	
	if facing == FACING.LEFT:
		facing = FACING.RIGHT
	else:
		facing = FACING.LEFT

func _on_ReverseTimer_timeout():
	stop_timer.start()
	speed = 0
	
func _on_StopTimer_timeout():
	flip_me()
	reverse_timer.start()
	speed = speed_ref

func _on_DetectionRange_body_entered(body):
	player_detected = true
	speed = speed_ref
	reverse_timer.stop()
	stop_timer.stop()

func _on_DetectionRange_body_exited(body):
	if not dying:
		player_detected = false
		speed = 0
		stop_timer.start()
