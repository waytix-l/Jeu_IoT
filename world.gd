class_name World
extends Node3D

@export
var Player1 : Node3D
@onready var DeathScreenP1 = $GridContainer/SubViewportContainer/SubViewport/DeathScreenPlayer1

@export
var Player2 : Node3D
@onready var DeathScreenP2 = $GridContainer/SubViewportContainer2/SubViewport/DeathScreenPlayer2

@export
var EnemyPrefab : PackedScene

@export
var EnemyRootNode : Node3D

@export
var EnemySpawnRate : float

@export
var EnemySpawning : bool

var EnemyTimer : float

var Pause : bool

var totalScore: int = 0
var scoreSet = false

@onready var PauseScreen = $PauseMenu/ColorRect

@onready var EndGameScreen = $PauseMenu/EndGame
@onready var EndScoreLabel = $PauseMenu/EndGame/Score

# Called when the node enters the scene tree for the first time.
func _ready():
	
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if Input.is_action_just_pressed("escape") and !Pause:
		Pause = true
		PauseScreen.visible = !PauseScreen.visible
	elif Input.is_action_just_pressed("escape") and Pause:
		Pause = false
		PauseScreen.visible = !PauseScreen.visible
	
	if !Pause :
		
		if EnemySpawning :
			if EnemyTimer < EnemySpawnRate :
				EnemyTimer += delta
			else :
				EnemyTimer = 0
				var enemy = EnemyPrefab.instantiate()
				enemy.set("player1", Player1)
				enemy.set("player2", Player2)
				EnemyRootNode.add_child(enemy)
				enemy.add_to_group("enemies")
				enemy.global_position = Vector3(10, 2, 10)
	
	check_player1_dead()
	check_player2_dead()
	check_both_player_dead()
		
func check_player1_dead():
	if Player1.playback.get_current_node() == "Death_pose":
		DeathScreenP1.visible = true
	#else :
		#DeathScreenP1.visible = false
	
func check_player2_dead():
	print(Player2)
	if Player2.playback.get_current_node() == "Death_pose":
		DeathScreenP2.visible = true
		print("deathposeP2")
		print(DeathScreenP2.visible)
	#else :
		#DeathScreenP1.visible = false
		
func check_both_player_dead():
	if Player1.is_dead and Player2.is_dead:
		if !scoreSet:
			totalScore = Player1.SCORE + Player2.SCORE
			var game_data_load = Data.load_data_from_json("res://data/games.json")
			var gameAmount = game_data_load.gamesAmount + 1
			Data.modifier_valeur_json("res://data/games.json", "gamesAmount", gameAmount)
			var data = {
				"gameId" = int(gameAmount),
				"score" = int(totalScore)
			}
			Data.ajouter_a_liste_json("res://data/games.json", "games", data)
			scoreSet = true
		
		EndGameScreen.visible = true
		EndScoreLabel.text = "Le score total est de " + str(totalScore) + " points !"
