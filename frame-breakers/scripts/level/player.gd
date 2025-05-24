extends CharacterBody2D
class_name Player
@onready var shoot_cooldown: Timer = $ShootCooldown

signal sig_die
signal add_projectile


var direction_map : Dictionary[int, int] = {
	KEY_DOWN : 1,
	KEY_UP: -1,
}

var lower_range = Global.carril_size * -1
var upper_range = Global.carril_size
var is_locked := false

func _input(event: InputEvent) -> void:
	if is_locked:
		return
	
	if Input.is_action_just_pressed("Move") and (event.keycode == KEY_UP or event.keycode == KEY_DOWN):
		move(direction_map[event.keycode])
	
	if Input.is_action_just_pressed("Attack"):
		attack()

func move(direction) -> void:
	var change_value = Global.carril_size * direction
	
	if position.y + change_value < lower_range or position.y + change_value > upper_range:
		return
		
	position.y += change_value
	
func attack() -> void:
	add_projectile.emit()
	is_locked = true
	shoot_cooldown.start()
	
func damage() -> void:
	var change_value = 0.75 * Global.speed
	position.x -= change_value

func die() -> void:
	sig_die.emit()


func _on_shoot_cooldown_timeout() -> void:
	is_locked = false
