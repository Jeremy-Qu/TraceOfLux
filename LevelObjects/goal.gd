extends Area2D

@onready var Goal: Area2D = $"."
@onready var GoalShape: Node2D = $GoalShape
@onready var GoalCollision: CollisionPolygon2D = $GoalCollision
@onready var GoalButton: Button = $GoalButton

signal SignalWaypointClicked(targetPosition: Vector2)

# 开始后自动加入分组
func _ready() -> void:
	add_to_group("GroupWaypoints")
	add_to_group("GroupPlatforms")
	add_to_group("GroupGoal")
	# 开始时不可以接收点击
	DisableWaypoint()


# 点击按钮后发信号给玩家
func _on_goal_button_pressed() -> void:
	emit_signal("SignalWaypointClicked", global_position)
	# 交互动画
	var tweenGoalPop: Tween = create_tween().set_ease(Tween.EASE_IN_OUT)
	tweenGoalPop.tween_property(Goal, "scale", Vector2(1.2, 1.2), 0.1).set_trans(Tween.TRANS_SPRING)
	tweenGoalPop.tween_property(Goal, "scale", Vector2(1.0, 1.0), 0.2).set_trans(Tween.TRANS_BACK)
	#print(global_position)

func DisableWaypoint() -> void:
	GoalButton.disabled = true

func EnableWaypoint() -> void:
	GoalButton.disabled = false
