extends Player

@onready var AA_timer : float

@export var AA_Delay : float = 1

@onready var attack_area = $Character/Assassin/AttackArea
@onready var attack_timer = $AttackTimer
@onready var cooldown_timer = $CooldownTimer

# Called when the node enters the scene tree for the first time.
func _ready():
	super()
	MAX_HP = 1000
	DAMAGE = 120
	SPEED = 9
	ATTACK_SPEED = 6
	CURRENT_HP = MAX_HP
	is_attacking = false
	
	# Désactiver l'aire d'attaque au démarrage
	attack_area.monitoring = false
	attack_area.visible = false
	
	# Connecter le signal pour détecter les ennemis
	attack_area.connect("body_entered", Callable(self, "_on_enemy_hit"))
	
	attack_area.body_entered.connect(_on_enemy_hit)
	attack_timer.timeout.connect(_on_attack_timer_timeout)
	cooldown_timer.timeout.connect(_on_cooldown_timer_timeout)
	
	# Configurer les timers
	attack_timer.wait_time = attack_duration
	attack_timer.one_shot = true
	cooldown_timer.wait_time = attack_cooldown
	cooldown_timer.one_shot = true
	
func attack(delta):
	process_attack()


func ability_1():
#    set_invincible(true)
#    yield(get_tree().create_timer(3.0), "timeout")
#    set_invincible(false)
	pass
	
func ability_2():
	#attract_enemies()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	super(delta)
	
func _process(delta):
	super(delta)
	if (playback.get_current_node() in [IDLE, RUN]) and Input.is_action_just_pressed(ATTACK_BIND):
		is_attacking = true
		playback.travel(ATTACK)
		start_attack()
	else:
		is_attacking = ATTACK in playback.get_current_node()
		
func start_attack():
	can_attack = false
	is_attacking = true
	
	# Activer la zone d'attaque
	attack_area.monitoring = true
	attack_area.visible = true  # Si vous voulez la rendre visible pour le débogage
	
	# Lancer le timer pour désactiver l'attaque
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

func _on_enemy_hit(body):
	# Vérifier si le corps est un ennemi
	if all_enemies.has(body):
		# Infliger des dégâts à l'ennemi
		if body.has_method("take_damage"):
			body.take_damage(DAMAGE + DAMAGE / 5 * DAMAGE_BONUS, global_position, self)  # Ajustez la valeur des dégâts selon vos besoins
			print(body._get_HP())
