extends TileMapLayer
class_name Wall
signal wall_switch

func _physics_process(delta: float) -> void:
	position.x -= Global.speed * delta
	if position.x <= (Global.screen_width * -1.5):
		wall_switch.emit()
