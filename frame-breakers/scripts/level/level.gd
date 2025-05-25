extends Node2D
class_name Level

@onready var player: Player = $Player
@onready var projectiles_holder: Node2D = $ProjectilesHolder
@onready var hazard_holder: Node2D = $HazardHolder
@onready var enemies_holder: Node2D = $EnemiesHolder
@onready var walls_holder: Node2D = $WallsHolderA
@onready var enemy_generation: Timer = $EnemyGeneration

@export var time_ratio : int = 30
@export var speed_change_ratio : float = 1.2

var frame_accumulator : float = 0
var accumulator := 0
var increment : int
var carrils = [0, 1 ,2]
var kill_count : int = 0
@export var enemy_wait_shoot_decreaser : float = 0.25
@export var enemy_wait_shoot : float = 1

var carril_map : Dictionary[int, Vector2] = {
	0: Vector2(Global.screen_width / 2, -32),
	1: Vector2(Global.screen_width / 2, 0),
	2: Vector2(Global.screen_width / 2, 32),
}

const PLAYER_PROJECTILE = preload("res://scenes/level/projectiles/player_projectile.tscn")
const ENEMY_PROJECTILE = preload("res://scenes/level/projectiles/enemy_projectile.tscn")
const ENEMY = preload("res://scenes/level/enemy.tscn")

func _physics_process(delta: float) -> void:
	if increment == 5:
		return
	
	frame_accumulator += delta
	if frame_accumulator > 1:
		frame_accumulator = 0
		accumulator += 1
	
	if accumulator == time_ratio:
		accumulator = 0
		increment += 1
		check_increment()
		Global.speed *= speed_change_ratio

func check_increment() -> void:
	if increment == 2:
		enemy_generation.wait_time = 3.5
	elif increment == 3:
		enemy_generation.wait_time = 1.5
		enemy_wait_shoot -= enemy_wait_shoot_decreaser
	elif increment == 5:
		enemy_generation.wait_time = 0.9
		enemy_wait_shoot -= enemy_wait_shoot_decreaser

func generate_enemy():
	if not carrils:
		return
	
	var new_enemy : Enemy = ENEMY.instantiate()
	var index = randi_range(0, len(carrils) - 1)
	var carril = carrils.pop_at(index)
	
	new_enemy.carril = carril
	new_enemy.shoot_cooldown = enemy_wait_shoot
	enemies_holder.add_child(new_enemy)
	new_enemy.position = carril_map[carril]
	new_enemy.shoot.connect(add_enemy_projectile)
	new_enemy.death.connect(enemy_death)

func enemy_death(carril):
	carrils.append(carril)
	kill_count += 1

func add_enemy_projectile(carril) -> void:
	var new_projectile = ENEMY_PROJECTILE.instantiate()
	projectiles_holder.add_child(new_projectile)
	new_projectile.position = Vector2((Global.screen_width / 2) - 48, carril_map[carril].y)
	new_projectile.set_up(-1, "Enemy")

func _on_player_add_projectile() -> void:
	var new_projectile = PLAYER_PROJECTILE.instantiate()
	projectiles_holder.add_child(new_projectile)
	new_projectile.position = player.position
	new_projectile.set_up(1, "Ally")


func _on_enemy_generation_timeout() -> void:
	generate_enemy()
