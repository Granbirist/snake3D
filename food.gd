extends CharacterBody3D
 
var planetCenter = Vector3.ZERO;

signal eaten;
 
func get_input(delta):
	velocity = Vector3()
	var planetUp = getPlanetUP()
	velocity = (transform.basis.x*velocity.x)+(transform.basis.y*velocity.y)+(transform.basis.z*velocity.z)
	up_direction = planetUp
	global_transform = align_with_y(global_transform, planetUp)

func getPlanetUP() -> Vector3:
	var up = -(planetCenter-global_transform.origin).normalized() 
	return up 

func align_with_y(xform, new_y) -> Transform3D:
	xform.basis.y = new_y
	xform.basis.x = -xform.basis.z.cross(new_y)
	xform.basis = xform.basis.orthonormalized()
	return xform

func _physics_process(delta):
	get_input(delta)
	velocity += position.direction_to(Vector3.ZERO)
	move_and_slide()

func eat_up():
	emit_signal("eaten")
	queue_free()
	
