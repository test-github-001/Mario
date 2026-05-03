extends CharacterBody2D

var chase = false
var speed = 50
@onready var anim = $AnimatedSprite2D
var alive = true
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
			velocity.x = direction * speed
			anim.play("walk")
	
	move_and_slide()

func _on_detector_body_entered(body):
	if body.name == 'Player':
		chase = true

func _on_death_body_entered(body):
	body.velocity.y -= 200
	death()

func _on_death_2_body_entered(body):
	if body.name == 'Player':
		body.is_die = true
	elif body.is_in_group("Bullets"):
		death()
		velocity.x = 0

func death():
	alive = false
	anim.play("dead")
	set_collision_layer_value(3, false)
	set_collision_mask_value(1, false)
	get_tree().create_timer(1.0).timeout.connect(queue_free)
