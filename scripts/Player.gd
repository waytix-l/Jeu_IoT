class_name Player
extends CharacterBody3D

@onready var label: Label = $Spatial/SubViewport/HealthLabel
var HPset = false

# Références
var character
var mesh_character
var animation_tree: AnimationTree
var playback

@export var playerID: int

# États
var is_attacking: bool = false
var is_running: bool = false
var is_not_running: bool = true
var is_dead: bool = false

# Animations
const IDLE = "Idle"
const RUN = "Run"
const ATTACK = "Attack1"
const DEATH = "Death"

var bonus_data_load = Data.load_data_from_json("res://data/bonus.json")

@export_group("Stats")
@export var MAX_HP: int = 2000
var HP_BONUS: int = 0

@export var DAMAGE: int = 100
var DAMAGE_BONUS: int = 0

@export var SPEED: float = 5.0
var SPEED_BONUS: int = 0

@export var ATTACK_SPEED: float = 5.0
var ATTACK_SPEED_BONUS: int = 0

var CURRENT_HP: int = 1000
var SCORE: int = 0
@onready var SCORE_LABEL: Label = $Score
var SCORE_TIMER: int = 0

@onready var HP_LABEL: Label = $HP

@export_group("Movement")
@export var LEFT = "left"
@export var RIGHT = "right"
@export var FORWARD = "forward"
@export var BACKWARD = "backward"

@export var ATTACK_BIND = "attack"

var attack_duration = 0.3   # durée de l'attaque en secondes
var attack_cooldown = ATTACK_SPEED * 0.1 - ATTACK_SPEED_BONUS * 0.1 # temps entre les attaques
var can_attack = true

var is_knocked_back = false
var knockback_timer = 0.0
var knockback_duration = 0.3  # 0.3 secondes de knockback

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var direction: Vector3
var player_angle: float
var pause: bool
var all_enemies

func _ready():
	pause = get_tree().get_current_scene().Pause
	
	if playerID == 0:
		HP_BONUS = bonus_data_load.player1.healthBonus
		DAMAGE_BONUS = bonus_data_load.player1.damageBonus
		SPEED_BONUS = bonus_data_load.player1.speedBonus
		ATTACK_SPEED_BONUS = bonus_data_load.player1.attackSpeedBonus
	if playerID == 1:
		HP_BONUS = bonus_data_load.player2.healthBonus
		DAMAGE_BONUS = bonus_data_load.player2.damageBonus
		SPEED_BONUS = bonus_data_load.player2.speedBonus
		ATTACK_SPEED_BONUS = bonus_data_load.player2.attackSpeedBonus
	
	print(HP_BONUS, DAMAGE_BONUS, SPEED_BONUS, ATTACK_SPEED_BONUS)
	
	all_enemies = get_tree().get_nodes_in_group("enemies")
	CURRENT_HP = MAX_HP + HP_BONUS * 200
	
	mesh_character = get_tree().get_nodes_in_group("MeshCharacter")[playerID]
	character = mesh_character.get_parent()
	
	if mesh_character.has_node("AnimationTree"):
		animation_tree = mesh_character.get_node("AnimationTree")
		playback = animation_tree.get("parameters/playback")

	reset_states()

func reset_states():
	is_attacking = false
	is_running = false
	is_dead = false
	is_not_running = true

func set_current_hp() -> void:
	if label:
		label.text = str(CURRENT_HP)
	if HP_LABEL:
		HP_LABEL.text = str(CURRENT_HP)
		
func _get_HP():
	return CURRENT_HP
	
func add_score(value: int):
	SCORE += value

func set_current_score():
	if SCORE_LABEL:
		SCORE_LABEL.text = str(SCORE)

func _physics_process(delta):
	pause = get_tree().get_current_scene().Pause
	#print("Animation en cours: " + playback.get_current_node())
	if !pause:
		if not HPset and label:
			set_current_hp()
			HPset = true
		if not is_on_floor():
			velocity.y -= gravity * delta
		
		process_attack()
		process_movement()
		move_and_slide()
		check_if_dead()
		

func _process(delta):
	all_enemies = get_tree().get_nodes_in_group("enemies")
	set_current_score()
	SCORE_TIMER += 1
	if SCORE_TIMER % 120 == 0 and !is_dead:
		add_score(1)
	

func process_attack():
	if (playback.get_current_node() in [IDLE, RUN]) and Input.is_action_just_pressed(ATTACK_BIND):
		is_attacking = true
		playback.travel(ATTACK)
	else:
		is_attacking = ATTACK in playback.get_current_node()


func process_movement():
	var input_dir = Input.get_vector(LEFT, RIGHT, FORWARD, BACKWARD)
	direction = Vector3(input_dir.x, 0, input_dir.y).normalized()

	# Si on bouge et qu'on n'attaque pas
	if direction != Vector3.ZERO and not is_attacking:
		if not is_running:
			is_running = true
			playback.travel(RUN)
	else:
		if is_running:
			is_running = false
			playback.travel(IDLE)

	update_rotation(input_dir)

	if direction:
		velocity.x = direction.x * (SPEED + SPEED_BONUS)
		velocity.z = direction.z * (SPEED + SPEED_BONUS)
	else:
		velocity.x = move_toward(velocity.x, 0, (SPEED + SPEED_BONUS))
		velocity.z = move_toward(velocity.z, 0, (SPEED + SPEED_BONUS))

	# Mise à jour des conditions de l'AnimationTree
	animation_tree["parameters/conditions/isRunning"] = is_running
	animation_tree["parameters/conditions/isAttacking"] = is_attacking
	animation_tree["parameters/conditions/isDead"] = is_dead

func update_rotation(input_dir: Vector2):
	if input_dir.y > 0 and input_dir.x < 0:
		character.rotation.y = deg_to_rad(135)
	elif input_dir.y > 0 and input_dir.x > 0:
		character.rotation.y = deg_to_rad(-135)
	elif input_dir.y < 0 and input_dir.x < 0:
		character.rotation.y = deg_to_rad(45)
	elif input_dir.y < 0 and input_dir.x > 0:
		character.rotation.y = deg_to_rad(-45)
	elif input_dir.y == 0 and input_dir.x < 0:
		character.rotation.y = deg_to_rad(90)
	elif input_dir.y == 0 and input_dir.x > 0:
		character.rotation.y = deg_to_rad(-90)
	elif input_dir.y < 0 and input_dir.x == 0:
		character.rotation.y = deg_to_rad(0)
	elif input_dir.y > 0 and input_dir.x == 0:
		character.rotation.y = deg_to_rad(180)


func take_damage(damage, enemy_pos, enemy):
	if CURRENT_HP - damage < 0:
		CURRENT_HP = 0
	else :
		CURRENT_HP -= damage
	
	set_current_hp()
	apply_knockback(enemy_pos)
	
func check_if_dead():
	if CURRENT_HP == 0 and !is_dead:
		set_physics_process(false)
		$CollisionShape3D.disabled = true
		is_dead = true
		playback.travel(DEATH)
	
func apply_knockback(attacker_position = null):
	if attacker_position == null:
		return
	
	var knockback_direction = (global_position - attacker_position).normalized()
	var knockback_strength = 20.0
	
	velocity = knockback_direction * knockback_strength
	velocity.y = 2.0
	
	# Activer l'état de knockback
	is_knocked_back = true
	knockback_timer = 0.0
