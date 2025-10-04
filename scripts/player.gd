extends CharacterBody2D


const speed = 150.0
var last_direction = Vector2.DOWN
@onready var anim_player = $AnimatedSprite2D

func _physics_process(delta):

	var input_vector = Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	).normalized()

	velocity = input_vector * speed
	move_and_slide()
	if input_vector == Vector2.ZERO:
		if last_direction == Vector2.DOWN:
			anim_player.play("Idle_down")
		elif last_direction == Vector2.UP:
			anim_player.play("Idle_up")
		elif last_direction == Vector2.RIGHT:
			anim_player.flip_h=false
			anim_player.play("idle_right")
		elif last_direction == Vector2.LEFT:
			anim_player.flip_h=true
			anim_player.play("idle_right")
		
	elif input_vector == Vector2.RIGHT:
		anim_player.flip_h=false
		last_direction = input_vector
		anim_player.play("running_horizontal")
	elif input_vector == Vector2.LEFT:
		anim_player.flip_h=true
		last_direction = input_vector
		anim_player.play("running_horizontal")
	elif input_vector == Vector2.DOWN:
		last_direction = input_vector
		anim_player.play("running_down")
	elif input_vector == Vector2.UP:
		last_direction = input_vector
		anim_player.play("running_up")
