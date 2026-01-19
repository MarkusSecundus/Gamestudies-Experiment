extends Node


@export var soundtrackTransition_seconds : float = 3.0
@export var minReasonableDb : float = -15.0

@onready var _soundPool :Node= $SoundPool;


const MIN_DB : float= -80.0

var _soundtrackLayers : Array = []
func _ready():
	var sl : Array[SoundtrackPart] = []
	self._soundtrackLayers = NodeUtils.get_children_of_type($SoundtrackLayers, SoundtrackPart, sl) as Array[SoundtrackPart];
	

func _get_sound_player()->AudioStreamPlayer:
	for c in _soundPool.get_children():
		var stream := c as AudioStreamPlayer
		if !stream.is_playing(): return stream
	var ret = AudioStreamPlayer.new();
	_soundPool.add_child(ret);
	return ret;

func PlaySound(sound: AudioStream, pitch: float = 1, volume_db: float=0)->AudioStreamPlayer:
	var player := _get_sound_player()
	player.stream = sound
	player.volume_db = volume_db
	player.pitch_scale = pitch
	player.play()
	return player


func StopPlayGradually(player: AudioStreamPlayer, fadeout_seconds: float)->void:
	if !player.playing: 
		ErrorUtils.report_error("Calling StopGradually on player '%s' which isn't playing anything"%[player.name])
	var tw := create_tween()
	tw.tween_property(player, "volume_db", minReasonableDb, fadeout_seconds)
	tw.tween_callback(player.stop).set_delay(fadeout_seconds)

var _running_tweens : Array[Tween] = []

func _compute_intensity(decibel_layers: Array[float], intensity_floor: int, intensity_factor: float)->float:
	if intensity_floor < 0 || decibel_layers.size()<= 1: return decibel_layers[0]
	if intensity_floor+1 >= decibel_layers.size(): return decibel_layers[decibel_layers.size()-1]
	return lerpf(decibel_layers[intensity_floor], decibel_layers[intensity_floor + 1], intensity_factor)

func SetSoundtrackIntensity(intensity: float)->void:
	for tw in _running_tweens: tw.stop() 
	_running_tweens.clear()
	
	var intensity_floor := int(floorf(intensity))
	var intensity_factor := intensity - intensity_floor
	
	var i:int = 0
	while i < _soundtrackLayers.size():
		var layer : SoundtrackPart= _soundtrackLayers[i]
		
		var db := _compute_intensity(layer.decibels, intensity_floor, intensity_factor)
		
		if layer.volume_db != db:
			var tw := create_tween()
			tw.tween_property(layer, "volume_db", db, soundtrackTransition_seconds)
			_running_tweens.append(tw)
		i+= 1
		
func GetSoundtrackLayer(idx: int)->SoundtrackPart:
	return self._soundtrackLayers[idx]
