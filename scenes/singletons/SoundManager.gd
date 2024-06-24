extends Node


const SOUND_LEVEL1 = "laser"
const SOUND_LEVEL2 = "checkpoint"
const SOUND_LEVEL3 = "damage"
const SOUND_LEVEL4 = "kill"
const SOUND_GAMEOVER = "gameover1"
const SOUND_LOSE = "impact"
const SOUND_LOOT = "land"
const SOUND_POWERUP = "music1"
const SOUND_MUSIC2 = "music2"
const SOUND_PICKUP = "pickup"
const SOUND_BOSS_ARRIVE = "boss_arrive"
const SOUND_JUMP = "jump"
const SOUND_WIN = "win"


var SOUNDS = {
	
}


func play_clip(player: AudioStreamPlayer2D, clip_key: String):
	if SOUNDS.has(clip_key) == false:
		return
	player.stream = SOUNDS[clip_key]
	player.play()
