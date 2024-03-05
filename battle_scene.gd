extends Node2D

var enemy_spawn_point : Node2D
var current_enemy
var current_enemy_health : int = 60
var current_enemy_max_health : int = 60
var current_enemy_damage : int = 8
var current_enemy_name : String
var enemy_animation_player

var right_answer
signal shake
signal answer_selected(answer: String)
signal correct
signal incorrect

var enemy_scenes : Array = [
	preload("res://skeleton.tscn"),
	preload("res://goblin.tscn"),
	preload("res://mushroom.tscn"),
	preload("res://flying_eye.tscn")
]


# Called when the node enters the scene tree for the first time.
func _ready():
	$Streak/Panel/Label.text = "Streak = %d" % Global.Streak
	if Global.PlayerPosition == 8:
		$BossMusic.play()
	if Global.WeakenSpell == true:
		current_enemy_health = current_enemy_health / 2
		Global.WeakenSpell = false
	if Global.PlayerOverdrive == Global.PlayerMaxOverdrive:
		$BattleMenu/VBoxContainer/Overdrive.visible = true
	$Player/HealthBar.max_value = Global.PlayerMaxHealth
	Global.set_health($Player/HealthBar, Global.PlayerHealth, Global.PlayerMaxHealth)
	Global.set_overdrive($Player/OverdriveBar, Global.PlayerOverdrive, Global.PlayerMaxOverdrive)
	enemy_spawn_point = $EnemySpawn
	spawn_random_enemy()
	$EnemySpawn/EnemyHealthBar.max_value = current_enemy_max_health
	Global.set_health($EnemySpawn/EnemyHealthBar, current_enemy_health, current_enemy_max_health)
	var enemy_animation_player = current_enemy.get_node("Sprite")
	enemy_animation_player.play("idle")

	
func _process(delta):
	if Global.PlayerHealth <= 0:
		GameOver()
			
	if current_enemy_health <= 0:
		Victory()
	
	if Global.Streak >= 2:
		$Streak.visible = true
	else:
		$Streak.visible = false

func spawn_random_enemy():	
	var random_index = randi() % enemy_scenes.size()
	
	if Global.FoughtEnemies.size() == 4:
		pass
	else:
		while(enemy_scenes[random_index] in Global.FoughtEnemies):
				random_index = randi() % enemy_scenes.size()
	var enemy_instance
	if Global.PlayerPosition == 8:
		enemy_instance = preload("res://demon.tscn").instantiate()
		$Message/Panel/Label.add_theme_color_override("font_color", Color(1, 0.5, 0))
		display_text("Your end is near...")
		current_enemy_health = 200
		current_enemy_max_health = 200
		current_enemy_damage = 15
		$EnemySpawn/EnemyHealthBar.position.y = 100
		$EnemySpawn/EnemyHealthBar.position.x = 420
	else:
		if enemy_scenes[random_index] == preload("res://skeleton.tscn"):
			current_enemy_health = 70
			current_enemy_max_health = 70
			current_enemy_damage = 8
			current_enemy_name = "skeleton"
			Global.FoughtEnemies.append(preload("res://skeleton.tscn"))
			
		elif enemy_scenes[random_index] == preload("res://goblin.tscn"):
			current_enemy_health = 40
			current_enemy_max_health = 40
			current_enemy_damage = 12
			Global.FoughtEnemies.append(preload("res://goblin.tscn"))
			current_enemy_name = "goblin"
		elif enemy_scenes[random_index] == preload("res://flying_eye.tscn"):
			current_enemy_health = 50
			current_enemy_max_health = 50
			current_enemy_damage = 10
			current_enemy_name = "flying_eye"
			Global.FoughtEnemies.append(preload("res://flying_eye.tscn"))
		elif enemy_scenes[random_index] == preload("res://mushroom.tscn"):
			current_enemy_health = 80
			current_enemy_max_health = 80
			current_enemy_damage = 6
			current_enemy_name = "mushroom"
			Global.FoughtEnemies.append(preload("res://mushroom.tscn"))

		enemy_instance = enemy_scenes[random_index].instantiate()
	enemy_spawn_point.add_child(enemy_instance)
	current_enemy = enemy_instance
	


