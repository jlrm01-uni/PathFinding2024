extends Node

var MAX_SPEED = 800
var MASS = 10
var SLOW_RADIUS = 100
var MINIMUM_SLOW_PERCENTAGE = 0.0

func arrive_to(velocity: Vector2,
			   global_position: Vector2, 
			   target_position: Vector2, 
			   final_position: Vector2, 
			   max_speed = MAX_SPEED, 
			   slow_radius = SLOW_RADIUS, 
			   mass = MASS):
	var distance_to_target = global_position.distance_to(final_position)
	var slow_percentage
	var desired_velocity
	
	if distance_to_target < SLOW_RADIUS:
		slow_percentage = distance_to_target / SLOW_RADIUS
	else:
		slow_percentage = 1
		
	desired_velocity = (target_position - 
				 global_position).normalized() * (max_speed * slow_percentage)
				
	var steering = (desired_velocity - velocity) / mass
	var velocity_with_steering = velocity + steering
	
	return velocity_with_steering
