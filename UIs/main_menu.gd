extends Control

@onready var Start: Node2D = $Start
@onready var StartShape: Polygon2D = $Start/ButtonShape
@onready var ButtonStart: Button = $Start/ButtonStart
@onready var Quit: Node2D = $Quit
@onready var QuitShape: Polygon2D = $Quit/ButtonShape
@onready var ButtonQuit: Button = $Quit/ButtonQuit
@onready var Credits: Node2D = $Credits
@onready var CreditsShape: Polygon2D = $Credits/ButtonShape
@onready var ButtonCredits: Button = $Credits/ButtonCredits

@onready var AnimUI: AnimationPlayer = $AnimUI

func _ready() -> void:
	DisableMainMenuButtons()
	AnimUI.play("AnimUIFadeIn")
	await AnimUI.animation_finished
	EnableMainMenuButtons()


func _on_button_start_pressed() -> void:
	# 仅在非禁用的情况下才能动画与触发
	if ButtonStart.disabled == false:
		var tweenStartPop: Tween = create_tween().set_ease(Tween.EASE_IN_OUT)
		tweenStartPop.tween_property(StartShape, "scale", Vector2(1.1, 1.1), 0.1).set_trans(Tween.TRANS_SPRING)
		tweenStartPop.tween_property(StartShape, "scale", Vector2(1.0, 1.0), 0.2).set_trans(Tween.TRANS_BACK)
		await tweenStartPop.finished
		AnimUI.play("AnimUIFadeOut")
		await get_tree().create_timer(0.5).timeout
		get_tree().change_scene_to_file(GlobalLevelManager.LoadProgress())

func _on_button_quit_pressed() -> void:
	# 仅在非禁用的情况下才能动画与触发
	if ButtonStart.disabled == false:
		var tweenQuitPop: Tween = create_tween().set_ease(Tween.EASE_IN_OUT)
		tweenQuitPop.tween_property(QuitShape, "scale", Vector2(1.1, 1.1), 0.1).set_trans(Tween.TRANS_SPRING)
		tweenQuitPop.tween_property(QuitShape, "scale", Vector2(1.0, 1.0), 0.2).set_trans(Tween.TRANS_BACK)
		await tweenQuitPop.finished
		get_tree().quit()


func _on_button_credits_pressed() -> void:
	# 仅在非禁用的情况下才能动画与触发
	if ButtonStart.disabled == false:
		var tweenCreditsPop: Tween = create_tween().set_ease(Tween.EASE_IN_OUT)
		tweenCreditsPop.tween_property(CreditsShape, "scale", Vector2(1.1, 1.1), 0.1).set_trans(Tween.TRANS_SPRING)
		tweenCreditsPop.tween_property(CreditsShape, "scale", Vector2(1.0, 1.0), 0.2).set_trans(Tween.TRANS_BACK)
		await tweenCreditsPop.finished
		AnimUI.play("AnimUIFadeOut")
		await get_tree().create_timer(0.5).timeout
		get_tree().change_scene_to_file("res://UIs/CreditsScreen.tscn")
		
func DisableMainMenuButtons() -> void:
	ButtonStart.disabled = true
	ButtonQuit.disabled = true
	ButtonCredits.disabled = true

func EnableMainMenuButtons() -> void:
	ButtonStart.disabled = false
	ButtonQuit.disabled = false
	ButtonCredits.disabled = false