func _on_trivia_strike_pressed():
	var question
	if Global.PlayerPosition < 5:
		question = get_random_question(Global.question_array_easy)
		while question in Global.AskedQuestions:
			question = get_random_question(Global.question_array_easy)
	elif Global.PlayerPosition > 3 and Global.PlayerPosition < 8:
		question = get_random_question(Global.question_array_medium)
		while question in Global.AskedQuestions:
			question = get_random_question(Global.question_array_medium)
	elif Global.PlayerPosition == 8:
		question = get_random_question(Global.question_array_hard)
		while question in Global.AskedQuestions:
			question = get_random_question(Global.question_array_hard)
	$Message.visible = false
	$Message/Panel/Label.add_theme_color_override("font_color", Color(1, 1, 1))
	Global.AskedQuestions.append(question)
	$BattleMenu/VBoxContainer/TriviaStrike.visible = false
	$BattleMenu/VBoxContainer/Overdrive.visible = false
	$BattleMenu/VBoxContainer/Defend.visible = true
	$Trivia.visible = true
	$Trivia/VBoxContainer/Question/Question/Label.text = question["question"]
	var ans : Array = []
	if Global.Orb == false:
		right_answer = question["ans1"]
		ans.append(question["ans1"])
		ans.append(question["ans2"])
		ans.append(question["ans3"])
		ans.append(question["ans4"])
		ans.shuffle()
		$Trivia/VBoxContainer/Ans12/Answer1/Label.text = ans[0]
		$Trivia/VBoxContainer/Ans12/Answer2/Label.text = ans[1]
		$Trivia/VBoxContainer/Ans34/Answer3/Label.text = ans[2]
		$Trivia/VBoxContainer/Ans34/Answer4/Label.text = ans[3]
	elif Global.Orb == true:
		right_answer = question["ans1"]
		ans.append(question["ans1"])
		ans.append(question["ans2"])
		ans.append(question["ans3"])
		ans.shuffle()
		$Trivia/VBoxContainer/Ans12/Answer1/Label.text = ans[0]
		$Trivia/VBoxContainer/Ans12/Answer2/Label.text = ans[1]
		$Trivia/VBoxContainer/Ans34/Answer3/Label.text = ans[2]
		$Trivia/VBoxContainer/Ans34/Answer4/Label.visible = false	

	
	


func get_random_question(array):
	if array.size() > 0:
		# Randomly select a question from the array
		var random_index = randi() % array.size()
		var random_question = array[random_index]
		
		# Remove the selected question from the array
		array.remove_at(random_index)
		
		return random_question
	else:
		print("Error: No questions remaining.")
		return {}


func _on_answer_1_pressed():
	emit_signal("answer_selected", $Trivia/VBoxContainer/Ans12/Answer1/Label.text)



func _on_answer_2_pressed():
	emit_signal("answer_selected", $Trivia/VBoxContainer/Ans12/Answer2/Label.text)



func _on_answer_3_pressed():
	emit_signal("answer_selected", $Trivia/VBoxContainer/Ans34/Answer3/Label.text)



func _on_answer_4_pressed():
	emit_signal("answer_selected", $Trivia/VBoxContainer/Ans34/Answer4/Label.text)
	

func _on_answer_selected(answer):
	check_answer(answer)

func check_answer(answer):
	if answer == right_answer:
		emit_signal("correct")

	else:
		emit_signal("incorrect")



