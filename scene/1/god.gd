extends MarginContainer


#region vars
@onready var pizza = $HBox/Pizza
@onready var cheesemaker = $HBox/Cheesemaker

var pantheon = null
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	pantheon = input_.pantheon
	
	init_basic_setting()


func init_basic_setting() -> void:
	var input = {}
	input.god = self
	pizza.set_attributes(input)
	cheesemaker.set_attributes(input)
	
	for _i in 4:
		cheesemaker.add_cliche()
		#var windrose = Global.arr.windrose.pick_random()
		#pizza.make_best_cheese()
		pizza.make_cheese("nnw")
	
#endregion
