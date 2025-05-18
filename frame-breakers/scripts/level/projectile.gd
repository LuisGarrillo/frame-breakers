extends Area2D
class_name Projectile

var masks_map: Dictionary[String, int] = {
	"Ally": 1,
	"Enemy": 0
}
var direction

func _physics_process(delta: float) -> void:
	position.x += Global.speed * delta * direction

func set_up(mode, setup_direction) -> void:
	set_collision_mask_value(masks_map[mode], true)
	direction = setup_direction


func _on_body_entered(body: Node2D) -> void:
	if not body is CharacterBody2D:
		return
	
	if body is Player:
		body.damage()