func _on_correct():
	$BattleMenu/VBoxContainer/Defend.visible = false
	Global.Streak += 1
	$Streak/Panel/Label.text = "Streak = %d" % Global.Streak
	if Global.Streak > 1:
		Global.PlayerOverdrive += min(Global.Streak * 10, 40)
		if Global.PlayerOverdrive > Global.PlayerMaxOverdrive:
			Global.PlayerOverdrive = Global.PlayerMaxOverdrive
	var critcheck : int = randi_range(1, 20)
	var crit : bool = false
	if critcheck == 20:
		crit = true
	var damage : float
	if crit:
		damage = round(randi_range((Global.PlayerDamage * 1.5) - 2, (Global.PlayerDamage * 1.5) + 2))
	else:
		damage = round(randi_range(Global.PlayerDamage - 2, Global.PlayerDamage + 2))
	$Trivia/VBoxContainer/Ans12/Answer1.disabled = true
	$Trivia/VBoxContainer/Ans12/Answer2.disabled = true
	$Trivia/VBoxContainer/Ans34/Answer3.disabled = true
	$Trivia/VBoxContainer/Ans34/Answer4.disabled = true
	if $Trivia/VBoxContainer/Ans12/Answer1/Label.text == right_answer:
		$Trivia/VBoxContainer/Ans12/Answer1.modulate = Color(0, 1, 0, 1) # R=0, G=1, B=0

	elif $Trivia/VBoxContainer/Ans12/Answer2/Label.text == right_answer:
		$Trivia/VBoxContainer/Ans12/Answer2.modulate = Color(0, 1, 0, 1) # R=0, G=1, B=0

	elif $Trivia/VBoxContainer/Ans34/Answer3/Label.text == right_answer:
		$Trivia/VBoxContainer/Ans34/Answer3.modulate = Color(0, 1, 0, 1) # R=0, G=1, B=04print

	elif $Trivia/VBoxContainer/Ans34/Answer4/Label.text == right_answer:
		$Trivia/VBoxContainer/Ans34/Answer4.modulate = Color(0, 1, 0, 1) # R=0, G=1, B=0

	await get_tree().create_timer(0.5).timeout
	$Trivia.visible = false
	if crit:
		$Player/Sprite.play("crit")
		await get_tree().create_timer(1.4).timeout
		$SoundFX.set_stream(preload("res://Assets/MusicSFX/10_Battle_SFX/22_Slash_04.wav"))
		$SoundFX.play()
		display_text("Critical hit! Dealt %d damage!" % damage)
	else:
		$Player/Sprite.play("attack")
		$SoundFX.set_stream(preload("res://Assets/MusicSFX/10_Battle_SFX/22_Slash_04.wav"))
		$SoundFX.play()
		await get_tree().create_timer(1.0).timeout
		$SoundFX.play()
		display_text("Correct! Dealt %d damage!" % damage)
	var enemy_animation_player = current_enemy.get_node("Sprite")
	enemy_animation_player.play("hurt")
	emit_signal("shake")
	$SoundFX.set_stream(preload("res://Assets/MusicSFX/10_Battle_SFX/15_Impact_flesh_02.wav"))
	$SoundFX.play()
	await get_tree().create_timer(0.2).timeout
	$Player/Sprite.play("idle")
	await get_tree().create_timer(0.5).timeout
	enemy_animation_player.play("idle")
	current_enemy_health = max(0, current_enemy_health - damage)
	Global.set_health($EnemySpawn/EnemyHealthBar, current_enemy_health, current_enemy_max_health)
	Global.set_overdrive($Player/OverdriveBar, Global.PlayerOverdrive, Global.PlayerMaxOverdrive)
	if current_enemy_health > 0:
		$BattleMenu/VBoxContainer/TriviaStrike.visible = true
		if Global.PlayerOverdrive == Global.PlayerMaxOverdrive:
			$BattleMenu/VBoxContainer/Overdrive.visible = true
		$BattleMenu/VBoxContainer/Defend.visible = false
	
	$Trivia/VBoxContainer/Ans12/Answer1.disabled = false
	$Trivia/VBoxContainer/Ans12/Answer2.disabled = false
	$Trivia/VBoxContainer/Ans34/Answer3.disabled = false
	$Trivia/VBoxContainer/Ans34/Answer4.disabled = false
	$Trivia/VBoxContainer/Ans12/Answer1.modulate = Color(1, 1, 1, 1) # R=0, G=1, B=0
	$Trivia/VBoxContainer/Ans12/Answer2.modulate = Color(1, 1, 1, 1) # R=0, G=1, B=0
	$Trivia/VBoxContainer/Ans34/Answer3.modulate = Color(1, 1, 1, 1) # R=0, G=1, B=0
	$Trivia/VBoxContainer/Ans34/Answer4.modulate = Color(1, 1, 1, 1) # R=0, G=1, B=0
	
