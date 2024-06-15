extends Area2D

var _direction: Vector2 = Vector2.DOWN
var _life_span: float = 20.0
var _life_time: float = 0.0
var _damage: int
var animation_name

onready var animated_sprite = $AnimatedSprite

# Called when the node enters the scene tree for the first time.
func _ready():
	animated_sprite.play(animation_name)
	if animation_name == "drone":
		animated_sprite.scale.x = 1
		animated_sprite.scale.y = 1
	elif animation_name == "gunner":
		animated_sprite.scale.x = 0.6
		animated_sprite.scale.y = 1.1
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	check_expired(delta)
	position += _direction * delta

func setup(dir: float, life_span: float, speed: float, damage: int, attacker) -> void:
	_life_span = life_span
	_damage = damage
	rotation = deg2rad(dir)
	_direction = transform.x * speed
	animation_name = attacker
	
	
func check_expired(delta: float) -> void:
	_life_time += delta
	if _life_time > _life_span:
		queue_free()

func _on_LaserBullet_body_entered(body):	
	queue_free()
	if body.name == "Nova":
		var knockback_x_direction = global_position.x - body.global_position.x
		if knockback_x_direction >= 0:
			body.hit(-1, _damage)
		else:
			body.hit(1, _damage)
