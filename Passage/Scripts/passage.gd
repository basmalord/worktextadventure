extends CanvasLayer
class_name Passage

var next_passage: String
var valid_inputs: Dictionary
var input_strings: Array
var data: Dictionary
@export var passage_json_file_location: String
@export var passage_json_files_folder: String
@onready var output_box: RichTextLabel = $OutputBox
@onready var input_box: LineEdit = $InputBox
@onready var visuals: VideoStreamPlayer = $Visuals

func _ready():
	load_passage()

func load_passage():
	if passage_json_file_location == null:
		print("ERROR: NO JSON FILE LOCATION SET")
		return
	var passage_json_file = FileAccess.open(passage_json_file_location, FileAccess.READ)
	if passage_json_file:
		var text = passage_json_file.get_as_text()
		var new_json = JSON.new()
		var json_data = new_json.parse(text)
		if json_data != OK:
			print("ERROR: PASSAGE TEXT DATA IS NOT JSON FORMATTED")
			return
		data = new_json.data
		output_box.text = data["passage_text"]
		valid_inputs = data["inputs"]
		input_strings = valid_inputs.keys()
		print(input_strings)


func _on_input_box_text_submitted(player_input_text: String) -> void:
	if player_input_text == "":
		return
	if valid_inputs == {}:
		print("ERROR: NO VALID INPUTS DETECTED IN PASSAGE")
		return
	if input_strings.find(player_input_text.to_lower()) != -1:
		passage_json_file_location = passage_json_files_folder + valid_inputs[player_input_text]["passage_name"] + ".txt"
		load_passage()
