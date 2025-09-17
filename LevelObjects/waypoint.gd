extends Area2D

@onready var Waypoint: Area2D = $"."
@onready var PointShape: Polygon2D = $PointShape
@onready var PointCollision: CollisionPolygon2D = $PointCollision
@onready var PointButton: Button = $PointButton

signal SignalWaypointClicked(targetPosition: Vector2)

# 开始后自动加入分组
func _ready() -> void:
	add_to_group("GroupWaypoints")
	add_to_group("GroupPlatforms")
	# 开始时不可以接收点击
	DisableWaypoint()

# 点击按钮后发信号给玩家
func _on_point_button_pressed() -> void:
	emit_signal("SignalWaypointClicked", global_position)
	# 交互动画
	var tweenPointPop: Tween = create_tween().set_ease(Tween.EASE_IN_OUT)
	tweenPointPop.tween_property(Waypoint, "scale", Vector2(1.2, 1.2), 0.1).set_trans(Tween.TRANS_SPRING)
	tweenPointPop.tween_property(Waypoint, "scale", Vector2(1.0, 1.0), 0.2).set_trans(Tween.TRANS_BACK)
	#print(global_position)

func DisableWaypoint() -> void:
	PointButton.disabled = true

func EnableWaypoint() -> void:
	PointButton.disabled = false
