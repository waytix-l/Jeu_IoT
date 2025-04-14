extends Node3D

var class_scene = load("res://ChooseClass.tscn")

@onready var playButton = $Control/ColorRect/PlayButton
@onready var optionButton = $Control/ColorRect/OptionsButton
@onready var bonusButton = $Control/ColorRect/BonusButton
@onready var instructionButton = $Control/ColorRect/InstructionButton

@onready var optionExitButton = $Control/OptionMenu/ExitButton

@onready var bonusExitButton = $Control/BonusMenu/ExitButton

@onready var instructionExitButton = $Control/InstructionsMenu/ExitButton

var currentButtonFocus: int = 0

@onready var mainMenu = $Control/ColorRect
@onready var optionMenu = $Control/OptionMenu
@onready var bonusMenu = $Control/BonusMenu
@onready var instructionMenu = $Control/InstructionsMenu

@onready var LastGame1 = $Control/ColorRect/Label
@onready var LastGame2 = $Control/ColorRect/Label2
@onready var LastGame3 = $Control/ColorRect/Label3
@onready var LastGame4 = $Control/ColorRect/Label4
@onready var LastGame5 = $Control/ColorRect/Label5

var current_screen = "main"

var game_data
var bonus_data


# Bonus

@onready var Player1HealthBonusLabel = $Control/BonusMenu/Player1Bonus/HealthBonus/Label
@onready var Player1HealthBonusMinusButton = $"Control/BonusMenu/Player1Bonus/HealthBonus/Button-"
@onready var Player1HealthBonusPlusButton = $"Control/BonusMenu/Player1Bonus/HealthBonus/Button+"

@onready var Player1DamageBonusLabel = $Control/BonusMenu/Player1Bonus/DamageBonus/Label
@onready var Player1DamageBonusMinusButton = $"Control/BonusMenu/Player1Bonus/DamageBonus/Button-"
@onready var Player1DamageBonusPlusButton = $"Control/BonusMenu/Player1Bonus/DamageBonus/Button+"

@onready var Player1SpeedBonusLabel = $Control/BonusMenu/Player1Bonus/SpeedBonus/Label
@onready var Player1SpeedBonusMinusButton = $"Control/BonusMenu/Player1Bonus/SpeedBonus/Button-"
@onready var Player1SpeedBonusPlusButton = $"Control/BonusMenu/Player1Bonus/SpeedBonus/Button+"

@onready var Player1ASBonusLabel = $Control/BonusMenu/Player1Bonus/AttackSpeedBonus/Label
@onready var Player1ASBonusMinusButton = $"Control/BonusMenu/Player1Bonus/AttackSpeedBonus/Button-"
@onready var Player1ASBonusPlusButton = $"Control/BonusMenu/Player1Bonus/AttackSpeedBonus/Button+"

var Player1BonusPoints: int
@onready var Player1BonusPointsLabel = $Control/BonusMenu/Player1Bonus/BonusPoints


func _ready():
	var game_data_load = Data.load_data_from_json("res://data/games.json")
	var bonus_data_load = Data.load_data_from_json("res://data/bonus.json")
	
	Player1BonusPoints = bonus_data_load.player1.bonusPoints
	
	var last_games = []
	
	Player1BonusPointsLabel.text = str(bonus_data_load.player1.bonusPoints)
	Player1HealthBonusLabel.text = "Health : " + str(bonus_data_load.player1.healthBonus)
	Player1DamageBonusLabel.text = "Damage : " + str(bonus_data_load.player1.damageBonus)
	Player1SpeedBonusLabel.text = "Speed : " + str(bonus_data_load.player1.speedBonus)
	Player1ASBonusLabel.text = "AS : " + str(bonus_data_load.player1.attackSpeedBonus)
	
	if len(game_data_load.games) < 5:
		match len(game_data_load.games):
			1:
				last_games.append(game_data_load.games[0])
				LastGame1.text = str(last_games[0].score) + " points"
			2:
				last_games.append(game_data_load.games[0])
				LastGame1.text = str(last_games[0].score) + " points"
				last_games.append(game_data_load.games[1])
				LastGame2.text = str(last_games[1].score) + " points"
			3:
				last_games.append(game_data_load.games[0])
				LastGame1.text = str(last_games[0].score) + " points"
				last_games.append(game_data_load.games[1])
				LastGame2.text = str(last_games[1].score) + " points"
				last_games.append(game_data_load.games[2])
				LastGame3.text = str(last_games[2].score) + " points"
			4:
				last_games.append(game_data_load.games[0])
				LastGame1.text = str(last_games[0].score) + " points"
				last_games.append(game_data_load.games[1])
				LastGame2.text = str(last_games[1].score) + " points"
				last_games.append(game_data_load.games[2])
				LastGame3.text = str(last_games[2].score) + " points"
				last_games.append(game_data_load.games[3])
				LastGame4.text = str(last_games[3].score) + " points"
				
	else :	
		for i in range(len(game_data_load.games) - 5, len(game_data_load.games)):
			last_games.append(game_data_load.games[i])
		LastGame1.text = str(last_games[-1].score) + " points"
		LastGame1.text = str(last_games[-2].score) + " points"
		LastGame1.text = str(last_games[-3].score) + " points"
		LastGame1.text = str(last_games[-4].score) + " points"
		LastGame1.text = str(last_games[-5].score) + " points"
			
		
		
		
	print(last_games)
	print(len(game_data_load.games) - len(game_data_load.games) * 0.1)
	print(int(len(game_data_load.games) - len(game_data_load.games) * 0.1))
	print(len(game_data_load.games))

	mainMenu.visible = true
	optionMenu.visible = false
	currentButtonFocus = 0
	button_focus_check()
	
	#game_data = {
		#"player1" : "",
		#"player2" : "",
		#"score" : 0
	#}
	#
	#bonus_data = {
		#
		#"player1": {
			#"healthBonus": 0,
			#"damageBonus": 0,
			#"speedBonus": 0,
			#"attackSpeedBonus": 0
		#},
		#
		#"player2": {
			#"healthBonus": 0,
			#"damageBonus": 0,
			#"speedBonus": 0,
			#"attackSpeedBonus": 0
		#}
	#}

