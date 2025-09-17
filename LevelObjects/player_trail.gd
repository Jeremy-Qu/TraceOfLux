extends Line2D

@onready var AnimTrail: AnimationPlayer = $AnimTrail

var trailPosition: Vector2

func _ready() -> void:
	var initTrailPosition = get_parent().global_position # 初始化，防止拖尾瞬移
	clear_points()
	add_point(initTrailPosition)
	modulate = get_parent().get_parent().modulate # 线条颜色跟随父节点的modulate（线头）


func _process(_delta: float) -> void:
	modulate = get_parent().get_parent().modulate
	trailPosition = get_parent().global_position # 时刻保持更新，故无法只更新一次
	add_point(trailPosition)
	while get_point_count() > 10:
		remove_point(0)

func TrailFadeOut() -> void:
	AnimTrail.play("TrailDisappear")
