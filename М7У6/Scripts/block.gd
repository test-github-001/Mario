extends StaticBody2D

class_name Block

@onready var ray_cast_2d = $RayCast2D

enum Bonus {
	SHROOM,
	COIN
}

const SHROOM_SCENE = preload("res://Scenes/shroom.tscn")
const COIN_SCENE = preload("res://Scenes/coin.tscn")

@onready var animated_sprite_2d = $AnimatedSprite2D
@export var bonus_type: Bonus = Bonus.SHROOM
@export var invisible: bool = false

var is_empty = false

func _ready():
	animated_sprite_2d.visible = !invisible
	
func make_empty():
	is_empty = true
	animated_sprite_2d.play("empty")

func spawn_shroom():
	var shroom = SHROOM_SCENE.instantiate()
	shroom.global_position = global_position
	get_tree().root.add_child(shroom)
	
func spawn_coin():
	var coin = COIN_SCENE.instantiate()
	coin.global_position = global_position + Vector2(0, -15)
	get_tree().root.add_child(coin)
	
func bump(player_state: Player.State):
	var bump_tween = get_tree().create_tween()
	bump_tween.tween_property(self, "position", position + Vector2(0, -5), .12)
	bump_tween.chain().tween_property(self, "position", position, .12)
	if is_empty:
		return
		
	if invisible:
		animated_sprite_2d.visible = true
		invisible = !invisible
	

	make_empty()
	
	match bonus_type:
		Bonus.SHROOM:
			spawn_shroom()
		Bonus.COIN:
			spawn_coin()
		
