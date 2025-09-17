extends Area2D

@onready var AnimIcyPath: AnimationPlayer = $AnimIcyPath
@onready var IcyPathShape: Node2D = $IcyPathShape
@onready var IcyPathCollision: CollisionPolygon2D = $IcyPathCollision

var isPassed: bool = false

# 开始后自动加入分组
func _ready() -> void:
	add_to_group("GroupPlatforms")
	isPassed = false
	IcyPathCollision.disabled = false

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("GroupPlayer"):
		#AnimIcyPath.play("Warning")
		isPassed = true

func _on_area_exited(area: Area2D) -> void:
	if area.is_in_group("GroupPlayer"):
		if isPassed == true:
			IcyPathCollision.set_deferred("disabled", true)
			AnimIcyPath.play("Collapse")
