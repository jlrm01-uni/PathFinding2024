extends CharacterBody2D

@export var ship_name = "Ship " + str(self.get_instance_id())

signal ship_clicked_on

@onready var agent = $NavigationAgent2D
@onready var animation_player = $AnimationPlayer

var speed = 200
var target_position = null

@onready var sprite = $Sprite2D
@onready var slow_radius = 200

@onready var target_path = NodePath()
@onready var target = get_node(target_path)

@export var follow_offset = 200.0

# Called when the node enters the scene tree for the first time.
func _ready():
	await owner.ready
	agent.max_speed = speed
	get_tree().call_group("Level", "connect_ship_signals", self)
	
	if target:
		target_position = target.global_position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_Ship_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			emit_signal("ship_clicked_on")
			
func _physics_process(delta):
	if target != self and target != null:
		handle_follow_leader(delta)
		return	
	
	if agent.is_navigation_finished():
		target_position = null
		return
		
	if not target_position:
		return
		
	var next_location = agent.get_next_path_position()
	var agent_position = global_transform.origin	
	var direction = agent_position.direction_to(next_location)

	var new_velocity = Utils.arrive_to(velocity, 
									   agent_position,
									   next_location, 
									   target_position,
									   speed, slow_radius)
									
	agent.set_velocity(new_velocity)
	
func handle_follow_leader(delta):
	if not target_position:
		return
		
	if agent.is_navigation_finished():
		return
		
	var next_location = agent.get_next_path_position()
	var agent_position = global_transform.origin
	
	if agent_position.distance_to(target_position) < follow_offset:
		agent.set_velocity(Vector2.ZERO)
		return
		
	var direction = agent_position.direction_to(next_location)								
	var new_velocity = Utils.arrive_to(velocity, 
									   agent_position,
									   next_location, 
									   target_position,
									   speed, slow_radius)
	agent.set_velocity(new_velocity)
