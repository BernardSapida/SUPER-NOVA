extends ColorRect

export(String, FILE, "*.tscn") var next_scene_path

onready var animation_player = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS
	get_tree().paused = true
	
	animation_player.play_backwards("fade")
	yield(animation_player, "animation_finished")
	get_tree().paused = false
	
func exit():
	animation_player.play_backwards("fade")

func transition_to(next_scene := next_scene_path):
	self.show()
	animation_player.play("fade")
	yield(animation_player, "animation_finished")
	get_tree().change_scene(next_scene)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
