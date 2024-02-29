extends Node

func _ready():
	save()
	
func save_and_exit():
	
	var saved_game:SavedGame = SavedGame.new()
	
	saved_game.player_health = Global.PlayerMaxHealth
	saved_game.player_max_health = Global.PlayerMaxHealth
	saved_game.player_position = Global.PlayerPosition
	saved_game.player_path = Global.PlayerPath
	saved_game.player_damage = Global.PlayerDamage
	saved_game.Ankh = Global.Ankh
	saved_game.Blade = Global.Blade
	saved_game.Orb = Global.Orb
	saved_game.WeakenSpell = Global.WeakenSpell
	saved_game.AskedQuestions = Global.AskedQuestions
	saved_game.FoughtEnemies = Global.FoughtEnemies
	
	ResourceSaver.save(saved_game, "user://savegame.tres")
	
	Global.reset()
	
	get_tree().change_scene_to_file("res://main_menu.tscn")
	

func save():
	var saved_game:SavedGame = SavedGame.new()
		
	saved_game.player_health = Global.PlayerMaxHealth
	saved_game.player_max_health = Global.PlayerMaxHealth
	saved_game.player_position = Global.PlayerPosition
	saved_game.player_path = Global.PlayerPath
	saved_game.player_damage = Global.PlayerDamage
	saved_game.Ankh = Global.Ankh
	saved_game.Blade = Global.Blade
	saved_game.Orb = Global.Orb
	saved_game.WeakenSpell = Global.WeakenSpell
	saved_game.AskedQuestions = Global.AskedQuestions
	saved_game.FoughtEnemies = Global.FoughtEnemies

	ResourceSaver.save(saved_game, "user://savegame.tres")

func _on_save_exit_pressed():
	save_and_exit()
