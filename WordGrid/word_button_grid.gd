extends GridContainer

func _ready():
	for child in get_children():
		if child is not WordButton:
			continue
		child.add_theme_font_size_override("font_size", 32)

func set_word_usage(button: WordButton):
	for child in get_children():
		if child is not WordButton:
			continue
		if child == button:
			child.update_usage(2)
			continue
		child.update_usage(-1)
		if child.usage < 0:
			child.usage = 0

func set_word_usage_to_zero():
	for child in get_children():
		if child is WordButton:
			child.usage = 0
