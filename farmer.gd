extends CharacterBody2D

var speed = 40
var points = []
var target = 0
var chase_speed = 55
var see_distance = 90
@onready var bird= get_parent().get_node("player")


func _ready():
	for flag in get_parent().get_node("Waypoints").get_children():
		points.append(flag.global_position)
		
func _physics_process(_delta):
	var distance = global_position.distance_to(bird.global_position)
	if distance < see_distance: 
		velocity = global_position.direction_to(bird.global_position) * chase_speed
	else:
		var goal= points[target]
		velocity = global_position.direction_to(goal)*speed
		if global_position.distance_to(goal)< 5:
			target = (target+1)  % points.size()
	move_and_slide()
			


func _on_catch_area_body_entered(body: Node2D) -> void:
	if body.name != "player":
		return
	GameState.warnings +=1
	if GameState.warnings >= GameState.max_warnings:
		get_tree().get_first_node_in_group("health_bar").game_over("Banned. Rules are rules.")
		return
	if GameState.warnings ==1 :
		GameState.message ="First warning! Stealing is WRONG."
	elif GameState.warnings == 2:
		GameState.message = "Final warning! I'm being very GENEROUS."
	get_tree().reload_current_scene.call_deferred()
		
	
