extends EnemyBase

var speed_ref: float
var velocity: Vector2

onready var reverse_timer = $ReverseTimer
onready var stop_timer = $StopTimer

func _ready():
	animated_sprite.play("default")
	speed_ref = speed

func _physics_process(delta):
	velocity = Vector2(0, 0)
		
	move()
	
	velocity = move_and_slide(velocity, velocity)

func move():
	velocity.x = speed * facing

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