func _on_incorrect():
	$BattleMenu/VBoxContainer/Defend.visible = false
	Global.Streak = 0
	if $Trivia/VBoxContainer/Ans12/Answer1/Label.text == right_answer:
		$Trivia/VBoxContainer/Ans12/Answer1.modulate = Color(0, 1, 0, 1) # R=0, G=1, B=0

	elif $Trivia/VBoxContainer/Ans12/Answer2/Label.text == right_answer:
		$Trivia/VBoxContainer/Ans12/Answer2.modulate = Color(0, 1, 0, 1) # R=0, G=1, B=0

	elif $Trivia/VBoxContainer/Ans34/Answer3/Label.text == right_answer:
		$Trivia/VBoxContainer/Ans34/Answer3.modulate = Color(0, 1, 0, 1) # R=0, G=1, B=04

	elif $Trivia/VBoxContainer/Ans34/Answer4/Label.text == right_answer:
		$Trivia/VBoxContainer/Ans34/Answer4.modulate = Color(0, 1, 0, 1) # R=0, G=1, B=0
	$Trivia/VBoxContainer/Ans12/Answer1.disabled = true
	$Trivia/VBoxContainer/Ans12/Answer2.disabled = true
	$Trivia/VBoxContainer/Ans34/Answer3.disabled = true
	$Trivia/VBoxContainer/Ans34/Answer4.disabled = true
	await get_tree().create_timer(0.5).timeout
	$Trivia.visible = false
	var damage : float
	damage = randi_range(current_enemy_damage + 2, current_enemy_damage -2)
	var enemy_animation_player = current_enemy.get_node("Sprite")
	enemy_animation_player.play("attack")
	await get_tree().create_timer(1).timeout
	$BattleMenu/VBoxContainer/TriviaStrike.visible = true
	if Global.PlayerOverdrive == Global.PlayerMaxOverdrive:
		$BattleMenu/VBoxContainer/Overdrive.visible = true
	if current_enemy_name == "flying_eye":
		$EnemySoundFX.set_stream(preload("res://Assets/MusicSFX/10_Battle_SFX/08_Bite_04.wav"))
		$EnemySoundFX.play()
	else:
		$EnemySoundFX.set_stream(preload("res://Assets/MusicSFX/10_Battle_SFX/22_Slash_04.wav"))
		$EnemySoundFX.play()
	display_text("Incorrect! Received %d damage" % damage)
	$Player/Sprite.play("hurt")
	$SoundFX.set_stream(preload("res://Assets/MusicSFX/10_Battle_SFX/15_Impact_flesh_02.wav"))
	$SoundFX.play()
	emit_signal("shake")
	await get_tree().create_timer(0.5).timeout
	$Player/Sprite.play("idle")
	enemy_animation_player.play("idle")
	Global.PlayerHealth = max(0, Global.PlayerHealth - damage)
	Global.set_health($Player/HealthBar, Global.PlayerHealth, Global.PlayerMaxHealth)
	$Trivia/VBoxContainer/Ans12/Answer1.disabled = false
	$Trivia/VBoxContainer/Ans12/Answer2.disabled = false
	$Trivia/VBoxContainer/Ans34/Answer3.disabled = false
	$Trivia/VBoxContainer/Ans34/Answer4.disabled = false
	$Trivia/VBoxContainer/Ans12/Answer1.modulate = Color(1, 1, 1, 1) # R=0, G=1, B=0
	$Trivia/VBoxContainer/Ans12/Answer2.modulate = Color(1, 1, 1, 1) # R=0, G=1, B=0
	$Trivia/VBoxContainer/Ans34/Answer3.modulate = Color(1, 1, 1, 1) # R=0, G=1, B=0
	$Trivia/VBoxContainer/Ans34/Answer4.modulate = Color(1, 1, 1, 1) # R=0, G=1, B=0

func display_text(text):
	$Message.show()
	$Message/Panel/Label.text = text
	await get_tree().create_timer(3).timeout
	$Message.hide()


