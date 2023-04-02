extends Label


@rpc("any_peer", "call_local")
func countdown():
	get_tree().paused = true
	text = "3"
	add_theme_color_override("font_color", Color("53ad71"))
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUART)
	tween.set_parallel(true)
	tween.tween_property(self, "scale", Vector2(1.2, 1.2), 0.5)
	tween.tween_property(self, "rotation_degrees", -15, 0.4)
	await tween.finished
	var tween2 = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUART)
	tween2.set_parallel(true)
	tween2.tween_property(self, "scale", Vector2.ZERO, 0.5)
	tween2.tween_property(self, "rotation_degrees", 0, 0.4)

	await tween2.finished
	text = "2"
	add_theme_color_override("font_color", Color("dfac3d"))
	var tween3 = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUART)
	tween3.set_parallel(true)
	tween3.tween_property(self, "scale", Vector2(1.3, 1.3), 0.5)
	tween3.tween_property(self, "rotation_degrees", 5, 0.4)
	await tween3.finished
	var tween4 = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUART)
	tween4.set_parallel(true)
	tween4.tween_property(self, "scale", Vector2.ZERO, 0.5)
	tween4.tween_property(self, "rotation_degrees", 0, 0.4)

	await tween4.finished
	text = "1"
	add_theme_color_override("font_color", Color("f35b75"))
	var tween5 = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUART)
	tween5.set_parallel(true)
	tween5.tween_property(self, "scale", Vector2(1.4, 1.4), 0.5)
	tween5.tween_property(self, "rotation_degrees", -3, 0.4)
	await tween5.finished
	var tween6 = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUART)
	tween6.set_parallel(true)
	tween6.tween_property(self, "scale", Vector2.ZERO, 0.5)
	tween6.tween_property(self, "rotation_degrees", 0, 0.4)
	await tween6.finished
	get_tree().paused = false
