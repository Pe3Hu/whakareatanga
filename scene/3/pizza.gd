extends MarginContainer


#region var
@onready var bg = $BG
@onready var slices = $Slices
@onready var nnw = $NNW

var god = null
var corners = []
var center = null
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	god = input_.god
	
	init_basic_setting()


func init_basic_setting() -> void:
	init_cornres()
	init_slices()
	
	custom_minimum_size = corners[1] - corners[3]
	custom_minimum_size += Global.vec.size.cliche * 2
	slices.position = custom_minimum_size / 2


func init_cornres() -> void:
	center = Vector2()
	var order = "odd"
	var n = 4
	var r = Global.num.pizza.r
	
	for _i in n:
		var corner = Global.dict.corner.vector[n][order][_i] * r
		corners.append(corner)


func init_slices() -> void:
	var n = corners.size()
	
	for _i in n:
		var input = {}
		input.pizza = self
		input.aspect = Global.arr.aspect[_i]
		input.vertexs = [center]
		
		for _j in 2:
			var index = (_i + _j + n - 1) % n
			var vertex = corners[index]
			input.vertexs.append(vertex)
	
		var slice = Global.scene.slice.instantiate()
		slices.add_child(slice)
		slice.set_attributes(input)
#endregion


#region bg
func init_bg() -> void:
	var style = StyleBoxFlat.new()
	style.bg_color = Color.SLATE_GRAY
	bg.set("theme_override_styles/panel", style)


func set_bg_color(color_: Color) -> void:
	var style = bg.get("theme_override_styles/panel")
	style.bg_color = color_
#endregion
