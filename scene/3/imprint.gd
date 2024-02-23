extends MarginContainer


#region var
@onready var bg = $BG
@onready var trigon = $Trigon

var crust = null
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	crust = input_.crust
	
	init_basic_setting(input_)


func init_basic_setting(input_: Dictionary) -> void:
	custom_minimum_size = Vector2(Global.vec.size.cliche)
	trigon.set_polygon(input_.vertexs)
	align_trigon()
	init_bg()


func init_bg() -> void:
	var style = StyleBoxFlat.new()
	style.bg_color = Color.SLATE_GRAY
	bg.set("theme_override_styles/panel", style)


func align_trigon() -> void:
	var vertexs = trigon.get_polygon()
	var center = Vector2()
	
	for vertex in vertexs:
		center += vertex / vertexs.size()
	
	trigon.position = Global.vec.size.cliche / 2 - center
#endregion
