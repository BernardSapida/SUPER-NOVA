extends Control

var is_announcing: bool = false
var show_inventory: bool = false

onready var coin_count = get_node("CoinCount")
onready var health_bar = get_node("HealthBar")
onready var fuel_bar = get_node("FuelBar")
onready var current_level = int(get_tree().current_scene.name)

onready var animation_player = $AnimationPlayer
onready var announcement_animation = $AnnouncementAnimation
onready var announcement_label = $AnnouncementLabel
onready var health_count_label = $VBoxContainer/InventoryRect/HealthCount
onready var cloak_count_label = $VBoxContainer/InventoryRect/CloakCount
onready var shield_count_label = $VBoxContainer/InventoryRect/ShieldCount
onready var rage_count_label = $VBoxContainer/InventoryRect/RageCount
onready var speed_count_label = $VBoxContainer/InventoryRect/SpeedCount
onready var fuel_count_label = $VBoxContainer/InventoryRect/FuelCount

# Sprites
onready var health_sprite = $VBoxContainer/InventoryRect/HealthSprite
onready var cloak_sprite = $VBoxContainer/InventoryRect/CloakSprite
onready var shield_sprite = $VBoxContainer/InventoryRect/ShieldSprite
onready var rage_sprite = $VBoxContainer/InventoryRect/RageSprite
onready var speed_sprite = $VBoxContainer/InventoryRect/SpeedSprite
onready var fuel_sprite = $VBoxContainer/InventoryRect/FuelSprite

# Active sprites
onready var health_texture = preload("res://assets/items/health/health.png")
onready var cloak_texture = preload("res://assets/items/cloak/cloak.png")
onready var shield_texture = preload("res://assets/items/shield/shield.png")
onready var rage_texture = preload("res://assets/items/rage/rage.png")
onready var speed_texture = preload("res://assets/items/speed/speed.png")
onready var fuel_texture = preload("res://assets/items/fuel/fuel.png")

# Darken sprites
onready var health_darken_texture = preload("res://assets/items/health/health-darken.png")
onready var cloak_darken_texture = preload("res://assets/items/cloak/cloak-darken.png")
onready var shield_darken_texture = preload("res://assets/items/shield/shield-darken.png")
onready var rage_darken_texture = preload("res://assets/items/rage/rage-darken.png")
onready var speed_darken_texture = preload("res://assets/items/speed/speed-darken.png")
onready var fuel_darken_texture = preload("res://assets/items/fuel/fuel-darken.png")

var announcements = []

# Called when the node enters the scene tree for the first time.
func _ready():
	coin_count.text = "0"
	health_count_label.text = "0"
	cloak_count_label.text = "0"
	shield_count_label.text = "0"
	rage_count_label.text = "0"
	speed_count_label.text = "0"
	fuel_count_label.text = "0"
	sync_items_sprite()

func _process(delta):
	if Input.is_action_just_pressed("ui_focus_next"):
		show_inventory = !show_inventory
		
		if show_inventory:
			animation_player.play("ShowInventory")
		else:
			animation_player.play("HideInventory")

func add_item(item: String):
	match item:
		"Heart":
			health_count_label.text = str(int(health_count_label.text) + 1)
		"Cloak":
			cloak_count_label.text = str(int(cloak_count_label.text) + 1)
		"Shield":
			shield_count_label.text = str(int(shield_count_label.text) + 1)
		"Rage":
			rage_count_label.text = str(int(rage_count_label.text) + 1)
		"Speed":
			speed_count_label.text = str(int(speed_count_label.text) + 1)
		"Fuel":
			fuel_count_label.text = str(int(fuel_count_label.text) + 1)
	
	sync_items_sprite()
	append_announcement("You've obtained " + item + " item from the glowing orb!")


#DONE EVERY RESET TO SET THE UI VALUES OF EACH POWERUPS TO THE GLOBAL INVENTORY
func set_item_count():
	health_count_label.text = str(InventoryManager.heart_item)
	cloak_count_label.text = str(InventoryManager.cloak_item)
	shield_count_label.text = str(InventoryManager.shield_item)
	rage_count_label.text = str(InventoryManager.rage_item)
	speed_count_label.text = str(InventoryManager.speed_item)
	fuel_count_label.text = str(InventoryManager.fuel_item)
	
	sync_items_sprite()

func reduce_item(item: String):
	match item:
		"Heart":
			health_count_label.text = str(int(health_count_label.text) - 1)
		"Cloak":
			cloak_count_label.text = str(int(cloak_count_label.text) - 1)
		"Shield":
			shield_count_label.text = str(int(shield_count_label.text) - 1)
		"Rage":
			rage_count_label.text = str(int(rage_count_label.text) - 1)
		"Speed":
			speed_count_label.text = str(int(speed_count_label.text) - 1)
		"Fuel":
			fuel_count_label.text = str(int(fuel_count_label.text) - 1)
	
	sync_items_sprite()
	append_announcement("You've just used the " + item + " item!")

func sync_items_sprite():
	if int(health_count_label.text) > 0:
		health_sprite.set_texture(health_texture)
	else:
		health_sprite.set_texture(health_darken_texture)
		
	if int(cloak_count_label.text) > 0:
		cloak_sprite.set_texture(cloak_texture)
	else:
		cloak_sprite.set_texture(cloak_darken_texture)
	
	if int(shield_count_label.text) > 0:
		shield_sprite.set_texture(shield_texture)
	else:
		shield_sprite.set_texture(shield_darken_texture)
	
	if int(rage_count_label.text) > 0:
		rage_sprite.set_texture(rage_texture)
	else:
		rage_sprite.set_texture(rage_darken_texture)
	
	if int(speed_count_label.text) > 0:
		speed_sprite.set_texture(speed_texture)
	else:
		speed_sprite.set_texture(speed_darken_texture)
	
	if int(fuel_count_label.text) > 0:
		fuel_sprite.set_texture(fuel_texture)
	else:
		fuel_sprite.set_texture(fuel_darken_texture)

func set_coin_count(count: int):
	coin_count.text = str(count)

func set_health(health: int): 
	health_bar.value = health

func set_fuel(fuel: int):
	fuel_bar.value = fuel

func append_announcement(item: String):
	announcements.push_back(item)
	
	if !is_announcing:
		announce()

func announce():
	is_announcing = true
	
	while !announcements.empty():
		announcement_label.text = announcements.pop_front()
		announcement_animation.play("fade_in_out")
		yield(get_tree().create_timer(3), "timeout") 
	
	is_announcing = false
