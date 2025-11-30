extends Node2D
class_name ASCIImageGenerator

@export var visual_location: String
@export_range(0,400,1) var max_character_width: int = 120 #controls the "resolution" of the outputted ASCII
#@export var image_name: String #is given to the file that is saved in the Images folder
@export var blank_space_detailing = 3 #controls the amount of pixels taken up by blank space
@export var output_resolution_multiplier: int = 2
@export var is_video: bool = false
@export var font_path: String = "res://Fonts/ModernDOS8x16.ttf"
@export var character_list: String = "Ø¶Ňý0ÐWφXã¥@3%fz*±(>|÷=;:,∙·"
@export var flip_char_list: bool = false
@export var save_as_image: bool = true
@export var save_as_text: bool = true
@export var use_custom_file_name: bool = false
@export var custom_file_name: String
@export var use_custom_output_location: bool = false
@export var custom_output_location: String = "res://Images/"

var visual_resource
var visual_node
var frame: int = 0

func _ready():
	image_to_ascii(visual_location)




func get_character_w_and_h(font_path: String, size: int):
	var font = load(font_path)
	var codepoint = "A".unicode_at(0)
	var char_w = font.get_char_size(codepoint, size).x
	var char_h = font.get_height(size)
	return [char_w, char_h]


func load_visual_resource():
	if visual_location.is_empty():
		print("ERROR: NO FILE PATH PROVIDED FOR VISUAL")
		return
	var visual_resource := ResourceLoader.load(visual_location)
	if visual_resource == null:
		print("ERROR: FAILED TO LOAD VISUAL RESOURCE FROM FILE PATH")
		return
	generate_visual_node(visual_resource)

func generate_visual_node(visual_resource: Resource):
	if visual_resource is Texture2D:
		visual_node = Sprite2D.new()
		add_child(visual_node)
		visual_node.texture = visual_resource
		return visual_node
	elif visual_resource is VideoStream:
		visual_node = VideoStreamPlayer.new()
		add_child(visual_node)
		visual_node.stream = visual_resource
		visual_node.play()
		return visual_node
	else:
		print("ERROR IN GENERATING VISUAL NODE: VISUAL RESOURCE LOADED FROM FILEPATH IS NEITHER VIDEO OR IMAGE")
		return null



func image_to_ascii(path: String, op_folder: String = custom_output_location, char_list := character_list):
	var blank_space: String = ""
	for n in blank_space_detailing:
		blank_space += " ".repeat(n)
	char_list = char_list + blank_space
	if !flip_char_list:
		char_list = char_list.reverse()
	var ascii_text: String = "" #always initialise a string
	if flip_char_list:
		char_list = char_list.reverse()
	var asci_text: String = "" #alaways initialise a string
	var img := Image.new()
	var err := img.load(path)
	if err != OK:
		print("ERROR WHEN TRYING TO LOAD IMAGE FOR ASCII GENEN")
		return ""
	var image_ratio: float = float(img.get_height())/img.get_width() #separated the image and character ratio to fix image output
	var character_width = get_character_w_and_h(font_path, 16)[0]
	var character_height = get_character_w_and_h(font_path, 16)[1]
	var character_ratio = character_width / character_height
	var new_w = max_character_width
	var new_h
	print("Image Ratio = ", image_ratio)
	print("Character Ratio = ", character_ratio)
	if image_ratio >= 1:
		new_h = new_w / (character_ratio * image_ratio)
	else:
		new_h = new_w * (character_ratio * image_ratio)
	img.resize(new_w, new_h, Image.INTERPOLATE_BILINEAR)
	#if is_video:
		#img.flip_y()
	for y in range(new_h):
		for x in range(new_w):
			var c = img.get_pixel(x,y)
			var bright = (c.r + c.g + c.b) / 3.0
			var index = int(bright * float(char_list.length() - 1))
			ascii_text += char_list[index]
		ascii_text += "\n"
	var viewport_for_ascii_to_image = SubViewport.new()
	var viewport_container = SubViewportContainer.new()
	add_child(viewport_container)
	var label = Label.new()
	label.text = ascii_text
	label.set_autowrap_mode(TextServer.AUTOWRAP_OFF)
	label.set_vertical_alignment(VERTICAL_ALIGNMENT_TOP)
	var new_font = load(font_path)
	label.add_theme_font_override("font", new_font)
	label.add_theme_color_override("font_color", Color.WHITE)
	label.add_theme_font_size_override("font_size", 16 * output_resolution_multiplier)
	label.add_theme_constant_override("line_spacing", 0)
	viewport_container.add_child(viewport_for_ascii_to_image)
	await get_tree().process_frame
	viewport_for_ascii_to_image.size.x = character_width * new_w * output_resolution_multiplier
	viewport_for_ascii_to_image.size.y = character_height * new_h * output_resolution_multiplier
	#viewport_for_ascii_to_image.size.x = viewport_for_ascii_to_image.size.x * 1.5 #added this to make a vid work
	viewport_for_ascii_to_image.set_update_mode(SubViewport.UPDATE_ALWAYS)
	viewport_for_ascii_to_image.disable_3d = true
	viewport_for_ascii_to_image.transparent_bg = false
	viewport_for_ascii_to_image.add_child(label)
	label.size = label.get_minimum_size()
	#viewport_for_ascii_to_image.size = label.size
	#viewport_for_ascii_to_image.size.y = viewport_for_ascii_to_image.size.y * ratio
	#viewport_for_ascii_to_image.size.x = viewport_for_ascii_to_image.size.x * 1.5 
	viewport_for_ascii_to_image.set_update_mode(SubViewport.UPDATE_ALWAYS)
	viewport_for_ascii_to_image.disable_3d = true
	viewport_for_ascii_to_image.transparent_bg = false
	viewport_for_ascii_to_image.add_child(label)
	await RenderingServer.frame_post_draw
	if is_video:
		viewport_for_ascii_to_image.get_texture().get_image().flip_y()
	var output_image = viewport_for_ascii_to_image.get_texture().get_image()
	#print(output_image)
	var file_name: String
	if !use_custom_output_location:
		op_folder = visual_location.left(visual_location.rfind("/") + 1) #uses source image location
	if !use_custom_file_name:
		file_name = visual_location.left(-len(visual_location.get_extension()) - 1) #remove file extension
		file_name = file_name.right(-file_name.rfind("/")-1) #remove file path
		file_name = file_name + "ASCII" #add ASCII
	else:
		file_name = custom_file_name
	print(file_name)
	if save_as_image:
		if is_video:
			file_name = file_name + "frame" + "000" + str(frame)
			frame += 1
		if output_image.save_png(op_folder + file_name + ".png"):
			print("Saved ASCII IMAGE")
		else:
			print("ERROR IN SAVING ASCII IMAGE")
	if save_as_text:
		save_ascii_to_file("res://ASCII text files/" + file_name + ".txt", label.text)
	#viewport_for_ascii_to_image.queue_free()


func save_ascii_to_file(path: String, content: String) -> void:
	var file := FileAccess.open(path, FileAccess.WRITE)
	if file == null:
		push_error("Failed to open file for writing: " + path)
		return
	file.store_string(content)
	file.close()
