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
