extends CharacterBody2D
class_name Player
@onready var shoot_cooldown: Timer = $ShootCooldown

signal sig_die
signal add_projectile


var direction_map : Dictionary[int, int] = {
	KEY_DOWN : 1,
	KEY_UP: -1,
	KEY_RIGHT: 1,
	KEY_LEFT: -1
}

var lower_range = Global.carril_size * -1
var upper_range = Global.carril_size

var right_range = (Global.screen_width / 2) - 32 * 2
var left_range = right_range * -1

var is_locked := false

var initial_speed = Global.speed

func _physics_process(delta: float) -> void:
	move_horizontal(Input.get_axis("left", "right"), delta)
	move_and_slide()

func _input(event: InputEvent) -> void:
	if is_locked:
		return
	
	move(Input.get_axis("up", "down"))
	
	if Input.is_action_just_pressed("Attack"):
		attack()

func move(direction) -> void:
	var change_value = Global.carril_size * direction
	
	if position.y + change_value < lower_range or position.y + change_value > upper_range:
		return
		
	position.y += change_value

func move_horizontal(direction, delta) -> void:
	if not direction:
		return
		
	var change_value
	if direction > 0:
		change_value = max(initial_speed * delta - ((Global.speed * delta) / 2), 1)
	else:
		change_value = Global.speed * delta * -1
	
	if position.x + change_value < left_range or position.x + change_value > right_range:
		return
	
	position.x += change_value

func attack() -> void:
	add_projectile.emit()
	is_locked = true
	shoot_cooldown.start()
	
func damage() -> void:
	var change_value = 0.125 * Global.speed
	position.x -= change_value

func die() -> void:
	sig_die.emit()


func _on_shoot_cooldown_timeout() -> void:
	is_locked = false


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area is Projectile and area.type == "Enemy":
		damage()
		area.hitted()
