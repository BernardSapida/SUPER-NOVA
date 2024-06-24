extends BossBase

var velocity: Vector2
var dash_speed: int = 1500
var bullet_rain = preload("res://scenes/enemies/projectiles/bullet_rain/bullet_rain.tscn")
var bullet_damage = 15
var tween: SceneTreeTween

onready var states = $States

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	animated_sprite.play("default")
	
func activate():
	animation_player.play("entrance")
	yield(animation_player, "animation_finished")
	active = true
	$AnimationTree["parameters/conditions/active"] = true

func deactivate():
	active = false
	$AnimationTree["parameters/conditions/active"] = false

func die():
	if dying:
		return
		
	dying = true
	set_physics_process(false)
	
	var explosion = death_explosion.instance()
	explosion.global_position = global_position
	get_tree().current_scene.add_child(explosion)
	
	animated_sprite.play("default")
	animated_sprite.stop()
	animated_sprite.frame = 0
	animation_player.play("die")
	states.stop()
	tween.kill()
	$AnimationTree["parameters/conditions/dying"] = true
	LevelManager.add_current_points(points)

func dash_attack():
	tween = get_tree().create_tween()
	if position.x == 0:
		tween.tween_property(self, "position", Vector2(-864, position.y), 0.5)
	else:
		tween.tween_property(self, "position", Vector2(0, position.y), 0.5)
	
func find_start_position():
	var start_position = Vector2(-864 * (randi() % 2), (randi() % 385) * -1)
	position = start_position
	
	if position.x == 0 and facing == FACING.RIGHT:
		flip_me()
	elif position.x == -864 and facing == FACING.LEFT:
		flip_me()

func flip_me():
	animated_sprite.flip_h = !animated_sprite.flip_h
	if facing == FACING.LEFT:
		facing = FACING.RIGHT
	elif facing == FACING.RIGHT:
		facing = FACING.LEFT

func deferred_bullet_attack():
	call_deferred("bullet_attack")

func check_facing():
	if facing == FACING.RIGHT:
		flip_me()
	
func bullet_attack():
	
	var dir = randi() % 2
	
	match dir:
		0:
			vertical_bullet_rain()
		1:
			horizontal_bullet_rain()
	
func vertical_bullet_rain():
	var start_dir = randi() % 2
	var offset = randi() % 36
	if start_dir == 0:
		offset *= 1
	else:
		offset *= -1
	match start_dir:
		0:
			for n in 11:
				var bullet = bullet_rain.instance()
				bullet.setup_bullet(Vector2(n * -85 + offset, -452), 90, 20.0, 400, bullet_damage, "boss")
				get_parent().add_child(bullet)
		1:
			for n in 11:
				var bullet = bullet_rain.instance()
				bullet.setup_bullet(Vector2(n * -85 + offset, 76), 270, 20.0, 400, bullet_damage, "boss")
				get_parent().add_child(bullet)
	
func horizontal_bullet_rain():
	var start_dir = randi() % 2
	var offset = randi() % 60
	if start_dir == 0:
		offset *= 1
	else:
		offset *= -1
	match start_dir:
		0:
			for n in 4:
				var bullet = bullet_rain.instance()
				bullet.setup_bullet(Vector2(48, n * -125 + offset), 180, 20.0, 400, bullet_damage, "boss")
				get_parent().add_child(bullet)
		1:
			for n in 4:
				var bullet = bullet_rain.instance()
				bullet.setup_bullet(Vector2(-912, n * -125 + offset), 0, 20.0, 400, bullet_damage, "boss")
				get_parent().add_child(bullet)
	
func reset_position():
	position = Vector2.ZERO
	
