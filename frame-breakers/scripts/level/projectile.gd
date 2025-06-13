extends Area2D
class_name Projectile
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@export var limit : int = 960
var direction
var type : String
@export var increase = 1.25

func _ready() -> void:
	animated_sprite_2d.play("default")

func _physics_process(delta: float) -> void:
	position.x += Global.speed * increase * delta * direction
	if position.x < limit * -1 or position.x > limit:
		queue_free()

func set_up(setup_direction, setup_type) -> void:
	direction = setup_direction
	type = setup_type


func hitted():
	queue_free()


func _on_area_entered(area: Area2D) -> void:
	print("hi")
