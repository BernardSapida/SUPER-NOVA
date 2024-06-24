extends KinematicBody2D

class_name BossBase

enum FACING { LEFT = -1, RIGHT = 1}

export var default_facing = FACING.LEFT
export var health: int = 100
export var speed: float = 120.0
export var damage: int = 20

var facing = default_facing
var dying: bool = false
var hit_player: bool = false
var points = 100
var active: bool = false

onready var player_ref = get_tree().get_nodes_in_group("Player")[0]
onready var animated_sprite = $AnimatedSprite
onready var animation_player = $AnimationPlayer
onready var sound_player = $AudioStreamPlayer


var death_explosion = preload("res://scenes/enemies/boss_death_effect/DeathEffect.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	animated_sprite.play("default")
	
	health *= LevelManager.DIFFICULTY
	damage *= LevelManager.DIFFICULTY
	points *= LevelManager.DIFFICULTY
	
	#player_position = player_ref.position

func activate():
	animation_player.play("entrance")
	yield(animation_player, "animation_finished")
	active = true

func deactivate():
	active = false

func die():
	if dying:
		return
		
	dying = true
	
	set_physics_process(false)
	
	var explosion = death_explosion.instance()

	explosion.global_position = global_position
	get_tree().current_scene.add_child(explosion)
	
	SoundManager.play_clip(sound_player, SoundManager.SOUND_DEAD)
	animated_sprite.play("default")
	animated_sprite.stop()
	animated_sprite.frame = 0
	animation_player.play("die")
	LevelManager.add_current_points(points)
	
func remove_from_scene():
	hide()
	queue_free()
	
func hit(damage: int):
	health -= damage
	animation_player.play("hurt")
	if health <= 0:
		die()
		return


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
