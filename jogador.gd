extends CharacterBody3D

@export var velocidade: float
@export var pulo: float
@export var queda: float

@export_group("Visão câmera")
@export var pivot_camera: Node3D
@export var sensibilidade: float
@export var visao_min_angle: float
@export var visao_max_angle: float



var dir: Vector3
var target_velocity: Vector3
var look_rot: Vector3

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta: float) -> void:
	pivot_camera.rotation_degrees.x = look_rot.x
	rotation_degrees.y = look_rot.y
	
	
	dir = Vector3.ZERO
	
	dir.x = Input.get_axis("player_right", "player_left")
	dir.z = Input.get_axis("player_down", "player_up")
	
	if dir != Vector3.ZERO:
		dir = dir.normalized()
	
	var up_vector = global_transform.basis.y
	
	dir = dir.rotated(up_vector, rotation.y)
	
	target_velocity.x = dir.x * velocidade 
	target_velocity.z = dir.z * velocidade
	
	if not is_on_floor():
		target_velocity.y = target_velocity.y - (queda * delta)
	
	velocity = target_velocity
	move_and_slide()
	

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("player_jump"):
		target_velocity.y = pulo
		
	if event is InputEventMouseMotion:
		look_rot.y -= event.relative.x * sensibilidade
		look_rot.x -= -event.relative.y * sensibilidade
		look_rot.x = clamp(look_rot.x, visao_min_angle, visao_max_angle)
		

	
