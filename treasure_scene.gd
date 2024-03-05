extends Node2D

var TreasureArray : Array = []
var Treasure1
var Treasure2
# Called when the node enters the scene tree for the first time.
func _ready():
	$Chest/Sprite.play("idle")
	var random_index = randi_range(0, 2)
	TreasureArray = ["Ankh of Resurrquestion", "Quizzblade", "Triviorb of True Sight"]
	Treasure1 = TreasureArray[random_index]
	TreasureArray.remove_at(random_index)
	random_index = randi_range(0, 1)
	Treasure2 = TreasureArray[random_index]



func _on_yes_pressed():
	$VBoxContainer.visible = false
	$Chest/Sprite.play("open")
	$Loot.visible = true
	$Loot/Reward1/PanelContainer/Panel/Label.text = Treasure1
	$Loot/Reward2/PanelContainer/Panel2/Label.text = Treasure2
	
	if Treasure1 == "Ankh of Resurrquestion":
		$Tooltip/Panel/Label.text = "The Ankh of Resurrquestion will revive its owner with 1 HP should they fall in battle"
		$Treasures1/Ankh.visible = true
	elif Treasure1 == "Quizzblade":
		$Tooltip/Panel/Label.text = "The Quizzblade will increase the Attack of its owner by 10"
		$Treasures1/Blade.visible = true
	elif Treasure1 == "Triviorb of True Sight":
		$Tooltip/Panel/Label.text = "The Triviorb of True Sight will allow its owner to glimpse into the truths of this world (3 options instead of 4 on Trivia Strikes)"
		$Treasures1/Orb.visible = true
	
	if Treasure2 == "Ankh of Resurrquestion":
		$Tooltip/Panel/Label.text = "The Ankh of Resurrquestion will revive its owner with 1 HP should they fall in battle"
		$Treasures2/Ankh.visible = true
	elif Treasure2 == "Quizzblade":
		$Tooltip/Panel/Label.text = "The Quizzblade will increase the Attack of its owner by 10"
		$Treasures2/Blade.visible = true
	elif Treasure2 == "Triviorb of True Sight":
		$Tooltip/Panel/Label.text = "The Triviorb of True Sight will allow its owner to glimpse into the truths of this world (3 options instead of 4 on Trivia Strikes)"
		$Treasures2/Orb.visible = true


func _on_no_pressed():
	$VBoxContainer.visible = false
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file("res://main.tscn")


func _on_accept_pressed():
	if Treasure1 == "Ankh of Resurrquestion":
		Global.Ankh = true
	elif Treasure1 == "Quizzblade":
		Global.Blade = true
		Global.PlayerDamage += 10
	elif Treasure1 == "Triviorb of True Sight":
		Global.Orb = true
	get_tree().change_scene_to_file("main.tscn")

func _on_panel_mouse_entered():
	if Treasure1 == "Ankh of Resurrquestion":
		$Tooltip/Panel/Label.text = "The Ankh of Resurrquestion will revive its owner with 1 HP should they fall in battle"
	elif Treasure1 == "Quizzblade":
		$Tooltip/Panel/Label.text = "The Quizzblade will increase the Attack of its owner by 10"
	elif Treasure1 == "Triviorb of True Sight":
		$Tooltip/Panel/Label.text = "The Triviorb of True Sight will allow its owner to glimpse into the truths of this world (3 options instead of 4 on Trivia Strikes)"
	$Tooltip.visible = true
	

func _on_panel_mouse_exited():
	$Tooltip.visible = false


func _on_accept_2_pressed():
	if Treasure2 == "Ankh of Resurrquestion":
		Global.Ankh = true
	elif Treasure2 == "Quizzblade":
		Global.Blade = true
		Global.PlayerDamage += 10
	elif Treasure2 == "Triviorb of True Sight":
		Global.Orb = true
	get_tree().change_scene_to_file("main.tscn")


func _on_panel_2_mouse_entered():
	if Treasure2 == "Ankh of Resurrquestion":
		$Tooltip/Panel/Label.text = "The Ankh of Resurrquestion will revive its owner with 1 HP should they fall in battle"
	elif Treasure2 == "Quizzblade":
		$Tooltip/Panel/Label.text = "The Quizzblade will increase the Attack of its owner by 10"
	elif Treasure2 == "Triviorb of True Sight":
		$Tooltip/Panel/Label.text = "The Triviorb of True Sight will allow its owner to glimpse into the truths of this world (3 options instead of 4 on Trivia Strikes)"
	$Tooltip.visible = true


func _on_panel_2_mouse_exited():
	$Tooltip.visible = false
