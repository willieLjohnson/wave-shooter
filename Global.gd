extends Node

var node_creation_parent = null
var player = null
var is_player_dead = false
var camera = null

var score = 0
var high_score = 0

var save_file_path = "user://savegame.save"

func instance_node(node, location, parent):
	var node_instance = node.instance()
	parent.add_child(node_instance)
	node_instance.global_position = location
	return node_instance  
	
func play_sound(sound):
	if node_creation_parent != null:
		var audioStreamPlayer = AudioStreamPlayer.new()
		node_creation_parent.add_child(audioStreamPlayer)
		audioStreamPlayer.stream = load(sound) 
		audioStreamPlayer.play()

func play_sound_on(parent, sound):
	var audioStreamPlayer = AudioStreamPlayer.new()
	parent.add_child(audioStreamPlayer)
	audioStreamPlayer.stream = load(sound) 
	audioStreamPlayer.play()
	
func save():
	var save_dict = {
		"high_score": high_score
	}
	return save_dict

func save_game():
	var save_file = File.new()
	save_file.open_encrypted_with_pass(save_file_path, File.WRITE, "enc")
	save_file.store_line(to_json(save()))
	save_file.close()
	
func load_game():
	var save_file = File.new()
	if not save_file.file_exists(save_file_path):
		print("NO SAVE FILE")
		return
	
	save_file.open_encrypted_with_pass(save_file_path, File.READ, "enc")
	var current_line = parse_json(save_file.get_line())
	
	high_score = current_line["high_score"]
	save_file.close()
