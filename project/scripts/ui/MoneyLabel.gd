extends RichTextLabel

# Use <> to insert money count
@export var format_text : String = "<>€"

var displayed_value : float : set=set_displayed_value

@export var tween_time : float=0.3
@export var tween_ease : Tween.EaseType = Tween.EaseType.EASE_OUT
@export var tween_transition : Tween.TransitionType = Tween.TransitionType.TRANS_QUAD

var tween : Tween

func set_target_value(new_target_value,direct=false):
	if direct:
		set_displayed_value(new_target_value)
	else:
		tween = create_tween()
		tween  \
			.tween_method(set_displayed_value,displayed_value,new_target_value,tween_time)\
			.set_ease(tween_ease)\
			.set_trans(tween_transition)

func set_displayed_value(new_displayed_value):
	displayed_value=snappedf(new_displayed_value,0.01)
	text=format_text.replace("<>",str(displayed_value))
