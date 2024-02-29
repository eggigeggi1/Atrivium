extends Control




func _on_panel_mouse_entered():
	$Tooltip.visible = true


func _on_panel_mouse_exited():
	$Tooltip.visible = false
