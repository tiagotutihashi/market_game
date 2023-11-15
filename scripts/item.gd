extends Node3D

class_name ItemShelf

@export var item_stats: ItemStats
@onready var mesh = get_node("mesh")

func get_stats():
	return item_stats

func get_value():
	return item_stats.item_value

func get_item_name():
	return item_stats.item_name

func active_item():
	mesh.visible = true

func disabled_item():
	mesh.visible = false
