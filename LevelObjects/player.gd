extends Area2D

@onready var Player: Area2D = $"."
@onready var PlayerSprite: Node2D = $PlayerSprite
@onready var PlayerTrail: Line2D = $PlayerSprite/PlayerTrail
@onready var PlayerCollision: CollisionShape2D = $PlayerCollision

var WaypointsArray: Array
var isPlayerMoving: bool = false # 检测玩家是否在运动，在动则不接收按钮（禁用）
# 每次收到点击信号，检查点击的全局坐标是否是水平/垂直，再移动玩家
var currentDeltaX: float
var currentDeltaY: float
const distancePerGrid: int = 160 # 游戏中正常路点距离为160px
# 角色的全局Tween变量
var tweenPlayerMoving: Tween = null
var tweenPlayerUnmovable: Tween = null
var tweenPlayerVanish: Tween = null

signal SignalRestart
signal SignalNextLevel

func _ready() -> void:
	isPlayerMoving = false # 开始玩家保持静止
	DisableCollision() # 玩家有碰撞
	add_to_group("GroupPlayer")
	# 开始遍历所有路点，连接点击信号
	WaypointsArray = get_tree().get_nodes_in_group("GroupWaypoints")
	for waypoint in WaypointsArray:
		waypoint.SignalWaypointClicked.connect(_on_waypoint_clicked)
	# 动画初始化
	tweenPlayerMoving = null
	tweenPlayerUnmovable = null
	tweenPlayerVanish = null

func _on_waypoint_clicked(targetPosition) -> void:
	# 玩家移动
	if isPlayerMoving == true:
		return
	# 判断是否点击水平/垂直方向
	currentDeltaX = abs(global_position.x - targetPosition.x)
	currentDeltaY = abs(global_position.y - targetPosition.y)
	
	if (currentDeltaX > 0.1 and currentDeltaY <= 0.1) or (currentDeltaY > 0.1 and currentDeltaX <= 0.1): # 确保明显移动，且一定水平竖直
		isPlayerMoving = true
		# 根据距离计算移动速度
		var playerMovingDistance: float = global_position.distance_to(targetPosition)
		var playerMovingDuration: float = (playerMovingDistance / distancePerGrid) * 0.3
		tweenPlayerMoving = create_tween().set_ease(Tween.EASE_IN_OUT)
		if playerMovingDuration > 0.3: # 长距离移动的缓动曲线不同
			tweenPlayerMoving.tween_property(Player, "global_position", targetPosition, playerMovingDuration).set_trans(Tween.TRANS_CUBIC)
		else:
			tweenPlayerMoving.tween_property(Player, "global_position", targetPosition, playerMovingDuration).set_trans(Tween.TRANS_CIRC)
		await tweenPlayerMoving.finished
		isPlayerMoving = false
	else: # 无法到达的路点，则摇头动画
		isPlayerMoving = true
		tweenPlayerUnmovable = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
		tweenPlayerUnmovable.tween_property(Player, "scale", Vector2(0.6, 0.6), 0.1)
		tweenPlayerUnmovable.tween_property(Player, "scale", Vector2(1.0, 1.0), 0.1)
		await tweenPlayerUnmovable.finished
		isPlayerMoving = false
# 玩家的道路判定
func _on_area_exited(area: Area2D) -> void:
	if area.is_in_group("GroupPlatforms"):
		print("离开的平台：", area.name) 
		var overlappingPlatformsArray = get_overlapping_areas()
		if overlappingPlatformsArray.is_empty():
			PlayerFailed()
			print("出界")

# 玩家的障碍判定
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("GroupObstacles"):
		PlayerFailed()
		print("撞墙")
	if area.is_in_group("GroupGoal"):
		PlayerCompleted()
		print("玩家到达终点了")

# 失败后玩家缩小消失，发重开信号
func PlayerFailed() -> void:
	DisableCollision()
	emit_signal("SignalRestart")
	if tweenPlayerMoving != null:
		tweenPlayerMoving.pause()
		tweenPlayerMoving.kill()
	tweenPlayerVanish = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tweenPlayerVanish.tween_property(PlayerSprite, "scale", Vector2(0.0, 0.0), 0.2)
	PlayerTrail.TrailFadeOut()

# 过关发信号，让所有的路点被禁用，菜单按钮禁用
func PlayerCompleted() -> void:
	emit_signal("SignalNextLevel")
	if tweenPlayerMoving != null:
		tweenPlayerMoving.pause()
		tweenPlayerMoving.kill()
	PlayerTrail.TrailFadeOut()

func DisableCollision() -> void:
	PlayerCollision.set_deferred("disabled", true)

func EnableCollision() -> void:
	PlayerCollision.set_deferred("disabled", false)
	
