extends Label

@onready var AnimHintText: AnimationPlayer = $AnimHintText

var canBeClosed: bool = false

func _ready() -> void:
	global_position = Vector2(0.0, 550.0)
	canBeClosed = false
	AnimHintText.play("AnimTextFadeIn")
	await AnimHintText.animation_finished
	canBeClosed = true
	
# 如果点击路点/按钮/任意处，播放消失动画
func _input(event: InputEvent) -> void:
	if canBeClosed == true:
		if event is InputEventMouseButton and event.pressed:
			canBeClosed = false
			AnimHintText.play("AnimTextFadeOut")
