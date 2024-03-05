extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$TorchSprite.play("burn")
	$TorchSprite2.play("burn")
	$TorchSprite3.play("burn")
	$TorchSprite4.play("burn")
	
	Global.question_array_easy = Global.fetch_random_questions("Easy", 30)
	Global.question_array_medium = Global.fetch_random_questions("Medium", 30)
	Global.question_array_hard = Global.fetch_random_questions("Hard", 30)
	if FileAccess.file_exists("user://savegame.tres") == false:
		$VBoxContainer/Continue.disabled = true


func _on_new_run_pressed():
	$Intro_Outro.visible = true
	$TorchSprite.visible = false
	$TorchSprite2.visible = false
	$TorchSprite3.visible = false
	$TorchSprite4.visible = false

func _on_exit_pressed():
	get_tree().quit()


func _on_continue_pressed():
	var saved_game:SavedGame = load("user://savegame.tres") as SavedGame
	
	Global.PlayerHealth = saved_game.player_health
	Global.PlayerMaxHealth = saved_game.player_max_health
	Global.PlayerPosition = saved_game.player_position
	Global.PlayerPath = saved_game.player_path
	Global.PlayerDamage = saved_game.player_damage
	Global.PlayerMaxOverdrive = saved_game.player_max_overdrive
	Global.PlayerOverdrive = saved_game.player_overdrive
	Global.Ankh = saved_game.Ankh
	Global.Blade = saved_game.Blade
	Global.Orb = saved_game.Orb
	Global.WeakenSpell = saved_game.WeakenSpell
	Global.AskedQuestions = saved_game.AskedQuestions
	Global.FoughtEnemies = saved_game.FoughtEnemies
	
	get_tree().change_scene_to_file("res://main.tscn")


func _on_new_run_mouse_entered():
	$Player.position.x = 114
	$Player.position.y = -28


func _on_continue_mouse_entered():
	$Player.position.x = 114
	$Player.position.y = 19


func _on_exit_mouse_entered():
	$Player.position.x = 114
	$Player.position.y = 65
