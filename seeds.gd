extends Area2D


func _ready() -> void:
	$Sprite2D.frame = randi()%3
	
	
func _on_body_entered(body: Node2D) ->void:
	if body.name != "player":
		return
	remove_from_group("veg")
	var left = get_tree().get_nodes_in_group("veg").size()
	get_tree().get_first_node_in_group("health_bar").change_health(10)
	if left ==0: 
		get_tree().current_scene.get_node("UI/WinLabel").visible = true
	else:
		get_tree().get_first_node_in_group("toast").show_message("Yum! "+ str(left) +" seeds left ")
	
	queue_free()