func _process(delta):
	
	
	
	if playButton.button_pressed:
		get_tree().change_scene_to_packed(class_scene)
		
	if bonusButton.button_pressed:
		current_screen = "bonus"
		
	if instructionButton.button_pressed:
		current_screen = "instruction"
	
	if optionButton.button_pressed:
		current_screen = "options"
	
	if current_screen == "main":
		mainMenu.visible = true
		bonusMenu.visible = false
		optionMenu.visible = false
		instructionMenu.visible = false
	
	if current_screen == "bonus":
		mainMenu.visible = false
		bonusMenu.visible = true
		optionMenu.visible = false
		instructionMenu.visible = false
		
		
		
		var BonusData = Data.load_data_from_json("res://data/bonus.json")
		
		if Player1HealthBonusPlusButton.button_pressed and Player1BonusPoints > 0:
			Data.modifier_valeur_json("res://data/bonus.json", "player1/healthBonus", BonusData.player1.healthBonus + 1)
			Data.modifier_valeur_json("res://data/bonus.json", "player1/bonusPoints", BonusData.player1.bonusPoints - 1)
			
			Player1BonusPointsLabel.text = str(BonusData.player1.bonusPoints - 1)
			Player1HealthBonusLabel.text = "Health : " + str(BonusData.player1.healthBonus + 1)
			Player1BonusPoints -= 1
		
		if Player1HealthBonusMinusButton.button_pressed and BonusData.player1.healthBonus > 0:
			Data.modifier_valeur_json("res://data/bonus.json", "player1/healthBonus", BonusData.player1.healthBonus - 1)
			Data.modifier_valeur_json("res://data/bonus.json", "player1/bonusPoints", BonusData.player1.bonusPoints + 1)
			
			Player1BonusPointsLabel.text = str(BonusData.player1.bonusPoints + 1)
			Player1HealthBonusLabel.text = "Health : " + str(BonusData.player1.healthBonus - 1)
			Player1BonusPoints += 1
			
			
		
		if Player1DamageBonusPlusButton.button_pressed and Player1BonusPoints > 0:
			Data.modifier_valeur_json("res://data/bonus.json", "player1/damageBonus", BonusData.player1.damageBonus + 1)
			Data.modifier_valeur_json("res://data/bonus.json", "player1/bonusPoints", BonusData.player1.bonusPoints - 1)
			
			Player1BonusPointsLabel.text = str(BonusData.player1.bonusPoints - 1)
			Player1DamageBonusLabel.text = "Damage : " + str(BonusData.player1.damageBonus + 1)
			Player1BonusPoints -= 1
		
		if Player1DamageBonusMinusButton.button_pressed and BonusData.player1.damageBonus > 0:
			Data.modifier_valeur_json("res://data/bonus.json", "player1/damageBonus", BonusData.player1.damageBonus - 1)
			Data.modifier_valeur_json("res://data/bonus.json", "player1/bonusPoints", BonusData.player1.bonusPoints + 1)
			
			Player1BonusPointsLabel.text = str(BonusData.player1.bonusPoints + 1)
			Player1DamageBonusLabel.text = "Damage : " + str(BonusData.player1.damageBonus - 1)
			Player1BonusPoints += 1
		
		
		
		if Player1SpeedBonusPlusButton.button_pressed and Player1BonusPoints > 0:
			Data.modifier_valeur_json("res://data/bonus.json", "player1/speedBonus", BonusData.player1.speedBonus + 1)
			Data.modifier_valeur_json("res://data/bonus.json", "player1/bonusPoints", BonusData.player1.bonusPoints - 1)
			
			Player1BonusPointsLabel.text = str(BonusData.player1.bonusPoints - 1)
			Player1SpeedBonusLabel.text = "Speed : " + str(BonusData.player1.speedBonus + 1)
			Player1BonusPoints -= 1
		
		if Player1SpeedBonusMinusButton.button_pressed and BonusData.player1.speedBonus > 0:
			Data.modifier_valeur_json("res://data/bonus.json", "player1/speedBonus", BonusData.player1.speedBonus - 1)
			Data.modifier_valeur_json("res://data/bonus.json", "player1/bonusPoints", BonusData.player1.bonusPoints + 1)
			
			Player1BonusPointsLabel.text = str(BonusData.player1.bonusPoints + 1)
			Player1SpeedBonusLabel.text = "Speed : " + str(BonusData.player1.speedBonus - 1)
			Player1BonusPoints += 1
		
		
		
		if Player1ASBonusPlusButton.button_pressed and Player1BonusPoints > 0:
			Data.modifier_valeur_json("res://data/bonus.json", "player1/attackSpeedBonus", BonusData.player1.attackSpeedBonus + 1)
			Data.modifier_valeur_json("res://data/bonus.json", "player1/bonusPoints", BonusData.player1.bonusPoints - 1)
			
			Player1BonusPointsLabel.text = str(BonusData.player1.bonusPoints - 1)
			Player1ASBonusLabel.text = "AS : " + str(BonusData.player1.attackSpeedBonus + 1)
			Player1BonusPoints -= 1
		
		if Player1ASBonusMinusButton.button_pressed and BonusData.player1.attackSpeedBonus > 0:
			Data.modifier_valeur_json("res://data/bonus.json", "player1/attackSpeedBonus", BonusData.player1.attackSpeedBonus - 1)
			Data.modifier_valeur_json("res://data/bonus.json", "player1/bonusPoints", BonusData.player1.bonusPoints + 1)
			
			Player1BonusPointsLabel.text = str(BonusData.player1.bonusPoints + 1)
			Player1ASBonusLabel.text = "AS : " + str(BonusData.player1.attackSpeedBonus - 1)
			Player1BonusPoints += 1
		
		
		
		if bonusExitButton.button_pressed:
			current_screen = "main"
			currentButtonFocus = 0
		
	if current_screen == "options":
		mainMenu.visible = false
		bonusMenu.visible = false
		optionMenu.visible = true
		instructionMenu.visible = false
		if optionExitButton.button_pressed:
			current_screen = "main"
			currentButtonFocus = 0
	
	if current_screen == "instruction":
		mainMenu.visible = false
		bonusMenu.visible = false
		optionMenu.visible = false
		instructionMenu.visible = true
		if instructionExitButton.button_pressed:
			current_screen = "main"
			currentButtonFocus = 0
		
	button_focus_set()
	
