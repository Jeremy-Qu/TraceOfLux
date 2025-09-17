extends Area2D

# 开始后自动加入分组
func _ready() -> void:
	add_to_group("GroupPlatforms")
