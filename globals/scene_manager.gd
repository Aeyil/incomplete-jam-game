extends Node

@export var main_menu_scene : PackedScene = preload("res://main_menu/main_menu.tscn")
@export var gameplay_scene : PackedScene = preload("res://core/gameplay_scene.tscn")

func _ready():
	SignalHub.start_new_game.connect(switch_to_gameplay)
	SignalHub.end_current_game.connect(swtich_to_main_menu)
	
	
func switch_to_gameplay():
	get_tree().change_scene_to_packed(gameplay_scene)
	
	
func swtich_to_main_menu():
	get_tree().change_scene_to_packed(main_menu_scene)
	