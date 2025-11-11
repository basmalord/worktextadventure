extends Node
class_name Parser

@export var verbs: Array[String]
@export var nouns: Array[String]
@onready var interactables = get_parent().interactables


func _ready():
	pass


func load_verbs_and_nouns():
	if get_parent() == null:
		print("ERROR: PARSER HAS NO PARENT")
		return
	if get_parent() is not Passage:
		print("ERROR: PARSER PARENT IS NOT LEVEL")
		return
	for interactable in interactables.size():
		var interactable_verbs_description_array = interactables[interactable].verbs_and_description
		for vd in interactable_verbs_description_array.size():
			var verb = interactable_verbs_description_array[vd].verb
			var noun = interactables[interactable].interactable_name 
			verbs.append(verb)
			nouns.append(noun)



func _on_player_text_received(player_text: String) -> void:
	var player_text_to_lower = player_text.to_lower()
	var interactables = get_parent().interactables
	if verbs.size() == 0:
		print("ERROR: NO VERBS PRESENT IN LEVEL")
		return
	var verbs_in_text: Array[String]
	var verb_to_check: String
	for verb in verbs:
		if player_text_to_lower.find(verb.to_lower()) != -1:
			verbs_in_text.append(verb)
	if verbs_in_text.size() == 0:
		print("I'M SORRY, I DON'T KNOW WHAT YOU'RE TALKING ABOUT")
		return
	verb_to_check = verbs_in_text[0]
	if verbs_in_text.size() > 1:
		print("ERROR: MULTIPLE VERBS DETECTED, SELECTING FIRST")
	var double_error_print_check: bool = false
	for interactable in interactables:
		if player_text_to_lower.find(interactable.interactable_name.to_lower()) != -1:
			print("working3")
			var interactable_vd = interactable.verbs_and_description
			for vd in interactable_vd:
				var verb_to_output = vd.verb
				if verb_to_check.to_lower() == verb_to_output.to_lower():
					print(vd.description)
					return
		else:
			if !double_error_print_check:
				print("WHAT WOULD YOU LIKE TO ", verb_to_check, "?")
				double_error_print_check = true
