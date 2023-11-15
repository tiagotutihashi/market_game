extends Node3D

class_name Shelf

@export var active = false
@export var _item: ItemStats
@export var _level: int = 0
@export var _mod_value: float = 0.21
var _items: Array[ItemShelf] = []
var _current_active_items: int = 0
var player: Manager
@onready var _marker: Marker3D = $Marker3D

@onready var shelf_mesh: MeshInstance3D = $mesh
@onready var buy_mesh: MeshInstance3D = $buyMesh

func _ready():
	for _i in get_node("items").get_children():
		_items.append(_i)
		_current_active_items += 1
	_active_all_items()
	if _items.size() > 0:
		_item = _items[0].get_stats()
	
	var list_players: Array = get_tree().get_nodes_in_group("player")
	if list_players.size() > 0:
		player = list_players[0]
	
	if _level > 0:
		active = true
		shelf_mesh.visible = true
		buy_mesh.visible = false
	else:
		active = false
		shelf_mesh.visible = false
		buy_mesh.visible = true
		_disabled_all_item()

func get_level():
	return _level

func get_active():
	return active

func get_item_stats():
	return _item

func get_max_amount():
	return _items.size()

func get_item_value():
	if _level > 0:
		return ((_level - 1) * _mod_value) + _item.item_value
	return _item.item_value

func get_upgrade_cost():
	if _level > 0:
		return _level * _mod_value * _item.item_value * 10
	return _mod_value * _item.item_value * 10

func upgrade_shelf(control: ControlManager):
	var upgrade_cost = get_upgrade_cost()
	if(player.get_money() >= upgrade_cost):
		_level += 1
		player.add_money(-upgrade_cost)
		control.show_shelf_values()

func get_marker() -> Marker3D:
	return _marker

func get_item() -> ItemShelf:
	_current_active_items -= 1
	_items[_current_active_items - 1].disabled_item()
	return _items[0]

func _active_all_items():
	for _i in _items:
		_i.active_item()
	_current_active_items = _items.size()

func _disabled_all_item():
	for _i in _items:
		_i.disabled_item()
	_current_active_items = 0

func restock():
	_current_active_items = _items.size()
	_active_all_items()

func has_item() -> bool:
	return _current_active_items > 0

func _on_area_3d_body_entered(body):
	if body.is_in_group("player"):
		var player_item: ItemShelf = body.get_current_item()
		if player_item:
			if player_item.get_stats() == _item:
				restock()
				body.restock_item_shelf()

func _on_area_3d_input_event(_camera, event, _position, _normal, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed == true:
			Events.emit_signal("open_shelf_modal", self)
