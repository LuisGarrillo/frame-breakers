extends Node2D
class_name WallsHolder
@export var wallA : Wall
@export var wallB : Wall
const UPPER_WALLS = preload("res://scenes/level/upper_walls.tscn")
const WALLS = preload("res://scenes/level/walls.tscn")

func _physics_process(delta: float) -> void:
	update_wall(delta)
	
func update_wall(delta):
	wallA.position.x -= roundf(Global.speed * delta)
	wallB.position.x -= roundf(Global.speed * delta)
	var comparison_position = (
		(Global.screen_width / 2) + Global.wall_width + (Global.wall_width - Global.screen_width) / 2
	)
	if wallA.position.x <= comparison_position * -1:
		switch_walls(wallA.side)
	
func switch_walls(side) -> void:
	remove_child(wallA)
	wallA = wallB
	wallB = WALLS.instantiate() if side == "lower" else UPPER_WALLS.instantiate()
	add_child(wallB)

	wallB.position.x = (wallA.position.x + 640)
