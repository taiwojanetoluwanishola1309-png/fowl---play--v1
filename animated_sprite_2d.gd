extends AnimatedSprite2D

func _process(_delta):
	var anger = clamp(float(GameState.outrage) / GameState.goal, 0.0, 1.0)
	modulate = Color (1, 1-anger *0.6, 1- anger *0.6)
