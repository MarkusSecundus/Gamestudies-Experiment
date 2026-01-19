extends Object
class_name EffectsUtils

static func do_particles_one_shot(particles: GPUParticles2D)->void:
	if !particles: return;
	particles.set_one_shot(true);
	particles.restart();

class TweenWrapper:
	var _tween : Tween
	var obj : Node
	func _init(obj: Node):
		self.obj = obj
	
	func create_tween()->Tween:
		if _tween and _tween.is_running():
			_tween.kill()
		var tree := obj.get_tree()
		if tree: _tween = tree.create_tween()
		else: _tween = obj.create_tween()
		return _tween
	
	func do_property(object: Object, property: NodePath, final_var: Variant, duration: float)->PropertyTweener:
		return create_tween().tween_property(object, property, final_var, duration)
		
	func do_fade(this: CanvasItem, end_alpha: float, duration_seconds: float, start_alpha: float = -1, hide_when_alpha_is_0 : bool = true)->PropertyTweener:
		return EffectsUtils.do_fade_with_tween(create_tween(), this, end_alpha, duration_seconds, start_alpha, hide_when_alpha_is_0)

static func do_fade_with_tween(tw: Tween, this: CanvasItem, end_alpha: float, duration_seconds: float, start_alpha: float = -1, hide_when_alpha_is_0 : bool = true)->PropertyTweener:
	var end_color := this.modulate
	end_color.a = end_alpha
	if start_alpha >= 0.0:
		this.modulate.a = start_alpha
	elif not this.visible:
		this.modulate.a = 0.0
	this.visible = true
	var tweener = tw.tween_property(this, "modulate", end_color, duration_seconds)
	if (end_alpha <= 0.0) and hide_when_alpha_is_0:
		CoroutineUtils.run_on_signal_once(tweener.finished, func():
			this.visible = false
		)
	return tweener


static func do_fade(this: CanvasItem, end_alpha: float, duration_seconds: float, start_alpha: float = -1, hide_when_alpha_is_0 : bool = true)->PropertyTweener:
	return do_fade_with_tween(this.create_tween(), this, end_alpha, duration_seconds, start_alpha, hide_when_alpha_is_0)
