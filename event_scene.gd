extends Node2D

var Event : int
# Called when the node enters the scene tree for the first time.
func _ready():
	Event = randi_range(1, 3)
	if Event == 1:
		$Event/Text/Label.text = "You found a health potion on the ground left behind by a previous adventurer... lucky you!"
		$Event/HBoxContainer/PanelContainer/Panel/Label.text = "Drink health potion?"
		$Potion.visible = true
	elif Event == 2:
		$Event/Text/Label.text = "You found a book of helpful spells, left behind by a previous adventurer!"
		$Event/HBoxContainer/PanelContainer/Panel/Label.text = "Chant spell?"
		$Book.visible = true
	elif Event == 3:
		$Event/Text/Label.text = "You found a magical staff, left behind by a previous adventurer!"
		$Event/HBoxContainer/PanelContainer/Panel/Label.text = "Touch the staff?"
		$Staff.visible = true
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_accept_pressed():
	$Event/HBoxContainer.visible = false
	if Event == 1:
		$Event/Text/Label.text = "The potion restored you to full health!"
		Global.PlayerHealth = Global.PlayerMaxHealth
		await get_tree().create_timer(2.0).timeout
		get_tree().change_scene_to_file("main.tscn")
		
	elif Event == 2:
		$Event/Text/Label.text = "The spell has weakened your next fight's opponent! (HP halved)"
		Global.WeakenSpell = true
		await get_tree().create_timer(2.0).timeout
		get_tree().change_scene_to_file("main.tscn")
	elif Event == 3:
		$Event/Text/Label.text = "You feel holy energy coursing through you, strengthening your resolve! (Max HP increased)"
		Global.PlayerMaxHealth += 20
		Global.PlayerHealth += 20
		if Global.PlayerHealth > Global.PlayerMaxHealth:
			Global.PlayerHealth = Global.PlayerHealth
		await get_tree().create_timer(2.0).timeout
		get_tree().change_scene_to_file("main.tscn")
