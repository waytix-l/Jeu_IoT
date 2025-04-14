class_name Enemy
extends CharacterBody3D

@export
var Spawned = false

@export
var move_speed : float

@onready var player1 : Node3D
@onready var player2 : Node3D

var distanceToPlayer1 : float
var distanceToPlayer2 : float

var target : Node3D

@onready var navigation_agent = $NavigationAgent3D as NavigationAgent3D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var MAX_HP: int = 200
var CURRENT_HP: int = 200

@onready var label: Label = $Spatial/SubViewport/Label
var HPset = false

var is_knocked_back = false
var knockback_timer = 0.0
var knockback_duration = 0.3  # 0.3 secondes de knockback

@onready var attack_area = $Area3D
@onready var attack_timer = $AttackTimer
@onready var cooldown_timer = $CooldownTimer

var attack_duration = 0.3  # durée de l'attaque en secondes
var attack_cooldown = 0.5  # temps entre les attaques
var can_attack = true
var is_attacking: bool = false

var DAMAGE: int = 50

var all_players: Array

var pause

func _ready():   
	
	var angle = randf() * TAU  # TAU = 2 * PI, random angle in radians
	var distance = randf_range(20.0, 30.0)  # Random distance from player
	var offset = Vector3(cos(angle), 0, sin(angle)) * distance  # Calculate offset

	var DistanceBetweenPlayers = sqrt((player2.global_position.x - player1.global_position.x)**2 + (player2.global_position.y - player1.global_position.y)**2 + (player2.global_position.z - player1.global_position.z)**2)
	var positionMiddle = (player1.global_position + player2.global_position) / 2

	var spawn_position = positionMiddle + offset

	global_position = spawn_position
	
	#all_players = get_tree().get_nodes_in_group("players")
	all_players.append(player1)
	all_players.append(player2)
	#all_players = get_parent().get_children()
	
	distanceToPlayer1 = global_position.distance_to(player1.global_position)
	
	distanceToPlayer2 = global_position.distance_to(player2.global_position)
	
	if distanceToPlayer1 > distanceToPlayer2 :
		target = player2
	else :
		target = player1
		
	if !attack_area.body_entered.is_connected(Callable(self, "_on_player_hit")):
		attack_area.body_entered.connect(Callable(self, "_on_player_hit"))

func set_current_hp(value: int) -> void:
	if label:
		label.text = str(value) + " / " + str(MAX_HP)

func _physics_process(delta):
	# Add the gravity.distance_to()
	if not HPset and label:
		set_current_hp(CURRENT_HP)
		HPset = true
		
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	if !pause:
	# Gestion du knockback
		if is_knocked_back:
			knockback_timer += delta
			if knockback_timer >= knockback_duration:
				is_knocked_back = false
				
			var knockback_decay = 0.9
			velocity.x *= knockback_decay
			velocity.z *= knockback_decay
		else:
			# Navigation normale SEULEMENT si pas en knockback
			navigation_agent.set_target_position(target.global_position)
			velocity = global_position.direction_to(navigation_agent.get_next_path_position()) * move_speed

		move_and_slide()
	
func _process(delta):
	pause = get_tree().get_current_scene().Pause
	start_attack()

func take_damage(damage, player_pos, player):
	
	if CURRENT_HP - damage < 0:
		CURRENT_HP = 0
	else :
		CURRENT_HP -= damage
	
	set_current_hp(CURRENT_HP)
	apply_knockback(player_pos)
	check_if_dead(player)
	
func check_if_dead(player):
	if CURRENT_HP == 0:
		queue_free()
		player.add_score(10)
	
func apply_knockback(attacker_position = null):
	if attacker_position == null:
		return
	
	var knockback_direction = (global_position - attacker_position).normalized()
	var knockback_strength = 20.0
	
	velocity = knockback_direction * knockback_strength
	velocity.y = 2.0
	
	is_knocked_back = true
	knockback_timer = 0.0
	
func _get_HP():
	return CURRENT_HP


func start_attack():
	can_attack = false
	is_attacking = true
	
	attack_area.monitoring = true
	attack_area.visible = true
	
	attack_timer.start()
	
func _on_attack_timer_timeout():
	# Désactiver la zone d'attaque
	attack_area.monitoring = false
	attack_area.visible = false
	is_attacking = false
	
	# Lancer le cooldown
	cooldown_timer.start()

func _on_cooldown_timer_timeout():
	can_attack = true

func _on_player_hit(body):
	# Vérifier si le corps est un ennemi
	if all_players.has(body):
		# Infliger des dégâts à l'ennemi
		if body.has_method("take_damage"):
			body.take_damage(DAMAGE, global_position, self)  # Ajustez la valeur des dégâts selon vos besoins
