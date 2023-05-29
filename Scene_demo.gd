extends StaticBody3D

@export var food_scene: PackedScene
@export var bomb_scene: PackedScene
@export var body_scene: PackedScene
@export var tail_scene: PackedScene
@export var menu_scene: PackedScene
var gap = 13
var body_and_tail_array = []
var position_history = []
var rotation_history = []

func _ready():
	var food = food_scene.instantiate(1)
	food.position = get_random_pos_in_sphere(5)
	add_child(food)
	food.connect("eaten", Callable($Control/Label, "_on_food_eaten"), 4)
	
	var bomb = bomb_scene.instantiate(1)
	bomb.position = get_random_pos_in_sphere(5)
	add_child(bomb)
	bomb.connect("bomben", Callable($Control/Label, "_on_bomb_eaten"), 4)
	
	var body = get_node("bodySnake")
	body_and_tail_array.push_front(body)
	body.visible = false
	
	var tail = tail_scene.instantiate(1)
	body_and_tail_array.push_back(tail)
	add_child(tail)

func _process(delta):
	if Input.is_action_pressed("escape"):
		get_tree().change_scene_to_file("res://menu.tscn")
		queue_free()
	
	position_history.push_front($headSnake.position)
	rotation_history.push_front($headSnake.rotation)
	if !has_node("food") and body_and_tail_array.size() != 32:
		var food = food_scene.instantiate(1)
		food.position = get_random_pos_in_sphere(5)
		add_child(food)
		_add_body()
		food.connect("eaten", Callable($Control/Label, "_on_food_eaten"), 4)

	var index = 0
	for body in body_and_tail_array:
		var ingap = clampi(index * gap, 0, position_history.size() - 1)
		var posit = position_history[ingap];
		var rotat = rotation_history[ingap];
		body.position += posit - body.position;
		body.rotation += rotat - body.rotation;
		index += 1

func get_random_pos_in_sphere (radius : float) -> Vector3:

	var x1 = randf_range(-1, 1)
	var x2 = randf_range(-1, 1)

	while x1*x1 + x2*x2 >= 1:
		x1 = randf_range(-1, 1)
		x2 = randf_range(-1, 1)

	var random_pos_on_unit_sphere = Vector3 (
	2 * x1 * sqrt (1 - x1*x1 - x2*x2),
	2 * x2 * sqrt (1 - x1*x1 - x2*x2),
	1 - 2 * (x1*x1 + x2*x2))

	return random_pos_on_unit_sphere * randf_range (0, radius)

func _add_body():
	var body = body_scene.instantiate(1)
	body_and_tail_array.insert(body_and_tail_array.size() - 1, body)
	add_child(body)
	
	
func _pop_body():
	if(body_and_tail_array.size() != 2):
		body_and_tail_array[body_and_tail_array.size() - 2].queue_free()
		body_and_tail_array.remove_at(body_and_tail_array.size() - 2)
	else:
		get_tree().change_scene_to_file("res://Game_over.tscn")
		queue_free()
		
func _win():
	if body_and_tail_array.size() == 32:
		get_tree().change_scene_to_file("res://Game_win.tscn")
		queue_free()

func _on_timer_timeout():
	var bomb = bomb_scene.instantiate(1)
	bomb.position = get_random_pos_in_sphere(5)
	add_child(bomb)
	bomb.connect("bomben", Callable($Control/Label, "_on_bomb_eaten"), 4)
