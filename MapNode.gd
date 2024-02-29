extends Node

class MapNode:
	var position: Vector2
	var type: int
	var connections: Array
	
	#Constructor
	func _init(position: Vector2, type: int):
		self.position = position
		self.type = type
		self.connections = []
