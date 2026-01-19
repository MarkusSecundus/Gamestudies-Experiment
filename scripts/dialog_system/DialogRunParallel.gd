extends IDialogAction


func do_perform(ctx: DialogContext, on_finished: Callable)->void:
	
	var children : Array[IDialogAction]
	children = NodeUtils.get_children_of_type(self, IDialogAction, children)
	var success_counter := DatastructUtils.Wrapper.new(0)
	for ch in children:
		DialogSystem.do_run_subtree(ch, ctx, func(_last:IDialogAction)->void:
			success_counter.value += 1
			if success_counter.value == children.size():
				_default_perform(ctx, on_finished)
		)
	
