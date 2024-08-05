extends CharacterBody2D
@onready var animation_tree = $AnimationTree as AnimationTree
@onready var remote = $Remote as RemoteTransform2D

var state_machine
var move_speed: float
var acceleration: float
var friction: float

func _ready():
	state_machine = animation_tree["parameters/playback"]
	move_speed = 100.0
	acceleration = 0.2
	friction = 0.0

func _physics_process(delta):
	move(delta)
	animate()
	move_and_slide()

func move(delta):
	var direction: Vector2 = Vector2(Input.get_axis("ui_left", "ui_right"), Input.get_axis("ui_up", "ui_down"))
	
	if direction != Vector2.ZERO:
		animation_tree["parameters/walk/blend_position"] = direction
		animation_tree["parameters/idle/blend_position"] = direction
		velocity.x = lerp(velocity.x, direction.normalized().x * move_speed, acceleration)
		velocity.y = lerp(velocity.y, direction.normalized().y * move_speed, acceleration)
		return
	
	velocity.x = lerp(velocity.x, direction.normalized().x * move_speed, friction)
	velocity.y = lerp(velocity.y, direction.normalized().y * move_speed, friction)
	
	velocity = direction.normalized() * move_speed * delta

func animate():
	if velocity.length() > 1:
		state_machine.travel("walk")
		return
	state_machine.travel("idle")

func follow_camera(camera):
	remote.remote_path = camera.get_path()
