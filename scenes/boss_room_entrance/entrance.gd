extends Node2D

var forest_tile = preload("res://scenes/tiles/level1/ForestSquareTile.tscn")
var dungeon_tile = preload("res://scenes/tiles/level2/DungeonSquareTile.tscn")
var factory_tile = preload("res://scenes/tiles/level3/FactorySquareTile.tscn")
var volcano_tile = preload("res://scenes/tiles/level4/VolcanoSquareTile.tscn")

onready var current_level = int(get_tree().current_scene.name)
onready var camera = get_node("/root/Level"+str(current_level)+"/Camera2D")
onready var boss_room = get_node("/root/Level"+str(current_level)+"/BossRoom")
onready var player_trigger = $PlayerTrigger
onready var invi_barrier = $InviBarrier

# Called when the node enters the scene tree for the first time.
func _ready():
	
	var tile = forest_tile
	match LevelManager.CURRENT_LEVEL:
		1:
			tile = forest_tile
		2:
			tile = dungeon_tile
		3:
			tile = factory_tile
		4:
			tile = volcano_tile
			
	for n in 2:
		var new_tile = tile.instance()
		new_tile.position = Vector2(position.x, position.y + n * 48)
		add_child(new_tile)
	
	for children in boss_room.get_children():
		if children.name == "entrance" or children.name == "Portal":
			continue
		if current_level == 4:
			children.get_child(0).deactivate()
		else:
			children.deactivate()
		
		
	
func _on_PlayerTrigger_body_entered(body):
	if body.name == "Nova" and body.health >= 1:
		LevelManager.player_entered_boss_room()
		$AnimationPlayer.play("block_entrance")
		player_trigger.queue_free()
		invi_barrier.queue_free()
		var tween = get_tree().create_tween()
		tween.set_pause_mode(SceneTreeTween.TWEEN_PAUSE_PROCESS)
		tween.tween_property(camera, "position", Vector2(boss_room.global_position.x, camera.position.y), 2.0)
		get_tree().paused = true
		yield(tween, "finished")
		for children in boss_room.get_children():
			if children.name == "entrance" or children.name == "Portal":
				continue
			if current_level == 4:
				children.get_child(0).activate()
			else:
				children.activate()
			if current_level >= 2:
				if current_level == 4:
					yield(children.get_child(0).animation_player, "animation_finished")
				else:
					yield(children.animation_player, "animation_finished")
		get_tree().paused = false
