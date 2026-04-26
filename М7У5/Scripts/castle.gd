extends Area2D

@onready var canvas_layer = $"../CanvasLayer"

func _on_body_entered(body):
	if body.name == 'Player':
		canvas_layer.visible = true
		
		
