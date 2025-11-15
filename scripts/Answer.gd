class_name Answer
extends RefCounted

var eye : String
var eyebrow : String
var iris : String
var pupil : String

var question_idx : int
var question_text : String

func serialize()->Dictionary[String, Variant]:
	var ret : Dictionary[String, Variant] = {}
	ret['eye'] = self.eye
	ret['eyebrow'] = self.eyebrow
	ret['iris'] = self.iris
	ret['pupil'] = self.pupil
	ret['question_idx'] = self.question_idx
	ret['question_text'] = self.question_text
	return ret
