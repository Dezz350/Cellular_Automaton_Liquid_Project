extends Control

func _ready():
	get_node("Container/Launch").connect("pressed",self,"start_game")
	
func _process(delta):
	Global.structure_height = int(get_node("Container/HeightContainer/Height_Amount").get_text())
	Global.structure_width = int(get_node("Container/WidthContainer/Width_Amount").get_text())

func start_game():
	if typeof(Global.structure_height) == TYPE_INT and typeof(Global.structure_width) == TYPE_INT and Global.structure_height > 0 and Global.structure_height <= 30 and Global.structure_width > 0 and Global.structure_width <= 40 :
		get_tree().change_scene("res://Grid.tscn")
		OS.set_window_size(Vector2(Global.structure_width*32,Global.structure_height*32))
	else:
		get_node("ValuesError").popup()