func Victory():
	var enemy_animation_player = current_enemy.get_node("Sprite")
	enemy_animation_player.play("death")
	$BattleMenu.visible = false
	if Global.PlayerPosition == 8:
		display_text("You defeated the boss! Endless treasures await you...")
		await get_tree().create_timer(3.0).timeout
		$Outro.visible = true
		$Tilesets.visible = false
		$Player.visible = false
		$EnemySpawn.visible = false
		$Outro/Intro_Outro/VBoxContainer/PanelContainer/Panel/Label.text = "Good work finishing the game! That is all the content I've added so far, thanks so much for playing!
		-Eggy"
		$Outro/Intro_Outro/VBoxContainer/PanelContainer2/Continue.text = "Return to Main Menu"
	else:
		display_text("Victory!")
		await get_tree().create_timer(2).timeout
		get_tree().change_scene_to_file("res://main.tscn")

func GameOver():
	if Global.Ankh == true:
		display_text("The Ankh of Resurrquestion has preserved your life!")
		Global.PlayerHealth = 1
		Global.set_health($Player/HealthBar, Global.PlayerHealth, Global.PlayerMaxHealth)
		Global.Ankh = false
	else:
		$Player/Sprite.play("death")
		display_text("You died...")
		await get_tree().create_timer(2).timeout
		get_tree().change_scene_to_file("res://main_menu.tscn")



func _on_defend_pressed():
	$Trivia.visible = false
	$BattleMenu/VBoxContainer/Defend.visible = false
	var damage : float
	damage = round(randi_range(current_enemy_damage + 2, current_enemy_damage -2) / 2)
	var enemy_animation_player = current_enemy.get_node("Sprite")
	enemy_animation_player.play("attack")
	await get_tree().create_timer(1).timeout
	$BattleMenu/VBoxContainer/TriviaStrike.visible = true
	if Global.PlayerOverdrive == Global.PlayerMaxOverdrive:
		$BattleMenu/VBoxContainer/Overdrive.visible = true
	display_text("You braced yourself for the attack... Received %d damage" % damage)
	$Player/Sprite.play("hurt")
	emit_signal("shake")
	$SoundFX.set_stream(preload("res://Assets/MusicSFX/10_Battle_SFX/15_Impact_flesh_02.wav"))
	$SoundFX.play()
	if current_enemy_name == "flying_eye":
		$EnemySoundFX.set_stream(preload("res://Assets/MusicSFX/10_Battle_SFX/08_Bite_04.wav"))
		$EnemySoundFX.play()
	else:
		$EnemySoundFX.set_stream(preload("res://Assets/MusicSFX/10_Battle_SFX/22_Slash_04.wav"))
		$EnemySoundFX.play()
	await get_tree().create_timer(0.5).timeout
	$Player/Sprite.play("idle")
	enemy_animation_player.play("idle")
	Global.PlayerHealth = max(0, Global.PlayerHealth - damage)
	Global.set_health($Player/HealthBar, Global.PlayerHealth, Global.PlayerMaxHealth)


func _on_overdrive_pressed():
	$BattleMenu/VBoxContainer/TriviaStrike.visible = false
	$BattleMenu/VBoxContainer/Overdrive.visible = false
	var damage = round(randi_range((Global.PlayerDamage * 1.5) - 2, (Global.PlayerDamage * 1.5) + 2))
	$Player/Sprite.play("crit")
	await get_tree().create_timer(1.4).timeout
	$SoundFX.set_stream(preload("res://Assets/MusicSFX/10_Battle_SFX/22_Slash_04.wav"))
	$SoundFX.play()
	display_text("Critical hit! Dealt %d damage!" % damage)
	Global.PlayerOverdrive = 0
	Global.set_overdrive($Player/OverdriveBar, Global.PlayerOverdrive, Global.PlayerMaxOverdrive)
	var enemy_animation_player = current_enemy.get_node("Sprite")
	enemy_animation_player.play("hurt")
	$SoundFX.set_stream(preload("res://Assets/MusicSFX/10_Battle_SFX/15_Impact_flesh_02.wav"))
	$SoundFX.play()
	emit_signal("shake")
	await get_tree().create_timer(0.2).timeout
	$Player/Sprite.play("idle")
	await get_tree().create_timer(0.5).timeout
	enemy_animation_player.play("idle")
	current_enemy_health = max(0, current_enemy_health - damage)
	Global.set_health($EnemySpawn/EnemyHealthBar, current_enemy_health, current_enemy_max_health)
	$BattleMenu/VBoxContainer/TriviaStrike.visible = true
	
