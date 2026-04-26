extends Timer

@export var total_time := 60
var remaining_time := 0

@onready var label = $"../CanvasLayer/Label"
@onready var player = $"../Player"

func _ready():
	remaining_time = total_time
	update_label()
	start()

func _on_timeout():
	remaining_time -= 1
	update_label()
	if remaining_time <= 0:
		stop()
		if player:
			player.is_die = true

func update_label():
	if label:
		label.text = "Время: " + str(remaining_time)
