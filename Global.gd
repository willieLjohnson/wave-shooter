extends Node

const POPUP_LABEL_SCENE = preload("res://objects/PopupLabel.tscn")

var node_creation_parent = null
var player = null
var is_player_dead = false
var camera = null

var score = 0
var high_score = 0

var save_file_path = "user://savegame.save"

onready var camera_rect: Rect2 setget ,get_camera_rect

	
func instance_node(node, location, parent):
	var node_instance = node.instance()
	if location != null: node_instance.global_position = location
	if parent != null: parent.add_child(node_instance)
	return node_instance  
	
func instance_popup_label(position, text, modulate = Color.white, z_index = 5, parent = node_creation_parent):
	var label = instance_node(POPUP_LABEL_SCENE, null, parent)
	label.text = text
	label.modulate = modulate
	label.z_index = z_index
	label.position = position
	return label
			
func get_camera_rect():
	if node_creation_parent != null:
		var camera = node_creation_parent.get_node("Camera2D")
		return camera.get_viewport().get_visible_rect()

func play_sound(sound, volume = 0, pitch = 1):
	if node_creation_parent != null:
		var audioStreamPlayer = AudioStreamPlayer.new()
		node_creation_parent.add_child(audioStreamPlayer)
		audioStreamPlayer.stream = load(sound)
		audioStreamPlayer.volume_db = volume
		audioStreamPlayer.pitch_scale = pitch
		audioStreamPlayer.play()

func play_sound_on(parent, sound, volume = 0):
	var audioStreamPlayer = AudioStreamPlayer.new()
	parent.add_child(audioStreamPlayer)
	audioStreamPlayer.stream = load(sound) 
	audioStreamPlayer.volume_db = volume
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
