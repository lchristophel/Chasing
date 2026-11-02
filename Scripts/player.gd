extends CharacterBody3D

@export var speed: float = 5.0;
@export var mouse_sensivity: float = 0.003;
@export var jump_velocity: float = 4.5;
@export var gravity: float = 9.8;

# variable head contenant un noeud 3D
var head : Node3D;
# variable de limite de bascule de la tête
var pitch : float = 0.0;

func _ready() -> void:
	head = $Head; # attribution du noeud 3D Head à la variable head
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED);

func _unhandled_input(event) -> void:
	if event is InputEventMouseMotion:
		# rotation horizontale du corps
		rotate_y(-event.relative.x * mouse_sensivity);
		# rotation verticale de la tête
		pitch = clamp(pitch - event.relative.y * mouse_sensivity, deg_to_rad(-89), deg_to_rad(89));
		head.rotation.x = pitch;
	elif event is InputEventKey and event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE);
		
func _physics_process(delta: float) -> void:
	var direction = Vector3.ZERO;
	
	var forward = -transform.basis.z;
	var right = transform.basis.x;
	
	if Input.is_action_pressed("move_forward"):
		direction += forward;
	if Input.is_action_pressed("move_back"):
		direction -= forward;
	if Input.is_action_pressed("move_right"):
		direction += right;
	if Input.is_action_pressed("move_left"):
		direction -= right;
		
	direction = direction.normalized();
	
	# mouvements horizontaux
	velocity.x = direction.x * speed;
	velocity.z = direction.z * speed;
	
	# gravité et saut
	if not is_on_floor():
		velocity.y -= gravity * delta;
	elif Input.is_action_just_pressed("jump"):
		velocity.y = jump_velocity;
		
	move_and_slide();
