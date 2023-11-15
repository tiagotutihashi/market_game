extends Node3D

class_name Stock

@onready var _item: ItemShelf = $item_holder/item

func _on_area_3d_body_entered(body):
	if body.is_in_group("player"):
		body.get_item_stock(_item)
