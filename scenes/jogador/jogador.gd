extends CharacterBody3D

@export_group("Vida")
@export var vida: float
@export var vida_max: float
@export var decaimento_vida: float
@export var vida_bar: ProgressBar


@export_group("Velocidade")
@export_range(0,1,0.05) var aumento_velocidade: float
@export_range(0,1,0.05) var decaimento_velocidade: float
@export_range(0,1,0.05) var buff_velocidade_pulo: float
@export var velocidade: float
@export var velocidade_max: float
var velocidade_atual: float


@export var pulo: float
@export var queda: float

@export_group("Visão câmera")
@export var pivot_camera: Node3D
@export var sensibilidade: float
@export var visao_min_angle: float
@export var visao_max_angle: float


@export_group("Mões")
@export var mao_esquerda: Node3D
@export var mao_direita: Node3D

var inventario: Array[Item]

var ultima_pos: Vector3


var dir: Vector3
var target_velocity: Vector3
var look_rot: Vector3
var parado := true

func _ready() -> void:
	ultima_pos = global_position
	velocidade_atual = velocidade
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta: float) -> void:
	_handle_movimento(delta)
	_handle_decaimento(delta)
	_handle_velocidade(delta)

func _handle_movimento(delta: float) -> void:
	pivot_camera.rotation_degrees.x = look_rot.x
	rotation_degrees.y = look_rot.y
	
	
	dir = Vector3.ZERO
	
	dir.x = Input.get_axis("player_right", "player_left")
	dir.z = Input.get_axis("player_down", "player_up")
	
	if dir != Vector3.ZERO:
		dir = dir.normalized()
	
	var up_vector = global_transform.basis.y
	
	dir = dir.rotated(up_vector, rotation.y)
	
	target_velocity.x = dir.x * velocidade_atual 
	target_velocity.z = dir.z * velocidade_atual
	
	if not is_on_floor():
		target_velocity.y = target_velocity.y - (queda * delta)
	
	velocity = target_velocity
	move_and_slide()

func _handle_decaimento(delta: float) -> void:
	vida -= decaimento_vida * delta
	atualizar_vida_display()

func _handle_velocidade(delta: float) -> void:
	parado = global_position.distance_to(ultima_pos) <= 0.01
	
	if parado:
		velocidade_atual = lerpf(velocidade_atual, velocidade, delta * decaimento_velocidade)
	else:
		var mult = global_position.distance_to(ultima_pos)
		velocidade_atual = lerpf(velocidade_atual, velocidade_max, delta * aumento_velocidade * mult)
	
	ultima_pos = global_position
	# print(velocidade_atual)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("player_jump") and is_on_floor():
		target_velocity.y = pulo
		velocidade_atual = lerpf(velocidade_atual, velocidade_max, aumento_velocidade * buff_velocidade_pulo)
		
	if event is InputEventMouseMotion:
		look_rot.y -= event.relative.x * sensibilidade
		look_rot.x -= -event.relative.y * sensibilidade
		look_rot.x = clamp(look_rot.x, visao_min_angle, visao_max_angle)



func atualizar_vida_display():
	vida_bar.min_value = 0
	vida_bar.max_value = vida_max
	vida_bar.value = vida


func adicionar_ao_inventario(item: Item) -> bool:
	if len(inventario) >= 3:
		return false
	
	inventario.append(item)
	print("inventario: " + str(inventario))
	return true
