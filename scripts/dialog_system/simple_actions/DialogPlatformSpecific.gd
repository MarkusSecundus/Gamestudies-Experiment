@tool
extends IDialogAction

@export_flags("Windows:1", "Linux:2", "MacOS:4", "Android:8", "iOS:16", "Web:32", "BSD:64", "All:127") var platforms : int

const platform_mapping : Dictionary[String, int] = {
	"Windows" : 1,
	"Linux" : 2,
	"macOS" : 4,
	"Android" : 8,
	"iOS" : 16,
	"Web" : 32,
	"BSD" : 64,
	"FreeBSD" : 64,
	"OpenBSD" : 64,
	"NetBSD" : 64,
}

func do_perform(ctx: DialogContext, on_finished: Callable)->void:
	var platform_name := OS.get_name()
	var platform_flag := platform_mapping[platform_name]
	if platform_flag & platforms:
		var child := NodeUtils.get_child_of_type(self, IDialogAction) as IDialogAction
		assert(child)
		on_finished.call(child)
	else: 
		_default_perform(ctx, on_finished)
