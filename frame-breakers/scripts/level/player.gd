extends CharacterBody2D
class_name Player

var direction_map : Dictionary[int, int] = {
	KEY_DOWN : 1,
	KEY_UP: -1,
}

var lower_range = Global.carril_size * -1
var upper_range = Global.carril_size

func _input(event: InputEvent) -> void:
	
	if Input.is_action_just_pressed("Move"):
		move(direction_map[event.keycode])

func move(direction) -> void:
	var position_range = range(Global.carril_size * -1, Global.carril_size + 1)
	var change_value = Global.carril_size * direction
	
	if position.y + change_value < lower_range or position.y + change_value > upper_range:
		return
		
	position.y += change_value
	
func attack() -> void:
	pass
	
func die() -> void:
	pass
