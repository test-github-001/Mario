extends Area2D

@onready var WinLabel = $"../CanvasLayer/WinLabel"

func _ready():
	if WinLabel:
		WinLabel.visible = false  # Скрываем надпись в начале

func _on_body_entered(body):
	if body.name == "Player":
		WinLabel.text = "Победа"
		WinLabel.visible = true
