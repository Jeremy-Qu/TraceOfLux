extends Control

func _ready() -> void:
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file("res://UIs/MainMenu.tscn")
