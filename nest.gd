extends Area2D


var calm_timer = 0.0

func _on_body_entered(body: Node2D) -> void:
	if body.name !="player":
		return
	GameState.bird_home = true
	if GameState.eaten >= GameState.goal:
		get_tree().get_first_node_in_group ("health_bar").game_over("You made it home!")
		

func _on_body_exited(body: Node2D) -> void:
	if body.name == "player":
		GameState.bird_home = false
		
func _process(delta):
	if GameState.bird_home and GameState.outrage > 0:
		calm_timer += delta
		if calm_timer >= 2.0:
			calm_timer = 0.0
			GameState.outrage -= 1
	
