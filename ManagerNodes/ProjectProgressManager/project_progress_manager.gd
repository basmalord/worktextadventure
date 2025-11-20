extends Control
class_name ProjectProgressManager

@export var progress: int = 0

@onready var progress_bar: ColorRect = $ProgressBar
@onready var progress_label: RichTextLabel = $ProgressLabel

var progress_to_progress_bar_size_ratio
var full_progress = 100

func _ready():
	progress_to_progress_bar_size_ratio = progress_bar.size.x / full_progress
	_set_progress_bar_size()
	progress_label.text = "Project Progress"

func _set_progress_bar_size():
	progress_bar.size.x = progress_to_progress_bar_size_ratio * progress

func update_progress(progress_to_add: int):
	if progress + progress_to_add > 100:
		progress = 100
	elif progress + progress_to_add < 0:
		progress = 0
	else:
		progress += progress_to_add
