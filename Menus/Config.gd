extends Node2D

func _unhandled_key_input(event):
	if event.is_action("accept"):
		Globals.AcceptKey = OS.get_keycode_string(event.key_label)
	if event.is_action("cancel"):
		Globals.CancelKey = OS.get_keycode_string(event.key_label)
	if event.is_action("menu"):
		Globals.MenuKey = OS.get_keycode_string(event.key_label)

func _process(_delta):
	if Globals.AcceptKey == "":
		$Label.text = "Press [confirm]…"
	elif Globals.CancelKey == "":
		$Label.text = "Press [cancel]…"
		$A.text = "\"Accept\" key: " + Globals.AcceptKey
	elif Globals.MenuKey == "":
		$Label.text = "Press [menu]…"
		$A.text = "\"Accept\" key: " + Globals.AcceptKey
		$C.text = "\"Cancel\" key: " + Globals.CancelKey
	else:
		$Label.text = "Config'd :) \n Going back to main menu…"
		$A.text = "\"Accept\" key: " + Globals.AcceptKey
		$C.text = "\"Cancel\" key: " + Globals.CancelKey
		$M.text = "\"Menu\" key: " + Globals.MenuKey
		await get_tree().create_timer(.5).timeout
		get_tree().change_scene_to_file("res://Menus/Main.tscn")
