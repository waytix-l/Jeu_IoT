extends "res://scripts/Player.gd"

# Called when the node enters the scene tree for the first time.
func _ready():
	super()
	MAX_HP = 1200
	DAMAGE = 130
	SPEED = 7
	ATTACK_SPEED = 7
	CURRENT_HP = 1200
	
	print("Archer ready")
	print(DAMAGE)
	
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
