extends Node2D
class_name Level

@onready var player: Player = $Player
@onready var projectiles_holder: Node2D = $ProjectilesHolder
@onready var hazard_holder: Node2D = $HazardHolder
@onready var enemies_holder: Node2D = $EnemiesHolder
@onready var walls_holder: Node2D = $WallsHolder

const PLAYER_PROJECTILE = preload("res://scenes/level/projectiles/player_projectile.tscn")

func _on_player_add_projectile() -> void:
	var new_projectile = PLAYER_PROJECTILE.instantiate()
	projectiles_holder.add_child(new_projectile)
	new_projectile.set_up("Ally", 1)
