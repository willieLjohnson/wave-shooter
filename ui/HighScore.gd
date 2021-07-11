extends Label

func _ready() -> void:
	Global.load_game()
	if Global.high_score:
		text = str(Global.high_score)
	else:
		text = "0"
	
func _process(delta: float) -> void:
	if Global.score > Global.high_score:
		Global.high_score = Global.score
		
