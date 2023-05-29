extends Node2D

func _process(delta):
	if Input.is_anything_pressed() and !Input.is_action_pressed("escape"):
		get_tree().change_scene_to_file("res://Scene_demo.tscn")
