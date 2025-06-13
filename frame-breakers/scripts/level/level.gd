extends Node2D
class_name Level

@onready var player: Player = $Player
@onready var projectiles_holder: Node2D = $ProjectilesHolder
@onready var hazard_holder: Node2D = $HazardHolder
@onready var enemies_holder: Node2D = $EnemiesHolder
@onready var walls_holder: Node2D = $WallsHolderA
@onready var enemy_generation: Timer = $EnemyGeneration
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var tutorial_timer: Timer = $TutorialTimer

@export var time_ratio : int = 30
@export var speed_change_ratio : float = 1.2

var active : bool = false
var locked : bool = true
var on_game_over : bool = false
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

func _ready() -> void:
	$Sound/in.play()
	animation_player.play("in Title")

func _physics_process(delta: float) -> void:
	if not active or locked:
		return
	
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

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("Close"):
		get_tree().quit()
	
	if active:
		return
	
	if not on_game_over:
		title_input()
	else:
		game_over_input()


func title_input() -> void:
	if Input.is_action_just_pressed("accept"):
		$Sound/accept.play()
		active = true
		animation_player.play("out Title")
		
func game_over_input() -> void:
	if Input.is_action_just_pressed("accept"):
		$Sound/accept.play()
		active = true
		animation_player.play("out Over")

func check_increment() -> void:
	if increment == 2:
		enemy_generation.wait_time = 3.0
	elif increment == 3:
		enemy_generation.wait_time = 1.5
		enemy_wait_shoot -= enemy_wait_shoot_decreaser
	elif increment == 5:
		enemy_generation.wait_time = 0.75
		enemy_wait_shoot -= enemy_wait_shoot_decreaser

func generate_enemy():
	if not carrils:
		return
	$"Sound/enemy-in".play()
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
	update_score_count()

func update_score_count() -> void:
	return

func add_enemy_projectile(carril) -> void:
	$Sound/shoot.play()
	var new_projectile = ENEMY_PROJECTILE.instantiate()
	projectiles_holder.add_child(new_projectile)
	new_projectile.position = Vector2((Global.screen_width / 2) - 48, carril_map[carril].y)
	new_projectile.set_up(-1, "Enemy")

func _on_player_add_projectile() -> void:
	$Sound/shoot.play()
	var new_projectile = PLAYER_PROJECTILE.instantiate()
	projectiles_holder.add_child(new_projectile)
	new_projectile.position = player.position
	new_projectile.set_up(1, "Ally")


func _on_enemy_generation_timeout() -> void:
	generate_enemy()

func start_player() -> void:
	player.is_started = true

func unlock() -> void:
	locked = false

func free_enemies() -> void:
	for enemy: Enemy in enemies_holder.get_children():
		enemy.animation_player.play("disappear")

func reset() -> void:
	player.visible = true
	player.position = Vector2(-288, 0)
	player.set_collision_layer_value(1, true)
	enemy_generation.wait_time = 4.0
	increment = 1
	Global.speed = 175
	start_player()

func _on_player_start_finish() -> void:
	if on_game_over:
		enemy_generation.start()
		on_game_over = false
		return
	animation_player.play("in Tutorial")


func _on_tutorial_timer_timeout() -> void:
	animation_player.play("out Tutorial")
	enemy_generation.start()
	


func _on_player_sig_die() -> void:
	if on_game_over:
		return
		
	free_enemies()
	locked = true
	active = false
	enemy_generation.stop()
	on_game_over = true
	animation_player.play("in Over")
