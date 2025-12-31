extends Object
class_name EffectsUtils

static func do_particles_one_shot(particles: GPUParticles2D)->void:
	if !particles: return;
	particles.set_one_shot(true);
	particles.restart();

class TweenWrapper:
	var _tween : Tween
	var _tree : SceneTree
	func _init(obj: Node):
		_tree = obj.get_tree()
	
	func do_property(object: Object, property: NodePath, final_var: Variant, duration: float)->Tween:
		if _tween and _tween.is_running():
			_tween.stop()
		_tween = _tree.create_tween()
		_tween.tween_property(object, property, final_var, duration)
		return _tween

static func do_fade(this: CanvasItem, end_alpha: float, duration_seconds: float, start_alpha: float = -1, hide_when_alpha_is_0 : bool = true)->PropertyTweener:
	var tw := this.create_tween()
	var end_color := this.modulate
	end_color.a = end_alpha
	if start_alpha >= 0.0:
		this.modulate.a = start_alpha
	this.visible = true
	var tweener = tw.tween_property(this, "modulate", end_color, duration_seconds)
	if (end_alpha <= 0.0) and hide_when_alpha_is_0:
		CoroutineUtils.run_on_signal_once(tweener.finished, func():
			this.visible = false
		)
	return tweener
