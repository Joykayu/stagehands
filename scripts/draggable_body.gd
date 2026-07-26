extends Node2D


@onready var mouse_pin: PinJoint2D = $MousePin
@onready var fake_body: StaticBody2D = $MousePin/FakeBody
@onready var rigid_body_2d: RigidBody2D = $RigidBody2D


var is_dragging = false
var is_rotating = false

var omega := 5.0

signal body_dragged(body)
signal body_dropped(body)

func _ready() -> void:
	# Set the node_a to a static body without a collision, we only need it for the pin effect.
	mouse_pin.node_a = mouse_pin.get_path_to(fake_body)
	# Enable input pickable on the rigid body to be able to detect mouse clicks
	rigid_body_2d.input_pickable = true
	# Connect the input_event signal to its function
	rigid_body_2d.input_event.connect(_on_input_event)


func _physics_process(delta: float) -> void:
	mouse_pin.global_position = get_global_mouse_position()
	if is_rotating:
		rigid_body_2d.rotation += deg_to_rad(delta*omega)


func _unhandled_input(event: InputEvent) -> void:
	# If we are dragging and the user releases the mouse button then
	if is_dragging and event is InputEventMouseButton and event.button_index == 1 and !event.is_pressed():
		disconnect_mouse()
	if is_rotating and event is InputEventMouseButton and event.button_index == 2 and !event.is_pressed():
		is_rotating = false

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	# If we aren't dragging and a mouse button press happens then
	if not is_dragging and event is InputEventMouseButton and event.button_index == 1 and event.is_pressed():
		connect_mouse()
	if event is InputEventMouseButton and event.button_index == 2 and event.is_pressed():
		is_rotating = true


func connect_mouse():
	# Set the node_b to the rigid body that triggered this input event
	mouse_pin.node_b = mouse_pin.get_path_to(rigid_body_2d)
	is_dragging = true
	body_dragged.emit(self)
	# Up the angular damp to avoid rotating like crazy when moving the mouse
	rigid_body_2d.angular_damp = 5
	#rigid_body_2d.lock_rotation = true

func disconnect_mouse():
	# Clear the node_b path
	mouse_pin.node_b = NodePath()
	is_dragging = false
	body_dropped.emit(self)
	# Reset the angular damp to 0
	rigid_body_2d.angular_damp = 15
	#rigid_body_2d.lock_rotation = false
