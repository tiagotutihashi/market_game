extends Node3D

class_name Register

@onready var _marker: Marker3D = $Marker3D
@onready var customer_spawner: CustomerSpawner
@onready var player: Manager

var customer_line: Array[Customer] = []

func _ready():
	var list_spawners: Array = get_tree().get_nodes_in_group("customer_spawner")
	if list_spawners.size() > 0:
		customer_spawner = list_spawners[0]
	
	var list_players: Array = get_tree().get_nodes_in_group("player")
	if list_players.size() > 0:
		player = list_players[0]

func get_marker():
	return _marker

func add_customer_in_line(customer: Customer):
	customer_line.append(customer)

func _on_area_3d_body_entered(body):
	if body.is_in_group("player"):
		if customer_line.size() > 0:
			var total: float = 0
			var items = customer_line[0].get_cart()
			for _i in items:
				total += _i.get_item_value()
			player.add_money(total)
			customer_line[0].go_back_spawner()
			customer_line.pop_front()
