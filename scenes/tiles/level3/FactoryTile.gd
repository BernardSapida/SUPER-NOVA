extends StaticBody2D

onready var tile = $Tile
onready var tile7 = preload("res://assets/level3 - factory/tiles/tile7.png")
onready var tile8 = preload("res://assets/level3 - factory/tiles/tile8.png")
onready var tile9 = preload("res://assets/level3 - factory/tiles/tile9.png")
onready var tile10 = preload("res://assets/level3 - factory/tiles/tile10.png")

export(
	String, 
	"Tile 7,Tile 8,Tile 9,Tile 10"
) var tile_type = "Tile 7"

# Called when the node enters the scene tree for the first time.
func _ready():
	match tile_type:
		"Tile 7":
			tile.set_texture(tile7)
		"Tile 8":
			tile.set_texture(tile8)
		"Tile 9":
			tile.set_texture(tile9)
		"Tile 10":
			tile.set_texture(tile10)
