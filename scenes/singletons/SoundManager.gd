extends Node


const SOUND_LEVEL1 = "level1"
const SOUND_LEVEL2 = "level2"
const SOUND_LEVEL3 = "level3"
const SOUND_LEVEL4 = "level4"
const SOUND_GAMEOVER = "gameover"
const SOUND_LOSE = "lose"
const SOUND_LOOT = "loot"
const SOUND_DEAD = "dead"
const SOUND_POWERUP = "powerup"
const SOUND_WIN = "win"
const SOUND_BGM = "bgm"
const SOUND_STOMP = "stomp"
const SOUND_SHOOT = "shoot"

var SOUNDS = {
	SOUND_LEVEL1: preload("res://assets/Sounds/Level 1.mp3"),
	SOUND_LEVEL2: preload("res://assets/Sounds/Level 2.mp3"),
	SOUND_LEVEL3: preload("res://assets/Sounds/Level 3.mp3"),
	SOUND_LEVEL4: preload("res://assets/Sounds/Level 4.mp3"),
	SOUND_GAMEOVER: preload("res://assets/Sounds/Game Over.mp3"),
	SOUND_LOSE: preload("res://assets/Sounds/Lose.mp3"),
	SOUND_LOOT: preload("res://assets/Sounds/Loot.mp3"),
	SOUND_DEAD: preload("res://assets/Sounds/Dead.mp3"),
	SOUND_POWERUP: preload("res://assets/Sounds/Powerup.mp3"),
	SOUND_WIN: preload("res://assets/Sounds/Win.mp3"),
	SOUND_BGM: preload("res://assets/Sounds/mainBgm.mp3"),
	SOUND_STOMP: preload("res://assets/Sounds/impact.wav"),
	SOUND_SHOOT: preload("res://assets/Sounds/laser.wav"),
}


func play_clip(player: AudioStreamPlayer, clip_key: String):
	if SOUNDS.has(clip_key) == false:
		return
	player.stream = SOUNDS[clip_key]
	player.play()
