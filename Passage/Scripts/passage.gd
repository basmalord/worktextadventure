extends CanvasLayer
class_name Passage

var next_passage: String
var valid_inputs: Dictionary
var input_strings: Array
var amount_of_continue_presses: int = 0
var passage_parts_array: Array = []
var data: Dictionary
var part_number: int
@export var passage_json_file_location: String
@export var passage_json_files_folder: String
@onready var output_box: RichTextLabel = $OutputBox
@onready var input_box: LineEdit = $InputBox
@onready var visuals: VideoStreamPlayer = $Visuals
@onready var reputation_manager: ReputationManager = $ReputationManager
@onready var progress_manager: ProjectProgressManager = $ProjectProgressManager
@onready var time_manager = $TimeManager
@onready var continue_button: Button = $ContinueButton
@onready var word_grid = $WordGrid


func _ready():
	load_passage()


func load_passage(): #This loads the json file associated with the passage we want to access.
	if passage_json_file_location == null: #This checks if there is data harboured in the file location variable.
		print("ERROR: NO JSON FILE LOCATION SET")
		return
	var passage_json_file = FileAccess.open(passage_json_file_location, FileAccess.READ) #This tells godot to access the file for reading purposes.
	if passage_json_file: #Below is the process for turning the string data of the file into json data, allowing us to take the information in it and apply it to the game scene, thus making a passage.
		var text = passage_json_file.get_as_text()
		var new_json = JSON.new()
		var json_data = new_json.parse(text)
		if json_data != OK:
			print("ERROR: PASSAGE TEXT DATA IS NOT JSON FORMATTED")
			return
		data = new_json.data
		continue_passage()
		valid_inputs = data["inputs"]
		input_strings = valid_inputs.keys()

func continue_passage():
	print("AM CON PRES: ", amount_of_continue_presses)
	passage_parts_array = data["passage_text"]["parts"]
	var available_parts = get_available_parts(passage_parts_array, generate_state())
	var part_text = available_parts[0]["text"]
	part_number = passage_parts_array.find(available_parts[0])
	check_for_response_required(data)
	output_box.text = part_text

func check_for_response_required(passage_data):
	if passage_data["passage_text"] == null:
		print("ERROR: PASSAGE DATA DOES NOT CONTAIN PASSAGE TEXT KEY")
		return
	if data["passage_text"]["parts"][part_number]["response_required"] == true:
		for child in word_grid.get_child(0).get_children():
			if child is WordButton:
				child.disabled = false
		continue_button.hide()
		reset_continues()
	else:
		for child in word_grid.get_child(0).get_children():
			if child is WordButton:
				child.disabled = true
				print("bozo")
		continue_button.show()
		amount_of_continue_presses += 1

func generate_state():
	var state: Dictionary
	state["reputation"] = reputation_manager.reputation_type_dictionary
	state["progress"] = progress_manager.progress
	state["continue"] = amount_of_continue_presses
	return state

func get_available_parts(parts: Array, state: Dictionary):
	var available = []
	for part in parts:
		if check_conditions(part,state):
			available.append(part)
	return available

func check_conditions(part: Dictionary, state: Dictionary): #takes a part of the passage, compares its conditions to the gamestate, returns false if no match, true otherwise.
	for key in part["conditions"].keys():
		var cond_val = part["conditions"][key]
		if typeof(cond_val) == TYPE_DICTIONARY:
			for subkey in cond_val.keys():
				if state[key][subkey] != cond_val[subkey]:
					return false
		else:
			if state[key] != cond_val:
				return false
	return true

func reset_continues():
	amount_of_continue_presses = 0

func test_json():
	var json_file = FileAccess.open("res://JSON Files/template.txt", FileAccess.READ)
	var text = json_file.get_as_text()
	var new_json = JSON.new()
	var json_data = new_json.parse(text)
	if json_data != OK:
		print("NOOOOOO")
		return
	print(json_data)

func _on_input_box_text_submitted(player_input_text: String) -> void: #This fires when the input box is selected by the player and they hit 'ENTER'.
	if player_input_text == "": #This checks whether the text inputted is empty
		print("ERROR: EMPTY TEXT INPUT")
		return
	if valid_inputs == {}: #This checks whether the passage the player is on has valid inputs.
		print("ERROR: NO VALID INPUTS DETECTED IN PASSAGE")
		return
	if input_strings.find(player_input_text.to_lower()) != -1: #This checks whether the text inputted by the player matches any of the inputs associated with the passage.
		passage_json_file_location = passage_json_files_folder + valid_inputs[player_input_text.to_lower()]["passage_name"] + ".txt"
		print(valid_inputs[player_input_text.to_lower()]["passage_name"])
		load_passage()
