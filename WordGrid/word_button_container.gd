extends GridContainer

func set_word_usage(button: WordButton):
	for child in get_children():
		if child is not WordButton:
			continue
		if child == button:
			child.update_usage(1)
			continue
		child.update_usage(-1)
