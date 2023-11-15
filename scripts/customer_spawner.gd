extends Node3D

class_name CustomerSpawner

var customer = preload("res://scenes/customer.tscn")

@onready var shelfs: Array
@onready var _marker: Marker3D = $Marker3D
@onready var _customer_list: Node3D = $customer_list

var _customer_amount = 5
var rng = RandomNumberGenerator.new()

var register: Register = null

func _ready():
	var registers: Array = get_tree().get_nodes_in_group("register")
	if registers.size() > 0:
		register = registers[0]
	create_customers()

func create_customers():
	for _i in _customer_amount:
		await get_tree().create_timer(4).timeout
		var customer_node = customer.instantiate()
		_customer_list.add_child(customer_node)
		create_cart_list(customer_node)

func create_cart_list(customer_to_add):
	shelfs = get_tree().get_nodes_in_group("shelf")
	var active_shelfs = []
	for _i in shelfs:
		if _i.get_active():
			active_shelfs.append(_i)
	var new_path: Array[Node3D] = []
	var shelfs_rnd = active_shelfs.duplicate(true)
	shelfs_rnd.shuffle()
	var items_cart = rng.randi_range(1, shelfs_rnd.size() - 1)
	shelfs_rnd = shelfs_rnd.slice(0, items_cart)
	new_path.append_array(shelfs_rnd)
	new_path.append(register)
	customer_to_add.set_path(new_path)

func get_marker():
	return _marker

func get_register() -> Register:
	return register
