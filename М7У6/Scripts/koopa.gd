extends CharacterBody2D

var chase = false
var walk_speed = 30
var attack_speed = 200
var alive = true
@onready var anim = $AnimatedSprite2D
var direction := -1

func _physics_process(delta):
	
	if not is_on_floor():
		velocity += get_gravity() * delta

	if alive:
		# Если скорость по X стала 0 → разворот
		if abs(velocity.x) < 0.1:
			direction *= -1
			anim.flip_h = direction == 1
			
		if chase:
			velocity.x = direction * walk_speed
			anim.play("walk")
	
	move_and_slide()

func _on_detector_body_entered(body):
	if body.name == 'Player':
		chase = true

func _on_death_body_entered(body):
	if body.name == 'Player':
		add_to_group("Bullets")
		set_collision_layer_value(1, true)
		velocity.x = 0
		alive = false
		anim.play("shell")

func _on_attack_1_body_entered(body: Node2D) -> void:
	if alive and body.name == 'Player':
		body.is_die = true
	elif body.is_in_group("Bullets"):
		velocity.x = 0
		set_collision_mask_value(1, false)
		death()
	elif !alive and body.name == 'Player':
		velocity.x = attack_speed
		death()

func _on_attack_2_body_entered(body: Node2D) -> void:
	if alive and body.name == 'Player':
		body.is_die = true
	elif body.is_in_group("Bullets"):
		velocity.x = 0
		set_collision_mask_value(1, false)
		death()
	elif !alive and body.name == 'Player':
		velocity.x = -attack_speed
		death()

func death():
	alive = false
	anim.play("shell")
	get_tree().create_timer(2.0).timeout.connect(queue_free)
