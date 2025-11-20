extends Node

class_name ReputationManager

@export var reputation_type_dictionary: Dictionary[String, int]

func add_reputation(points_to_add: int, reputation_type: String):
	if reputation_type_dictionary.keys().find(reputation_type) == -1:
		print("ERROR: REPUTATION TYPE NOT FOUND IN DICTIONARY")
		return
	reputation_type_dictionary[reputation_type] += points_to_add
