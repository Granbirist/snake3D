extends CharacterBody3D
 
@export var speed = 4.0;
@export var rotation_speed = 1.3;
var rotation_dir = 0;
 
var planetCenter = Vector3.ZERO;
 
func get_input(delta):
	velocity = Vector3()
	rotation_dir = 0
	if Input.is_action_pressed("move_right"):
		rotation_dir -= 1
	if Input.is_action_pressed("move_left"):
		rotation_dir += 1
	
	velocity.x += 1
	rotate_object_local(Vector3(1, 0, 0), rotation_dir*rotation_speed)
	var planetUp = getPlanetUP()
	velocity = (transform.basis.x*velocity.x)+(transform.basis.y*velocity.y)+(transform.basis.z*velocity.z)
	up_direction = planetUp
	global_transform = align_with_y(global_transform, planetUp)
	velocity = velocity.normalized() * speed

func _physics_process(delta):
	get_input(delta)
	velocity += position.direction_to(Vector3.ZERO)
	move_and_slide()
	for index in range(get_slide_collision_count()):
		var collision = get_slide_collision(index)
		if collision.get_collider().is_in_group("food"):
			var food = collision.get_collider()
			food.eat_up()
		if collision.get_collider().is_in_group("bomb"):
			var bomb = collision.get_collider()
			bomb.bomb_down()
		if collision.get_collider().is_in_group("tail"):
			var tail = collision.get_collider()
			tail.tail_eat()

func getPlanetUP() -> Vector3:
	var up = -(planetCenter-global_transform.origin).normalized() 
	return up 

func align_with_y(xform, new_y) -> Transform3D:
	xform.basis.y = new_y
	xform.basis.x = -xform.basis.z.cross(new_y)
	xform.basis = xform.basis.orthonormalized()
	return xform
