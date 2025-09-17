extends Node2D

func _ready() -> void:
	print(get_tree().get_nodes_in_group("GroupWaypoints"))
	print(get_tree().get_nodes_in_group("GroupPlatforms"))
	print(get_tree().get_nodes_in_group("GroupPlayer"))
	print(get_tree().get_nodes_in_group("GroupGoal"))
