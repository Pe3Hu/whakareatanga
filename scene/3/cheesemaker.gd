extends MarginContainer


#region var
@onready var bg = $BG
@onready var cliches = $Cliches

var god = null
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	god = input_.god
	
	init_basic_setting()


func init_basic_setting() -> void:
	custom_minimum_size = Vector2.ONE * Global.arr.dimensions.back() * Global.num.cliche.a
	init_cliche()


func init_cliche() -> void:
	var input = {}
	input.cheesemaker = self
	input.dimensions = Vector2(2, 1)
	
	var cliche = Global.scene.cliche.instantiate()
	cliches.add_child(cliche)
	cliche.set_attributes(input)
