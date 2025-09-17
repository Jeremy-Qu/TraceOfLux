extends Node

var totalLevelNumber: int = 8 # 第一个版本只有15关

var defaultLevelNumber: int = 1
var defaultLevelBaseDir: String = "res://Levels"

# 转换下一关的文件地址，且60关后会循环
func ParseNextLevelScene() -> String:
	var levelPath = get_tree().current_scene.scene_file_path
	var levelBaseDir = levelPath.get_base_dir()
	var levelDir = levelPath.get_file().get_basename().replace("Lv", "")
	var currentLevelNumber = int(levelDir)
	var nextLevelNumber = currentLevelNumber + 1
	if nextLevelNumber > totalLevelNumber: 
		nextLevelNumber = 1
	return "%s/Lv%02d.tscn" % [levelBaseDir, nextLevelNumber]

# 保存当前场景的地址，并写入文件。
func SaveProgress():
	var configSave = ConfigFile.new()
	configSave.set_value("Progress", "nextLevelScene", ParseNextLevelScene())
	configSave.save("user://GameProgress.cfg")
	print("已保存进度")

# 读取场景地址
func LoadProgress():
	var configLoad = ConfigFile.new()
	var loadResult = configLoad.load("user://GameProgress.cfg")
	if loadResult == OK:
		var scenePath = configLoad.get_value("Progress", "nextLevelScene", "")
		if scenePath != "" and ResourceLoader.exists(scenePath):
			print("成功读取进度")
			return scenePath
			
	else:
		print("未检测到存档，重置游戏")
		return "%s/Lv%02d.tscn" % [defaultLevelBaseDir, defaultLevelNumber]