func button_focus_set():
	
	if current_screen == "main" :
		if Input.is_action_just_pressed("ui_down") :
			if currentButtonFocus < 3 :
				currentButtonFocus += 1
			elif currentButtonFocus == 3 :
				currentButtonFocus = 0
		if Input.is_action_just_pressed("ui_up") :
			if currentButtonFocus > 0 :
				currentButtonFocus -= 1
			elif currentButtonFocus == 0 :
				currentButtonFocus = 3
				
	if current_screen == "options" :
		currentButtonFocus = 3
	
	if current_screen == "bonus" :
		currentButtonFocus = 4
		
	if current_screen == "instruction" :
		currentButtonFocus = 5
	
	button_focus_check()
	
func button_focus_check():
	if current_screen == "main" :
		if currentButtonFocus == 0 :
			playButton.grab_focus()
		if currentButtonFocus == 1 :
			bonusButton.grab_focus()
		if currentButtonFocus == 2 :
			instructionButton.grab_focus()
		if currentButtonFocus == 3 :
			optionButton.grab_focus()
	if current_screen == "options":
		if currentButtonFocus == 3 :
			optionExitButton.grab_focus()
	if current_screen == "bonus":
		if currentButtonFocus == 4 :
			bonusExitButton.grab_focus()
	if current_screen == "instruction":
		if currentButtonFocus == 5 :
			instructionExitButton.grab_focus()
