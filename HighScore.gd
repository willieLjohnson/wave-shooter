extends Label

func _ready() -> void:
	Global.load_game()
	text = str(Global.high_score)
	
func _process(delta: float) -> void:

		
	if Global.score > Global.high_score:
		Global.high_score = Global.score
		
