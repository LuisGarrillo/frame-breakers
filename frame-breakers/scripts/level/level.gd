extends Node2D
class_name Level

@onready var player: Player = $Player
@onready var projectiles_holder: Node2D = $ProjectilesHolder
@onready var hazard_holder: Node2D = $HazardHolder
@onready var enemies_holder: Node2D = $EnemiesHolder
@onready var walls_holder: Node2D = $WallsHolderA

@export var time_ratio : int = 30
@export var speed_change_ratio : float = 1.2
var frame_accumulator : float = 0
var accumulator := 0

const PLAYER_PROJECTILE = preload("res://scenes/level/projectiles/player_projectile.tscn")

func _physics_process(delta: float) -> void:
	frame_accumulator += delta
	if frame_accumulator > 1:
		frame_accumulator = 0
		accumulator += 1
	
	if accumulator == time_ratio:
		accumulator = 0
		Global.speed *= speed_change_ratio

func _on_player_add_projectile() -> void:
	var new_projectile = PLAYER_PROJECTILE.instantiate()
	projectiles_holder.add_child(new_projectile)
	new_projectile.position.y = player.position.y
	new_projectile.set_up("Ally", 1)
