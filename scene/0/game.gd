extends Node


@onready var sketch = $Sketch


func _ready() -> void:
	#datas.sort_custom(func(a, b): return a.value < b.value)
	#012 description
	#Global.rng.randomize()
	#var random = Global.rng.randi_range(0, 1)
	pass


func _input(event) -> void:
	if event is InputEventKey:
		match event.keycode:
			KEY_1:
				if event.is_pressed() && !event.is_echo():
					var god = sketch.cradle.pantheons.get_child(0).gods.get_child(0)
					god.cheesemaker.add_cliche()
			KEY_2:
				if event.is_pressed() && !event.is_echo():
					var god = sketch.cradle.pantheons.get_child(0).gods.get_child(0)
					god.pizza.make_cheese("nnw")
			KEY_3:
				if event.is_pressed() && !event.is_echo():
					var god = sketch.cradle.pantheons.get_child(0).gods.get_child(0)
					god.pizza.make_cheese("nne")
