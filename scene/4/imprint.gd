extends MarginContainer


#region var
@onready var bg = $BG
@onready var trigon = $Trigon
@onready var knot = $Knot

var proprietor = null
var cliche = null
var vertexs = null
var origin = null
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	proprietor = input_.proprietor
	cliche = input_.cliche
	vertexs = input_.vertexs
	vertexs = input_.vertexs
	
	init_basic_setting()


func init_basic_setting() -> void:
	trigon.set_polygon(vertexs)
	align_trigon()
	init_knot()
	init_bg()


func init_knot() -> void:
	var input = {}
	input.proprietor = self
	input.grid = null
	
	knot.set_attributes(input)
	knot.position = trigon.position + vertexs[0]
	knot.set_rarity("ancient")


func align_trigon() -> void:
	custom_minimum_size = Vector2(Global.vec.size.cliche)
	var center = Vector2()
	
	for vertex in vertexs:
		center += vertex / vertexs.size()
	
	trigon.position = Global.vec.size.cliche / 2 - center
	#match origin:
		#"original":
			#custom_minimum_size = Vector2(Global.vec.size.cliche)
			#var center = Vector2()
			#
			#for vertex in vertexs:
				#center += vertex / vertexs.size()
			#
			#trigon.position = Global.vec.size.cliche / 2 - center
		#"replica":
			#custom_minimum_size = cliche.dimensions * Global.num.cliche.a


func init_bg() -> void:
	var style = StyleBoxFlat.new()
	style.bg_color = Color.SLATE_GRAY
	bg.set("theme_override_styles/panel", style)


func create_replica() -> MarginContainer:
	var input = {}
	input.proprietor = proprietor
	input.cliche = cliche
	input.origin = "replica"
	input.vertexs = vertexs
	
	var imprint = Global.scene.imprint.instantiate()
	add_child(imprint)
	imprint.set_attributes(input)
	remove_child(imprint)
	return imprint
#endregion
