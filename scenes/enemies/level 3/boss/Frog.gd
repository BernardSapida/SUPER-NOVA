extends BossBase

var gravity = 800

const JUMP_VELOCITY: Vector2 = Vector2(150, -400)
const SUPER_JUMP_VELOCITY: Vector2 = Vector2(250, -1600)
const JUMP_WAIT_RANGE: Vector2 = Vector2(0.5, 3.0)

var velocity: Vector2
var super_jump: bool = false
var jump_counter: int = 1
var _jump: bool = false
var is_recently_super_jump: bool = false

onready var jump_timer = $JumpTimer

# Called when the node enters the scene tree for the first time.
func _ready():
	animated_sprite.play("default")
	start_timer()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	if is_on_floor() == false:
		velocity.y += gravity * delta
	else:
		velocity.x = 0
		animated_sprite.play("default")	
	
	if velocity.y > 0:
		animated_sprite.play("falling")
		
	apply_jump()
	apply_super_jump()
	apply_stomp()
	velocity = move_and_slide(velocity, Vector2.UP)
	flip_me()

func apply_jump() -> void:
	
	if not is_on_floor():
		return
		
	if not _jump or jump_counter == 0:
		return
	
	if gravity > 800:
		gravity = 800
	
	velocity = JUMP_VELOCITY
	jump_counter -= 1
	
	if animated_sprite.flip_h == false:
		velocity.x = velocity.x * -1
		
	_jump = false
	
	animated_sprite.play("jump")
	
	jump_timer.start()
	
func apply_super_jump():
	
	if not is_on_floor():
		return
		
	if not super_jump:
		return
	
	gravity *= 4
	velocity = SUPER_JUMP_VELOCITY
	jump_counter = 1
	
	if animated_sprite.flip_h == false:
		velocity.x = velocity.x * -1
		
	super_jump = false
	is_recently_super_jump = true
	
	animated_sprite.play("jump")
	jump_timer.start()

func apply_stomp():
	if not is_recently_super_jump:
		return
	
	if not is_on_floor():
		return
	
	if is_on_floor() and velocity.y < 0:
		return
	
	is_recently_super_jump = false
	
	if not player_ref.is_on_floor():
		return 
		
	var knockback_x_direction = global_position.x - player_ref.global_position.x
	if knockback_x_direction >= 0:
		player_ref.hit(-1, 10)
	else:
		player_ref.hit(1, 10)


func flip_me() -> void:
	if not is_on_floor():
		return
	
	if(player_ref.global_position.x > global_position.x
		and animated_sprite.flip_h == false ):
		animated_sprite.flip_h = true
	elif(player_ref.global_position.x < global_position.x
		and animated_sprite.flip_h == true ):
		animated_sprite.flip_h = false


func start_timer() -> void:
	if is_recently_super_jump:
		jump_timer.wait_time = rand_range(JUMP_WAIT_RANGE.x + 2.0, JUMP_WAIT_RANGE.y)
	else: 
		jump_timer.wait_time = rand_range(JUMP_WAIT_RANGE.x, JUMP_WAIT_RANGE.y)
	jump_timer.start()
	

func _on_Hitbox_body_entered(body):
	if body.name == "Nova" and not dying:
		hit_player = true
		var knockback_x_direction = global_position.x - body.global_position.x
		while hit_player:
			if knockback_x_direction >= 0:
				body.hit(-1, damage)
			else:
				body.hit(1, damage)
			body.poisoned()
			yield(get_tree().create_timer(2), "timeout")


func _on_JumpTimer_timeout():
	if jump_counter == 0:
		super_jump = true
	else:
		_jump = true
