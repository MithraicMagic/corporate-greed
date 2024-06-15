extends CharacterBody2D

@onready var _animated_sprite = $AnimatedSprite2D

const ACCELERATION = 50.0
const MAX_SPEED = 300.0
const JUMP_VELOCITY = -500.0

# wall interaction variables
enum { LEFT, RIGHT, NONE }
const WALL_FRICTION_MOD = 0.3
const MAX_WALL_STICK_TIME_S = 2.0
var wall_stick_time_s = 0.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	var input_direction = Input.get_axis("left", "right")
	
	if not is_on_floor():
		if is_on_wall_only() && velocity.y >= 0 && input_direction != 0:
			wall_stick_time_s = move_toward(wall_stick_time_s, MAX_WALL_STICK_TIME_S, delta)
			if wall_stick_time_s == MAX_WALL_STICK_TIME_S:
				velocity.y += gravity * delta * WALL_FRICTION_MOD
			else:
				velocity.y = 0

		# handle regular gravity
		else:
			velocity.y += gravity * delta

		# handle wall jump
		if is_on_wall_only() && Input.is_action_just_pressed("jump"):
			var wall_direction = LEFT if get_slide_collision(0).get_normal().x > 0 else RIGHT
			velocity.x = -JUMP_VELOCITY if wall_direction == LEFT else JUMP_VELOCITY
			velocity.y = JUMP_VELOCITY / 1.2

	if is_on_floor():
		# handle jump
		if Input.is_action_just_pressed("jump"):
			velocity.y = JUMP_VELOCITY
		
		# reset wall stick frames
		if wall_stick_time_s != 0.0:
			wall_stick_time_s = 0.0


	# Get the input direction and handle the movement/deceleration
	if input_direction != 0:
		velocity.x = move_toward(
			velocity.x, -MAX_SPEED if input_direction < 0 else MAX_SPEED, MAX_SPEED / 6)
	elif is_on_floor():
		velocity.x = move_toward(velocity.x, 0, MAX_SPEED / 3)
	else:
		velocity.x = move_toward(velocity.x, 0, MAX_SPEED / 20)

	# set player in right direction
	if input_direction >= 0:
		_animated_sprite.flip_h = false
	else:
		_animated_sprite.flip_h = true

	# play animation
	if velocity.x != 0 && velocity.y == 0:
		_animated_sprite.play("run")
	elif velocity.y < 0:
		_animated_sprite.play("idle")
	elif velocity.y > 0:
		_animated_sprite.play("idle")
	else:
		_animated_sprite.play("idle")

	move_and_slide()
