extends Label

var score = 0

func _on_food_eaten():
	score += 1
	text = "Score: %s" % score
	
	
func _on_bomb_eaten():
	score -= 1
	text = "Score: %s" % score
	get_parent().get_parent()._pop_body()
	
