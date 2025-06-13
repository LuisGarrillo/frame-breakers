extends CharacterBody2D
class_name Enemy
@onready var shoot_timer: Timer = $ShootTimer
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var shoot_cooldown : float

signal shoot
signal death

var carril : int
var enter_limit = (Global.screen_width / 2) - 48

func _ready() -> void:
	shoot_timer.wait_time = shoot_cooldown

func _process(delta: float) -> void:
	enter(delta)

func enter(delta) -> void:
	if position.x >= enter_limit:
		position.x -= Global.speed * delta * 2

func die():
	death.emit(carril)
	queue_free()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area is Projectile and area.type == "Ally":
		die()

func _on_shoot_timer_timeout() -> void:
	shoot.emit(carril)
