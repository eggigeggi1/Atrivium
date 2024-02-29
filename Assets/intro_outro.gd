extends Control




func _on_continue_pressed():
	if Global.PlayerPosition == 8:
		get_tree().change_scene_to_file("res://main_menu.tscn")
		Global.reset()
	else:
		get_tree().change_scene_to_file("res://main.tscn")
