extends CharacterBody2D

var direction: Vector2 = Vector2 (1, 0)
var speed: int = 80
var alarm_ready = true

func _physics_process(_delta: float) -> void:
	direction = Input. get_vector("left", "right","up", "down" )
	velocity = direction * speed 
	move_and_slide()
	for i in get_slide_collision_count():
		var hit = get_slide_collision(i).get_collider()
		if hit and hit.get_parent().name == "borders": 
			ring_alarm()
			
			
func ring_alarm():
	if not alarm_ready:
		return
	alarm_ready = false
	GameState.outrage +=2
	get_tree().get_first_node_in_group("toast").show_message("How dear you touch my fence!")
	get_tree().get_first_node_in_group("farmer").hear_alarm(global_position)
	await get_tree().create_timer(3.0).timeout
	alarm_ready = true
	
	
	
