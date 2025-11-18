extends Button

class_name WordButton

@export_enum("Default",
"Enthusiasm",
"Dedication", 
"Realism", 
"Compassion", 
"Success", 
"Profit",
"Environment",
"Ethics",
"Relax") var word: String = "Default"
@export var usage: int = 10

func _ready():
	self.pressed.connect(_on_pressed)
	set_word(word)

func set_word(word_to_set: String):
	text = word_to_set
	word = word_to_set



func _on_pressed() -> void:
	if get_tree().get_first_node_in_group("Passage") == null:
		print("ERROR: NO PASSAGE NODE IN SCENE")
		return
	var passage = get_tree().get_first_node_in_group("Passage")
	passage._on_input_box_text_submitted(word)
	print("Worked")
	passage._on_input_box_text_submitted(word)#
	get_parent().set_word_usage(self)
	print("Worked")

func update_usage(amount: int):
	usage += amount
	set_transparency_based_on_usage()

func set_transparency_based_on_usage():
	var c = get_theme_color("font_color")
	c.a = c.a * float(usage / 10.0)
	add_theme_color_override("font_color", c)
