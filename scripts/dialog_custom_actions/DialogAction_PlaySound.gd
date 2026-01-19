extends IDialogAction


@export var stream: AudioStream;
@export var pitch_min : float = 1
@export var pitch_max : float = 1
@export var volume_db : float = 0

@export var wait_for_finish : bool = false


func do_perform(ctx: DialogContext, on_finished: Callable)->void:
	var pitch := randf_range(pitch_min, pitch_max) if pitch_min < pitch_max else pitch_min
	var player := SoundManager.PlaySound(stream, pitch, volume_db)
	if wait_for_finish:
		await player.finished
	_default_perform(ctx, on_finished)
