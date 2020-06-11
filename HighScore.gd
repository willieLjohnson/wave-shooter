extends Label

func _ready() -> void:
	text = str(Global.high_score)
	
func _process(delta: float) -> void:
	if Global.score > Global.high_score:
		Global.high_score = Global.score
		
