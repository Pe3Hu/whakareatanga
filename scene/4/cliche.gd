extends MarginContainer


#region var
@onready var bg = $BG
@onready var trigon = $Trigon

var cheesemaker = null
var dimensions = null
var angles = []
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	cheesemaker = input_.cheesemaker
	dimensions = input_.dimensions
	
	init_basic_setting()


func init_basic_setting() -> void:
	custom_minimum_size = Vector2(Global.vec.size.cliche)
	set_vertexs()
	align_trigon()
	init_angles()
	init_bg()


func set_vertexs() -> void:
	var vertexs = []
	var vertex = Vector2()
	vertexs.append(Vector2(vertex))
	vertex = Vector2(dimensions.x, 0) * Global.num.cliche.a
	vertexs.append(Vector2(vertex))
	vertex = Vector2(0, dimensions.y) * Global.num.cliche.a
	vertexs.append(Vector2(vertex))
	
	trigon.set_polygon(vertexs)


func init_bg() -> void:
	var style = StyleBoxFlat.new()
	style.bg_color = Color.SLATE_GRAY
	bg.set("theme_override_styles/panel", style)


func align_trigon() -> void:
	var center = Vector2.ONE * Global.arr.dimensions.back() - dimensions
	center *= Global.num.cliche.a / 2
	trigon.position = center


func init_angles() -> void:
	var vertexs = trigon.get_polygon()
	var n = vertexs.size()
	
	for _i in n:
		var angle = {}
		angle.point = vertexs[_i]
		angle.cathets = [] 
		var index = (_i + 1) % n
		var cathet = vertexs[index] - angle.point
		angle.cathets.append(cathet)
		index = (_i + 2) % n
		cathet = vertexs[index] - angle.point
		angle.cathets.append(cathet)
		angles.append(angle)
	
	var reflections = [Vector2(1, 0), Vector2(0, 1)]
	var turns = [1, 2, 3]
	
	for angle in angles:
		#var angle = angles.front()
		cheesemaker.add_imprint(self, angle)
		
		for turn in turns:
			var _angle = get_turned_angle(angle, turn)
			cheesemaker.add_imprint(self, _angle)
		
		for reflection in reflections:
			var _angle = get_reflected_angle(angle, reflection)
			cheesemaker.add_imprint(self, _angle)
	


func get_reflected_angle(angle_: Dictionary, reflection_: Vector2) -> Dictionary:
	var angle = {}
	angle.point = Vector2(angle_.point)
	angle.cathets = []
	
	for _i in angle_.cathets.size():
		var cathet = Vector2(angle_.cathets[_i])
		cathet = cathet.reflect(reflection_)
		angle.cathets.append(cathet)
	
	return angle


func get_turned_angle(angle_: Dictionary, turn_: int) -> Dictionary:
	var angle = {}
	angle.point = Vector2(angle_.point)
	angle.cathets = []
	
	for _i in angle_.cathets.size():
		var cathet = Vector2(angle_.cathets[_i])
		cathet = cathet.rotated(PI / 2 * turn_)
		angle.cathets.append(cathet)
	
	return angle
#endregion
