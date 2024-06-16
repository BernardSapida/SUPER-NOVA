extends KinematicBody2D

class_name EnemyBase

enum FACING { LEFT = -1, RIGHT = 1}

export var default_facing = FACING.LEFT
export var health: int = 100
export var speed: float = 120.0
export var damage: int = 20

var facing = default_facing
var dying: bool = false
var player_detected: bool = false
var hit_player: bool = false

onready var player_ref = get_tree().get_nodes_in_group("Player")[0]
onready var animated_sprite = $AnimatedSprite
onready var animation_player = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	animated_sprite.play("default")

func die():
	if dying:
		return
		
	dying = true
	
	set_physics_process(false)
	animation_player.play("Die")
	
func remove_from_scene():
	hide()
	queue_free()
	
func hit(damage: int):
	health -= damage
	animation_player.play("Hurt")
	
	if health <= 0:
		die()
		return

func _on_DetectionRange_body_entered(body):
	player_detected = true
	print("Enter")

func _on_DetectionRange_body_exited(body):
	player_detected = false

func _on_Hitbox_body_entered(body):
	if body.name == "Nova" and not dying:
		hit_player = true
		var knockback_x_direction = global_position.x - body.global_position.x
		while hit_player:
			if knockback_x_direction >= 0:
				body.hit(-1, damage)
			else:
				body.hit(1, damage)
			yield(get_tree().create_timer(2), "timeout")
			



func _on_Hitbox_body_exited(body):
	hit_player = false
