extends Node


func save_data_to_json(data: Dictionary, file_path: String) -> bool:
	# Convert the dictionary to a JSON string
	var json_string = JSON.stringify(data)
	
	# Create a file object
	var file = FileAccess.open(file_path, FileAccess.WRITE)
	
	# Check if the file was opened successfully
	if file:
		# Write the JSON string to the file
		file.store_string(json_string)
		return true
	else:
		print("Failed to open file for writing: " + file_path)
		return false
		
		
		
		
func modifier_valeur_json(file_path: String, key_path: String, new_value) -> bool:
	# Charger les données existantes
	var data = load_data_from_json(file_path)
	
	if data == null:
		print("Erreur: Impossible de charger le fichier JSON")
		return false
	
	# Naviguer jusqu'à l'élément que nous voulons modifier
	var current_dict = data
	var keys = key_path.split("/")
	
	# Parcourir les clés pour arriver au bon niveau dans le dictionnaire
	for i in range(keys.size() - 1):
		var key = keys[i]
		# Vérifier si la clé existe
		if not key in current_dict:
			print("Erreur: Clé '" + key + "' introuvable dans le chemin: " + key_path)
			return false
		current_dict = current_dict[key]
	
	# Obtenir la clé finale
	var final_key = keys[keys.size() - 1]
	
	# Vérifier si la clé finale existe
	if not final_key in current_dict:
		print("Erreur: Clé finale '" + final_key + "' introuvable")
		return false
	
	# Modifier la valeur
	current_dict[final_key] = new_value
	
	# Sauvegarder les données mises à jour
	return save_data_to_json(data, file_path)
		
		

func ajouter_a_liste_json(file_path: String, key_path: String, new_items: Dictionary) -> bool:
	# Charger les données existantes
	var data = load_data_from_json(file_path)
	
	if data == null:
		# Si le fichier n'existe pas, créer un nouveau dictionnaire
		data = {}
	
	# Naviguer jusqu'à la liste que nous voulons modifier
	var current_dict = data
	var keys = key_path.split("/")
	
	# Parcourir les clés pour arriver au bon niveau dans le dictionnaire
	for i in range(keys.size() - 1):
		var key = keys[i]
		if not key in current_dict:
			current_dict[key] = {}
		current_dict = current_dict[key]
	
	# Obtenir la clé finale
	var final_key = keys[keys.size() - 1]
	
	# Si la liste n'existe pas encore, la créer
	if not final_key in current_dict:
		current_dict[final_key] = []
	
	# S'assurer que l'élément est bien une liste
	if not current_dict[final_key] is Array:
		print("Erreur: " + final_key + " n'est pas une liste dans le fichier JSON")
		return false
	
	# Ajouter les nouveaux éléments à la liste
	#for item in new_items:
		#current_dict[final_key].append(item)
	current_dict[final_key].append(new_items)
	
	# Sauvegarder les données mises à jour
	return save_data_to_json(data, file_path)


func load_data_from_json(file_path: String) -> Variant:
	# Check if the file exists
	if not FileAccess.file_exists(file_path):
		print("File does not exist: " + file_path)
		return null
	
	# Open the file
	var file = FileAccess.open(file_path, FileAccess.READ)
	
	# Check if the file was opened successfully
	if not file:
		print("Failed to open file for reading: " + file_path)
		return null
	
	# Read the content of the file
	var json_string = file.get_as_text()
	
	# Parse the JSON string
	var json = JSON.new()
	var parse_result = json.parse(json_string)
	
	# Check if parsing was successful
	if parse_result != OK:
		print("JSON Parse Error: " + json.get_error_message() + " at line " + str(json.get_error_line()))
		return null
	
	# Return the parsed data
	return json.get_data()
