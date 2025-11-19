extends ASCIImageGenerator

@export var new_video_frame_rate: int = 4
@export var frames_folder_path: String
@export var frames_folder_absolute_path: String
@export var video_frames_name: String = "frame"
@export var image_format: String = ".png"
var frame_suffix = "000"
func _ready():
	var ffmpeg_path = "ffmpeg"  # or full path like "C:/ffmpeg/bin/ffmpeg.exe"
	var args = ["-version"]
	var exit_code = OS.execute(ffmpeg_path, args,[], true, true)
	if exit_code == 0:
		print("FFmpeg is available!")
	else:
		print("Failed to run FFmpeg. Exit code:", exit_code)
	generate_frames()

func generate_frames():
	var video = load(visual_location)
	if video is not VideoStream:
		print("ERROR: VISUAL LOCATION DOES NOT LEAD TO VIDEO")
		return
	var video_player = VideoStreamPlayer.new()
	video_player.stream = video
	var video_length_s = video_player.get_stream_length()
	var frame_length_s = 1.0 / new_video_frame_rate
	var number_of_frames_to_collect = video_length_s / frame_length_s
	print("THIS IS NO OF FRAMES TO COLELCT: ", number_of_frames_to_collect)
	for i in number_of_frames_to_collect:
		var output_path_godot: String = frames_folder_path + "/" + video_frames_name + frame_suffix + str(int(i)) + image_format
		var output_path_absolute: String = frames_folder_absolute_path + "/" + video_frames_name + frame_suffix + str(int(i)) + image_format
		print(output_path_absolute)
		extract_frame(visual_location, int(i) * frame_length_s, output_path_absolute)
		image_to_asci(output_path_godot)
		if i == 9:
			print("worked")
			call_ffmpeg_to_generate_video_from_frames()

func ffmpeg_test():
	var ffmpeg_path = "ffmpeg"  # or full path like "C:/ffmpeg/bin/ffmpeg.exe"
	var args = ["-version"]
	var exit_code = OS.execute(ffmpeg_path, args, [], true, true)
	if exit_code == 0:
		print("FFmpeg is available!")
	else:
		print("Failed to run FFmpeg. Exit code:", exit_code)

func extract_frame(video_path: String, time_stamp: float, output_path: String):
	#ffmpeg_test()
	var ffmpeg_path = "ffmpeg"
	var args = [
	"-ss", str(time_stamp),
	"-i", video_path,
	"-frames:v", "1",
	output_path
	]
	print(args)
	var exit_code = OS.execute(ffmpeg_path, args, [],  true, false)
	print(exit_code)
	return exit_code == 0

func call_ffmpeg_to_generate_video_from_frames():
	var ffmpeg_path = "ffmpeg"
	var args = [
		"-framerate", new_video_frame_rate,
		"-i", frames_folder_absolute_path + video_frames_name + "_%04d" + image_format,
		"-c:v", "libx264",
		"-pix_fmt", "yuv420p",
		ProjectSettings.globalize_path("res://Video/")
	]
	var exit_code = OS.execute(ffmpeg_path, args ,[], true, false)
	print("THIS IS FINAL EXIT CODE: ", exit_code)
	return exit_code == 0
