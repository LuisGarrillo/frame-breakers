extends Node2D
class_name WallsHolder
@export var wallA : Wall
@export var wallB : Wall
const UPPER_WALLS = preload("res://scenes/level/upper_walls.tscn")
const WALLS = preload("res://scenes/level/walls.tscn")

func _ready() -> void:
	set_up_wall(wallA)
	set_up_wall(wallB)

func set_up_wall(wall : Wall) -> void:
	wall.wall_switch.connect(switch_walls)
	
func switch_walls(side) -> void:
	remove_child(wallA)
	wallA = wallB
	wallB = WALLS.instantiate() if side == "lower" else UPPER_WALLS.instantiate()
	add_child(wallB)
	set_up_wall(wallB)

	wallB.position.x = Global.screen_width / 2
