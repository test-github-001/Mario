extends CharacterBody2D

class_name Player

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

enum State {SMALL, BIG}

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var collision_shape_2d = $CollisionShape2D
@onready var area_2d = $Area2D


var speed = 200
var jump_velocity = -350
var slowdown = 0.5
var player_state = State.SMALL
var is_die = false
var is_growing = false

var small_collision_size = Vector2(16, 16)
var big_collision_size = Vector2(16, 32)

func _ready():
	var shape = collision_shape_2d.shape
	shape.extents = small_collision_size / 2

func _physics_process(delta):
	if is_growing:
		return
	if not is_die:
		if not is_on_floor():
			velocity.y += gravity * delta
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = jump_velocity
		if Input.is_action_just_released("jump") and velocity.y < 0:
			velocity.y *= 0.5
			
		var direction = Input.get_axis("left", "right")
		if direction:
			velocity.x = lerpf(velocity.x, speed * direction, slowdown * delta)
		else: 
			velocity.x = move_toward(velocity.x, 0, speed * delta)
		
		animated_sprite_2d.trigger_animation(velocity, direction, player_state)
	else:
		animated_sprite_2d.play("death")
		set_collision_layer_value(1, false)
		set_collision_mask_value(3, false)
		
		var death_tween = get_tree().create_tween()
		death_tween.tween_property(self, "position", position + Vector2(0, -50), .5)
		death_tween.chain().tween_property(self, "position", position + Vector2(0, 250), 1)
		set_physics_process(false)
		death_tween.tween_callback(func (): get_tree().reload_current_scene())
	
	var collision = get_last_slide_collision()
	if collision != null:
		handle_movement_collision(collision)
	move_and_slide()
	
func _on_area_2d_area_entered(area):
	player_state = State.BIG
	is_growing = true
	animated_sprite_2d.play("small_to_big")
	var shape = collision_shape_2d.shape
	shape.extents = big_collision_size / 2
	area.queue_free()


func _on_animated_sprite_2d_animation_finished():
	if animated_sprite_2d.animation == "small_to_big":
		is_growing = false
		
func handle_movement_collision(collision):
	if collision.get_collider() is Block:
		var collision_angle = rad_to_deg(collision.get_angle())
		if roundf(collision_angle) == 180:
			(collision.get_collider() as Block).bump(player_state)
