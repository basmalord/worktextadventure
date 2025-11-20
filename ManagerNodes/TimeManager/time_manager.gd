extends Control

@onready var clock: Control = $Clock

@export_range(0,1,23) var hour: float
@export_range(0,1,59) var minute: int

func set_time(hours_to_add: float):
	var minutes_as_hours = minute / 60
	hour += minutes_as_hours
	hour += hours_to_add
	var hour_remainder_as_minutes = ( hour - floor(hour) ) * 60
	hour = floor(hour)
