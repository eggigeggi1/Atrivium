extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	Global.set_health($Player/HealthBar, Global.PlayerHealth, Global.PlayerMaxHealth)

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_yes_mouse_entered():
	$Healer/Tooltip.visible = true
	



func _on_yes_mouse_exited():
	$Healer/Tooltip.visible = false


func _on_yes_pressed():
	$Healer/VBoxContainer/Text/Label.text = "The Deal is struck!"
	$Healer/VBoxContainer/HBoxContainer.visible = false
	await get_tree().create_timer(0.5).timeout
	$Healer/Sprite.play("attack")
	await get_tree().create_timer(2.1).timeout
	Global.PlayerHealth += 50
	Global.PlayerMaxHealth -= 10
	if Global.PlayerMaxHealth < Global.PlayerHealth:
		Global.PlayerHealth = Global.PlayerMaxHealth
	$Player/Sprite.play("hurt")
	Global.set_health($Player/HealthBar, Global.PlayerHealth, Global.PlayerMaxHealth)
	$Healer/Sprite.play("idle")
	await get_tree().create_timer(1).timeout
	$Player/Sprite.play("idle")
	get_tree().change_scene_to_file("main.tscn")
	
	



func _on_no_pressed():
	$Healer/VBoxContainer/Text/Label.text = "Disappointing... you'll be back"
	$Healer/VBoxContainer/HBoxContainer.visible = false
	await get_tree().create_timer(0.5).timeout
	$Healer/Sprite.play("attack")
	await get_tree().create_timer(2.1).timeout
	get_tree().change_scene_to_file("main.tscn")
