extends Resource
class_name Enemy

var Position : int = randi_range(0, 900)
var Scale : float = randf_range(0, 1.3)
var Name : String = "[null]"
var Stat := Stats.new()
var Check := ""
var ACTs : PackedStringArray = ["Check"]
