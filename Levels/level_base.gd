extends Node2D

# 在开始/失败/过关，所有的路点被禁用，菜单按钮禁用，玩家无反应
@onready var AnimLevelUI: AnimationPlayer = $AnimLevelUI
@onready var QuickMenuButtons: Control = $QuickMenuButtons

func _ready() -> void:
	# 给玩家和菜单连接信号
	for player in get_tree().get_nodes_in_group("GroupPlayer"):
		player.SignalRestart.connect(_on_restart)
		player.SignalNextLevel.connect(_on_next_level)
	QuickMenuButtons.SignalRestart.connect(_on_restart)
	QuickMenuButtons.SignalBack.connect(_on_back_to_menu)
	# 根节点淡入
	modulate.a = 0.0
	call_deferred("DisableInteracts")
	call_deferred("DisablePlayer")
	AnimLevelUI.play("AnimLevelFadeIn")
	await get_tree().create_timer(0.5).timeout
	call_deferred("EnableInteracts")
	call_deferred("EnablePlayer")


func _on_restart() -> void:
	DisablePlayer()
	call_deferred("DisableInteracts")
	AnimLevelUI.play("AnimLevelFadeOut")
	await get_tree().create_timer(0.5).timeout
	get_tree().reload_current_scene()
	#print("关卡收到重开信号")

func _on_next_level() -> void:
	call_deferred("DisableInteracts")
	GlobalLevelManager.SaveProgress()
	AnimLevelUI.play("AnimLevelFadeOut")
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file(GlobalLevelManager.ParseNextLevelScene())
	#print("关卡收到下一关信号")

func _on_back_to_menu() -> void:
	DisablePlayer()
	call_deferred("DisableInteracts")
	AnimLevelUI.play("AnimLevelFadeOut")
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file("res://UIs/MainMenu.tscn")
	print("关卡收到回到主界面信号")

# 禁用路点和菜单按钮
func DisableInteracts() -> void:
	if not is_inside_tree() or not get_tree():
		return
	get_tree().call_group("GroupWaypoints", "DisableWaypoint")
	QuickMenuButtons.DisableQuickMenuButtons()

# 启用路点和菜单按钮
func EnableInteracts() -> void:
	if not is_inside_tree() or not get_tree():
		return
	get_tree().call_group("GroupWaypoints", "EnableWaypoint")
	QuickMenuButtons.EnableQuickMenuButtons()

# 玩家无判定
func DisablePlayer() -> void:
	get_tree().call_group("GroupPlayer", "DisableCollision")

# 玩家有判定
func EnablePlayer() -> void:
	get_tree().call_group("GroupPlayer", "EnableCollision")


#func GroupTest() -> void:
	#print(get_tree().get_nodes_in_group("GroupWaypoints"))
	#print(get_tree().get_nodes_in_group("GroupPlatforms"))
	#print(get_tree().get_nodes_in_group("GroupPlayer"))
	#print(get_tree().get_nodes_in_group("GroupGoal"))
