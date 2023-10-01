extends Control

var G = 0
var T = [
	preload("res://Assets/Sprites/Weapons/Stick.png")
]
var Going = false

func _ready():
	for E in Globals.Enemies.size():
		var ER = Globals.Enemies[E]
		var EN = $Templ.duplicate()
		%Enemies.add_child(EN)
		EN.name = str(E)
		EN.position.x = ER.Position + 30
		$Rect.E.append(Vector2(
			ER.Position - ER.Scale * 125 - 5, ER.Scale * 250 + 10
		))
	await get_tree().create_timer(1).timeout
	match Globals.WEPN:
		Globals.Weapon.Stick:
			makewpn(1, 0)

func makewpn(count, textr):
	var J
	var K = null
	var C = 0
	for i in count:
		J = K
		K = $KILL.duplicate()
		if J == null: K.select = true
		else: J.next = K
		K.process = true
		K.texture = T[textr]
		K.time = -C
		K.murd = $MURDER
		K.connect("hey", heyy)
		C += randf_range(0.5, 2)
		%Fight.add_child(K)
	Going = true

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		emit_signal("nvm")
	for E in %Enemies.get_child_count():
		if %Enemies.get_child(E).scale.x < Globals.Enemies[E].Scale:
			%Enemies.get_child(E).scale.x += Globals.Enemies[E].Scale * delta
			%Enemies.get_child(E).modulate.a += delta
	if Going and %Fight.get_child_count() == 0:
		G -= delta
		if G <= 0:
			emit_signal("done")
			queue_free()
		if G > .5:
			$Rect.DC = lerp(Color(0,.5,0), Color(1,.2,.2), G)
			$Rect.size.y = 820 * (G * G - G) + 210
			$Rect.position.y = 315 - 820 * (G * G - G)
			for i in %Enemies.get_children():
				i.scale.y = 4.4 * (G * G - G) + 1.1
				i.position.y = 420 * (1 - G + G * G)
		else:
			$Rect.hide()
			$Rect2.show()
			$Rect2.DC = lerp(Color(0,.5,0), Color(1,.2,.2), G)
			$Rect2.size.y = 820 * (G * G - G) + 210
			$Rect2.position.y = 315 - 820 * (G * G - G)
	elif G < .5:
		G += delta
		$Rect2.DC = lerp(Color(1,1,1), Color(1,.2,.2), G)
		$Rect2.size.y = 820 * (G * G - G) + 210
		$Rect2.position.y = 315 - 820 * (G * G - G)
	elif G < 1:
		G += delta
		$Rect2.hide()
		$Rect.show()
		$Rect.DC = lerp(Color(1,1,1), Color(1,.2,.2), G)
		$Rect.size.y = 820 * (G * G - G) + 210
		$Rect.position.y = 315 - 820 * (G * G - G)
		for i in %Enemies.get_children():
			i.scale.y = 4.4 * (G * G - G) + 1.1
			i.position.y = 420 * (1 - G + G * G)
		if G >= 1:
			G = 1
			$Rect.size.y = 210
			$Rect.position.y = 315
			for i in %Enemies.get_children():
				i.scale.y = 1.1
				i.position.y = 420

func heyy(itsme):
	var a := []
	for e in Globals.Enemies:
		a.append(e.Position)
	itsme.thx = closest(itsme.position.x, a)

func closest(my_number, my_array:Array):
	var closest_num
	var closest_delta = 0
	var temp_delta = 0
	for i in range(my_array.size()):
		if my_array[i] == my_number: return my_array[i] # exact match found!
		temp_delta = abs(my_array[i]-my_number)
		if closest_delta == 0 or temp_delta < closest_delta:
			closest_num = my_array[i]
			closest_delta = temp_delta
	return closest_num

signal nvm()
signal done()
