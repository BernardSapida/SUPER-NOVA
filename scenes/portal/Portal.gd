extends Area2D

onready var current_level = int(get_tree().current_scene.name)
onready var animated_sprite = $AnimatedSprite

export var is_portal = false

func _ready():
	match current_level:
		1:
			if is_portal:
				animated_sprite.play("gray")
			else:
				animated_sprite.play("green")
		2:
			if is_portal:
				animated_sprite.play("yellow")
			else:
				animated_sprite.play("gray")
		3:
			if is_portal:
				animated_sprite.play("red")
			else:
				animated_sprite.play("yellow")
		4:
			if is_portal:
				animated_sprite.play("rainbow")
			else:
				animated_sprite.play("red")
	pass # Replace with function body.

func _on_Portal_body_entered(body):
	pass # Replace with function body.
