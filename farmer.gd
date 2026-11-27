extends CharacterBody2D

var speed = 40
var points = []
var target = 0
var chase_speed = 55
var see_distance = 90
@onready var bird= get_parent().get_node("player")
@onready var alert = $Alert
@onready var agent = $NavigationAgent2D
var chasing = false
var alarm_spot = Vector2.ZERO
var alarm_time = 0.0
var hunting = false



func _ready():
	add_to_group("farmer")
	for flag in get_parent().get_node("Waypoints").get_children():
		points.append(flag.global_position)
		
		
func _physics_process(delta):
	var anger = GameState.outrage
	var walk = speed +anger * 0.5
	var run = chase_speed +anger * 0.7
	var eyes = see_distance +anger *2
	var distance = global_position.distance_to(bird.global_position)
	if distance < eyes and not GameState.bird_home:
		if not chasing:
			chasing = true
			spotted()
		walk_to(bird.global_position, run)
	elif hunting and not GameState.bird_home:
			walk_to(bird.global_position, run)
	elif alarm_time > 0:
		chasing = false
		alarm_time -= delta
		walk_to(alarm_spot, run)
		if global_position.distance_to(alarm_spot) < 10:
			alarm_time = 0
			
	else:
		chasing = false
		var goal= points[target]
		walk_to (goal, walk)
		if global_position.distance_to(goal)< 5:
			target = (target+1)  % points.size()
	move_and_slide()
	if velocity.x < -5:
		$FarmerSprite.flip_h = true
	elif velocity.x > 5:
		$FarmerSprite.flip_h = false
		
func _on_catch_area_body_entered(body: Node2D) -> void:
	if body.name != "player":
		return
	if GameState.bird_home:
		return
	GameState.warnings +=1
	if GameState.warnings >= GameState.max_warnings:
		get_tree().get_first_node_in_group("health_bar").game_over("Banned. Rules are rules.")
		return
	if GameState.warnings ==1 :
		GameState.message ="First warning! Stealing is WRONG."
	elif GameState.warnings == 2:
		GameState.message = "Final warning! I'm being very GENEROUS."
	get_tree().paused = true
	get_tree().get_first_node_in_group("red_flash").flash()
	await get_tree().create_timer(1.0).timeout
	get_tree().paused = false
	get_tree().reload_current_scene()
		
		
func spotted():
	alert.visible = true
	var tween = create_tween()
	tween.tween_interval(0.8)
	tween.tween_callback(alert.hide)
	
func hear_alarm(spot):
	alarm_spot = spot
	alarm_time = 4.0 + global_position.distance_to(spot)/ chase_speed
	spotted()
	
func walk_to (spot, how_fast):
	if agent.target_position !=spot:
		agent.target_position = spot
	if agent.is_navigation_finished():
		velocity = Vector2.ZERO
		return
	var next_step = agent.get_next_path_position()
	velocity = global_position.direction_to(next_step) * how_fast
		
		
func start_hunt():
	hunting =true
	spotted()
	
func nearest_flag():
	var best = 0
	for i in points.size():
		if global_position.distance_to(points[i]) < global_position.distance_to(points[best]):
			best = i
