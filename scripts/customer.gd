extends CharacterBody3D

class_name Customer

const speed: float = 5.0
const accel: float = 10.0

@export
var _path: Array[Node3D] = []
var _active: bool = false
var _cart: Array[Shelf] = []
@onready var _spawner: CustomerSpawner = get_parent().get_parent()

@onready var nav: NavigationAgent3D = $NavigationAgent3D

func _physics_process(delta):
	if _path.size() > 0:
		var direction = Vector3()
		var path_position = _path[0].get_marker().global_position
		
		nav.target_position = path_position
		
		direction = nav.get_next_path_position() - global_position
		direction = direction.normalized()

		if path_position.distance_to(global_position) < 0.8:
			if _path.size() > 1:
				if _path[0].is_in_group("shelf"):
					if _path[0].has_item():
						_path[0].get_item()
						_cart.append(_path[0])
				_path.pop_front()
			else:
				_spawner.get_register().add_customer_in_line(self)
				_path.pop_front()
			
		else:
			velocity = velocity.lerp(direction * speed , accel * delta)
			move_and_slide()

func get_active():
	return _active

func toggle_active():
	_active = !_active

func active_customer():
	_active = true

func disable_customer():
	_active = false

func set_path(new_path):
	_path = new_path

func get_cart():
	return _cart

func empty_cart():
	_cart.clear()

func go_back_spawner():
	_spawner.create_cart_list(self)
	_path.push_front(_spawner)
