extends CharacterBody2D

var speed: float = 0.0
var acceleration: float = 100.0
var brake_power: float = 80.0
var max_speed: float = 200.0
var max_reverse_speed: float = 80.0
var rotation_speed: float = 2.0
var friction: float = 40.0

func _ready() -> void:
	pass
	
func _process(delta: float) -> void:
	_steer(delta)
	_move(delta)
	
func _steer(delta: float) -> void:
	if Input.is_action_pressed("steer_right"):
		rotation += rotation_speed * delta
	elif Input.is_action_pressed("steer_left"):
		rotation -= rotation_speed * delta
		
func _move(delta: float) -> void:
	if Input.is_action_pressed("accelerate"):
		speed += acceleration * delta
	elif Input.is_action_pressed("brake"):
		speed -= brake_power * delta
	else:
		speed = move_toward(speed,0.0,friction * delta)
	speed = clamp(speed,-max_reverse_speed,max_speed)
	var direction: Vector2 = Vector2.UP.rotated(rotation)
	velocity = direction * speed
	move_and_slide()
	
	
