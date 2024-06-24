extends Camera2D

onready var current_level = int(get_tree().current_scene.name)
onready var nova = get_node("/root/Level"+str(current_level)+"/Nova")

# Called when the node enters the scene tree for the first time.
func _ready():
	LevelManager.is_player_in_boss_room = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not LevelManager.is_player_in_boss_room:
		position.x = nova.position.x+150

