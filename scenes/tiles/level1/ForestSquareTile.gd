extends StaticBody2D

onready var tile = $Tile
onready var tile1 = preload("res://assets/level1 - forest/tiles/tile1.png")
onready var tile2 = preload("res://assets/level1 - forest/tiles/tile2.png")
onready var tile3 = preload("res://assets/level1 - forest/tiles/tile3.png")
onready var tile4 = preload("res://assets/level1 - forest/tiles/tile4.png")

export(
	String, 
	"Tile 1,Tile 2,Tile 3,Tile 4"
) var tile_type = "Tile 1"

# Called when the node enters the scene tree for the first time.
func _ready():
	match tile_type:
		"Tile 1":
			tile.set_texture(tile1)
		"Tile 2":
			tile.set_texture(tile2)
		"Tile 3":
			tile.set_texture(tile3)
		"Tile 4":
			tile.set_texture(tile4)
