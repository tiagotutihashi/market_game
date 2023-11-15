extends CharacterBody3D

class_name Manager

const SPEED = 5.0

@export
var _money: float = 0
var _has_item: ItemShelf = null

@onready var control_manager = get_parent().get_node("control")

func _physics_process(_delta):
	var input_dir = Input.get_vector("down", "up", "right", "left")
	var direction = (transform.basis * Vector3(input_dir.y, 0, input_dir.x)).normalized()
	if direction:
		#velocity.x = (-direction.z - direction.x) * SPEED 
		#velocity.z = (-direction.z + direction.x) * SPEED
		velocity.x = (-direction.x) * SPEED 
		velocity.z = (-direction.z) * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	move_and_slide()

func get_current_item():
	return _has_item

func get_item_stock(got_item):
	_has_item = got_item

func restock_item_shelf():
	_has_item = null

func get_money() -> float:
	return _money

func add_money(amount) -> float:
	_money += amount
	var label = str(_money) + " coins"
	control_manager.set_text(label)
	return _money
