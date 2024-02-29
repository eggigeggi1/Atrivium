extends Node

var PlayerPath : Array = []
var NextNode
var Path1Array = []
var Path2Array = []
var Path3Array = []
# Called when the node enters the scene tree for the first time.
func _ready():
	var path1 = $MapNodes/MapNodes/Path1
	for i in range(path1.get_child_count()):
		var child = path1.get_child(i)
		if child is Button:
			Path1Array.append(child)
			var group = child.get_groups()
			if group:
				child.pressed.connect(on_button_pressed.bind(group[0]))
	Path1Array.append($MapNodes/MapNodes/Boss)
				
	var path2 = $MapNodes/MapNodes/Path2
	for i in range(path2.get_child_count()):
		var child = path2.get_child(i)
		if child is Button:
			Path2Array.append(child)
			var group = child.get_groups()
			if group:
				child.pressed.connect(on_button_pressed.bind(group[0]))
	
	Path2Array.append($MapNodes/MapNodes/Boss)
	
	var path3 = $MapNodes/MapNodes/Path3
	for i in range(path3.get_child_count()):
		var child = path3.get_child(i)
		if child is Button:
			Path3Array.append(child)
			var group = child.get_groups()
			if group:
				child.pressed.connect(on_button_pressed.bind(group[0]))
	Path1Array.append($MapNodes/MapNodes/Boss)
	
	$UI/Panel/HealthBar.max_value = Global.PlayerMaxHealth
	Global.set_health($UI/Panel/HealthBar, Global.PlayerHealth, Global.PlayerMaxHealth)
	updateButtons(Global.PlayerPosition, Global.PlayerPath)
	if Global.Ankh == true:
		$UI/Treasure/HBoxContainer/Container.visible = true
	if Global.Blade == true:
		$UI/Treasure/HBoxContainer/Container2.visible = true
	if Global.Orb == true:
		$UI/Treasure/HBoxContainer/Container3.visible = true

func updateButtons(position, path):
	print(position)
	print(path)
	if position == 1 and path == 0:
		$"MapNodes/MapNodes/Path1/Path1-1".disabled = false
		$"MapNodes/MapNodes/Path2/Path2-1".disabled = false
		$"MapNodes/MapNodes/Path3/Path3-1".disabled = false
		$MapNodes/MapNodes/Start.disabled = true
		$MapNodes/MapNodes/Start/Label.visible = true
	elif position != 0:
		$"MapNodes/MapNodes/Start".disabled = true
		$MapNodes/MapNodes/Start/Label.visible = true
		if path == 1:
			for i in range(position-1):
				var node = Path1Array[i]
				node.disabled =  true
				var label = node.get_node("Label")
				label.visible = true
			
			if position == 8:
				$MapNodes/MapNodes/Boss.disabled = false
			else:
				NextNode = Path1Array[position-1]
				NextNode.disabled = false
		elif path == 2:
			for i in range(position-1):
				var node = Path2Array[i]
				node.disabled =  true
				var label = node.get_node("Label")
				label.visible = true
				
			if position == 8:
				$MapNodes/MapNodes/Boss.disabled = false
			else:
				NextNode = Path2Array[position-1]
				NextNode.disabled = false
		
		elif path == 3:
			for i in range(position-1):
				var node = Path3Array[i]
				node.disabled =  true
				var label = node.get_node("Label")
				label.visible = true
			
			if position == 8:
				$MapNodes/MapNodes/Boss.disabled = false
			else:
				NextNode = Path3Array[position-1]
				NextNode.disabled = false
	
func on_button_pressed(group_name : String):
	if group_name == "FightButtons":
		Global.PlayerPosition += 1
		get_tree().change_scene_to_file("res://battle_scene.tscn")
	elif group_name == "TreasureButtons":
		Global.PlayerPosition += 1
		get_tree().change_scene_to_file("res://treasure_scene.tscn")
	elif group_name == "HealButtons":
		Global.PlayerPosition += 1
		get_tree().change_scene_to_file("res://heal_scene.tscn")
	elif group_name == "EventButtons":
		Global.PlayerPosition += 1
		get_tree().change_scene_to_file("res://event_scene.tscn")

func _on_start_pressed():
	Global.PlayerPosition = 1
	get_tree().change_scene_to_file("res://battle_scene.tscn")


func _on_path_11_pressed():
	Global.PlayerPath = 1
	Global.PlayerPosition += 1
	get_tree().change_scene_to_file("res://battle_scene.tscn")


func _on_path_21_pressed():
	Global.PlayerPath = 2
	Global.PlayerPosition += 1
	get_tree().change_scene_to_file("res://battle_scene.tscn")


func _on_path_31_pressed():
	Global.PlayerPath = 3
	Global.PlayerPosition += 1
	get_tree().change_scene_to_file("res://heal_scene.tscn")


func _on_container_mouse_entered():
	$UI/Treasure/Tooltip.visible = true
	$UI/Treasure/Tooltip/Panel/Label.text = "The Ankh of Resurrquestion will revive its owner with 1 HP should they fall in battle"

func _on_container_mouse_exited():
	$UI/Treasure/Tooltip.visible = false


func _on_container_2_mouse_entered():
	$UI/Treasure/Tooltip.visible = true
	$UI/Treasure/Tooltip/Panel/Label.text = "The Quizzblade will increase the Attack of its owner by 10"


func _on_container_2_mouse_exited():
	$UI/Treasure/Tooltip.visible = false


func _on_container_3_mouse_entered():
	$UI/Treasure/Tooltip.visible = true
	$UI/Treasure/Tooltip/Panel/Label.text = "The Triviorb of True Sight will allow its owner to glimpse into the truths of this world (3 options instead of 4 on Trivia Strikes)"


func _on_container_3_mouse_exited():
	$UI/Treasure/Tooltip.visible = false


func _on_boss_pressed():
	get_tree().change_scene_to_file("res://battle_scene.tscn")
