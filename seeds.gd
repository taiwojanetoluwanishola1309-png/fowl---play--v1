extends Area2D
var points = 50


func _ready() -> void:
	$Sprite2D.frame = randi()%3
	var nest = get_tree().current_scene.get_node("Nest")
	var distance = global_position.distance_to(nest.global_position)
	if distance < 200:
		points=25
	elif distance> 400:
		points =100
	

func _on_body_entered(body: Node2D) ->void:
	if body.name != "player":
		return
	GameState.eaten += 1
	GameState.outrage += 1
	GameState.score += points
	get_tree().get_first_node_in_group("health_bar").change_health(10)
	 
	var toast = get_tree().get_first_node_in_group("toast")
	if GameState.eaten == GameState.goal:
		toast.show_message ("Enough! Fly back to your nest ! ")
	elif  GameState.eaten > GameState.goal:
		toast.show_message ("Bonus! +" + str (GameState.eaten - GameState.goal))
	elif GameState.eaten == GameState.goal - 3:
		toast.show_message(" Where are all my vegetables?!!")
		get_tree().get_first_node_in_group("farmer").start_hunt()
	
	show_points()
	queue_free()
	
func show_points():
	var label = Label.new()
	label.text = "+" + str(points)
	label.position = global_position +Vector2(-10, -40)
	label.z_index = 10
	label.add_theme_font_size_override("font_size", 12 if points ==100 else 8)
	label.add_theme_color_override("font_color", Color(0.55, 0.85, 1.0))
	label.add_theme_color_override("font_outline_color", Color.BLACK)
	label.add_theme_constant_override("outline_size", 3)
	get_tree().current_scene.add_child(label)
	var tween = label.create_tween()
	tween.tween_property(label, "position:y", label.position.y -16, 0.8)
	tween.parallel().tween_property(label, "modulate:a", 0.0, 0.8)
	tween.tween_callback(label.queue_free)

	
