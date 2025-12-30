@tool
class_name DialogSystem
extends SomeDialogContainer

@export var default_start : IDialogAction
@export var run_on_start : bool = false
@export var default_text_box : PrettyTextBox

func _ready() -> void:
	if Engine.is_editor_hint(): return
	if run_on_start: do_run(default_start)

func do_run(start: IDialogAction = null, on_everything_finished: Callable = Callable())->void:
	if not start: start = NodeUtils.get_child_of_type(self, IDialogAction) as IDialogAction
	assert(start, "No starting dialog action was found for dialog system {0}".format([self.name]))
	
	var ctx := DialogContext.new()
	ctx.default_text_box = default_text_box
	do_run_subtree(start, ctx, on_everything_finished)
	
static func do_run_subtree(start: IDialogAction, ctx : DialogContext, on_everything_finished: Callable = Callable())->void:
	var runner := ActionRunner.new(ctx, on_everything_finished)
	runner.iteration(start)



class ActionRunner:
	extends RefCounted
	var ctx: DialogContext
	var current : IDialogAction
	var on_everything_finished : Callable
	
	func _init(the_ctx: DialogContext, the_on_everything_finished : Callable)->void:
		ctx = the_ctx
		current = null
		on_everything_finished = the_on_everything_finished
	
	func iteration(next: IDialogAction)->void:
		if not next: next = DialogSystem.get_default_next(current, ctx)
		if not next:
			print("Finished, at node {0}".format([current.name]))
			if on_everything_finished: on_everything_finished.call(current)
			return
		current = next
		print("Performing node {0}".format([next.name]))
		var next_iteration : Callable = func(n)->void: iteration(n)
		current.do_perform(ctx, next_iteration)


static func get_default_next(a: Node, ctx: DialogContext)->IDialogAction:
	print("getting default next!")
	var include_internal := true
	var parent:= a.get_parent()
	while parent:
		var start_idx:= a.get_index(include_internal) + 1
		for current_idx in Vector2i(start_idx, parent.get_child_count(include_internal)):
			var next := parent.get_child(current_idx, include_internal) as IDialogAction
			if next: return next
		if parent is DialogSystem or parent is DialogCoroutine: break
		a = parent
		parent = parent.get_parent()
	var last_call_stack_frame := ctx.pop_stack_frame()
	if last_call_stack_frame:
		return get_default_next(last_call_stack_frame.caller, ctx)
	return null
		
