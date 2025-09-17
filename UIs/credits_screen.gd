extends Control

@onready var Back: Node2D = $Back
@onready var BackShape: Polygon2D = $Back/ButtonShape
@onready var ButtonBack: Button = $Back/ButtonBack

@onready var AnimCreditsUI: AnimationPlayer = $AnimCreditsUI

func _ready() -> void:
	# 开始时不可以接收点击，场景动画都结束才能点击
	ButtonBack.disabled = true
	AnimCreditsUI.play("AnimCreditsFadeIn")
	await AnimCreditsUI.animation_finished
	ButtonBack.disabled = false
	

func _on_button_back_pressed() -> void:
	# 交互动画
	var tweenBackPop: Tween = create_tween().set_ease(Tween.EASE_IN_OUT)
	tweenBackPop.tween_property(BackShape, "scale", Vector2(1.1, 1.1), 0.1).set_trans(Tween.TRANS_SPRING)
	tweenBackPop.tween_property(BackShape, "scale", Vector2(1.0, 1.0), 0.2).set_trans(Tween.TRANS_BACK)
	await tweenBackPop.finished
	AnimCreditsUI.play("AnimCreditsFadeOut")
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file("res://UIs/MainMenu.tscn")
