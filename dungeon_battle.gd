extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$TorchSprite.play("burn")
	$TorchSprite2.play("burn")
	$TorchSprite3.play("burn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
