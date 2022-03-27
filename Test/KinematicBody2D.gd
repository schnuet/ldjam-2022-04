extends KinematicBody2D

var velocity = Vector2(0,0)

const MAX_SPEED = 300
const ACCELERATION = 20

func _physics_process(delta):
	if get_input_vector() != Vector2.ZERO:
		
		var target_velocity = get_input_vector() * MAX_SPEED
		var difference = target_velocity - velocity
		var max_movement = min(difference.length(), ACCELERATION)
		
		velocity += difference.normalized() * max_movement
	
	else:
		velocity = velocity * 0.9
	
	velocity = velocity.limit_length(MAX_SPEED)
	
	move_and_slide(velocity)
	

func get_input_vector():
	return Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)
