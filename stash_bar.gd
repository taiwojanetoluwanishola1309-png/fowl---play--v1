extends ProgressBar

func _ready():
	max_value = GameState.goal
	var fill = StyleBoxFlat.new()
	fill.bg_color = Color(0.96, 0.77, 0.19)
	add_theme_stylebox_override("fill", fill)
	
func _process(_delta):
	value = GameState.eaten
	$StashText.text = str(GameState.eaten) + "/" + str(GameState.goal) 
