extends CharacterBody2D

var speed: float = 0.0
var acceleration: float = 200.0
var brake_power: float = 150.0
var max_speed: float = 350.0
var max_reverse_speed: float = 120.0
var rotation_speed: float = 2.0
var friction: float = 40.0
var grip_traction: float = 2.5
var drift_traction: float = 0.5
var grip_angle_threshold: float = 8.0
var max_slip_angle: float = 60.0
var min_steer_turn_factor: float = 0.25
func _ready() -> void:
	pass
	
func _process(delta: float) -> void:
	_steer(delta)
	_move(delta)
	
func _steer(delta: float) -> void:
	var steer_input: float = 0.0
	if Input.is_action_pressed("steer_right"):
		steer_input = 1.0
	elif Input.is_action_pressed("steer_left"):
		steer_input = -1.0
	if speed < 0:
		steer_input = -steer_input
	var speed_factor: float = 1.0 - (abs(speed) / max_speed) * (1.0 - min_steer_turn_factor )
	rotation += steer_input * rotation_speed * speed_factor * delta
		
func _move(delta: float) -> void:
	if Input.is_action_pressed("accelerate"):
		speed += acceleration * delta
	elif Input.is_action_pressed("brake"):
		speed -= brake_power * delta
	else:
		speed = move_toward(speed,0.0,friction * delta)
	speed = clamp(speed,-max_reverse_speed,max_speed)
	var direction: Vector2 = Vector2.UP.rotated(rotation)
	var slip_angle: float = abs(direction.angle_to(velocity))
	var slip_deg: float = rad_to_deg(slip_angle)
	var lateral_t: float = clamp((slip_deg - grip_angle_threshold)/ (max_slip_angle - grip_angle_threshold), 0.0, 1.0)
	var longitudinal_t: float = 1.0 if (Input.is_action_pressed("accelerate") or Input.is_action_pressed("brake")) else 0.0
	var combined_t: float = clamp(sqrt(lateral_t * lateral_t + longitudinal_t * longitudinal_t),0.0,1.0)
	var effective_traction: float = lerp(grip_traction, drift_traction, combined_t)
	var target_velocity: Vector2 = direction * speed
	velocity = velocity.lerp(target_velocity,effective_traction * delta)
	move_and_slide()
	
	
