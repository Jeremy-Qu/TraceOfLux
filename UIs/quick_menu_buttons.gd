extends Control

@onready var Back: Node2D = $Back
@onready var BackShape: Polygon2D = $Back/ButtonShape
@onready var ButtonBack: Button = $Back/ButtonBack
@onready var Restart: Node2D = $Restart
@onready var RestartShape: Polygon2D = $Restart/ButtonShape
@onready var ButtonRestart: Button = $Restart/ButtonRestart

signal SignalBack
signal SignalRestart

func _ready() -> void:
	# 开始时不可以接收点击
	DisableQuickMenuButtons()

func _on_button_back_pressed() -> void:
	emit_signal("SignalBack")
	# 交互动画
	var tweenBackPop: Tween = create_tween().set_ease(Tween.EASE_IN_OUT)
	tweenBackPop.tween_property(BackShape, "scale", Vector2(1.1, 1.1), 0.1).set_trans(Tween.TRANS_SPRING)
	tweenBackPop.tween_property(BackShape, "scale", Vector2(1.0, 1.0), 0.2).set_trans(Tween.TRANS_BACK)

func _on_button_restart_pressed() -> void:
	emit_signal("SignalRestart")
	# 交互动画
	var tweenRestartPop: Tween = create_tween().set_ease(Tween.EASE_IN_OUT)
	tweenRestartPop.tween_property(RestartShape, "scale", Vector2(1.1, 1.1), 0.1).set_trans(Tween.TRANS_SPRING)
	tweenRestartPop.tween_property(RestartShape, "scale", Vector2(1.0, 1.0), 0.2).set_trans(Tween.TRANS_BACK)

func DisableQuickMenuButtons() -> void:
	ButtonBack.disabled = true
	ButtonRestart.disabled = true

func EnableQuickMenuButtons() -> void:
	ButtonBack.disabled = false
	ButtonRestart.disabled = false
