extends Node2D

var current_ship: CharacterBody2D = null
var mouse_is_over_ship = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func connect_ship_signals(instance):
	instance.connect("ship_clicked_on", Callable(self, "on_ship_clicked"))
	
func _input(event):
	if event is InputEventMouseButton:
		print("clicked on screen!")
		setup_target_position(event.global_position)
		
func setup_target_position(position: Vector2):
	if not current_ship:
		return
		
	if not mouse_is_over_ship:
		current_ship.target_position = position
		current_ship.agent.set_target_position(position)
		
func on_ship_clicked(instance):
	current_ship = instance
	current_ship.clicked()
	print(current_ship)
	
func mouse_over(instance):
	mouse_is_over_ship = instance
	
func mouse_exit(instance):
	mouse_is_over_ship = null
		
