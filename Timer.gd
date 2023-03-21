extends RichTextLabel

func _process(delta: float) -> void:
	print(Time.get_unix_time_from_system())
