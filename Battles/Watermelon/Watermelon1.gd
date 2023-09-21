extends Node2D

var JP = 0
var debug = 0
var bulletpos = [
	Vector2(400, 260),
	Vector2(450, 240),
	Vector2(510, 240),
	Vector2(560, 260)
]
var debVelocity = Vector2(0,0)
var time = 0
@onready var bullet = $BulletTemplate

func _ready():
	$TextBox.start(load("res://Dialogue/materwelon.dialogue"), "battle")
	$HP    .size.x = 0
	$JP    .size.x = 0
	$HP/Bar.size.x = 0
	$JP/Bar.size.x = 0
	$Audio.play(Globals.musynctime)
	Globals.HP = 26

func _process(delta):
	$HP/Bar.size.x = lerpf($HP/Bar.size.x, Globals.HP * 1.2, delta * 2)
	$JP/Bar.size.x = lerpf($JP/Bar.size.x, JP * 1.2, delta * 2)
	$HP    .size.x = lerpf($HP    .size.x, GLOBALS.MHPfromLV(1) * 1.2, delta * 5)
	$JP    .size.x = lerpf($JP    .size.x, GLOBALS.MJPfromLV(1) * 1.2, delta * 5)
	$JP    .position.x = 906 - $JP.size.x
	$JP/Bar.position.x = $JP.size.x - $JP/Bar.size.x
	JP += delta / 5
	if JP > GLOBALS.MJPfromLV(1):
		JP = GLOBALS.MJPfromLV(1)
	if debug != 9:
		if $Melon.animation != Globals.debugAnimation: $Melon.play(Globals.debugAnimation)
	if debug == 9:
		if $Mari/Face.animation != Globals.debugAnimation: $Mari/Face.play(Globals.debugAnimation)
	if debug == 0 and Globals.debugAttack == 1:
		debug = 1
		for i in 4:
			var b = bullet.duplicate(5)
			$Bullets.add_child(b)
			b.position = bulletpos[i]
			b.show()
			b.go_towards($Soul.position, 150)
		await get_tree().create_timer(6).timeout
		if debug == 1:
			debug = 4
			$TextBox.start(load("res://Dialogue/materwelon.dialogue"), "dodged")
	if debug == 2 and Globals.debugAttack == 2:
		debug = 3
		for i in 20:
			var b = bullet.duplicate(5)
			$Bullets.add_child(b)
			b.position = $Soul.position + Vector2(0, 200).rotated(TAU / 20 * i)
			b.damage = -3
			b.show()
			b.go_towards($Soul.position, 150)
	if debug == 4 and Globals.debugAttack == 3:
		debug = 5
		$Soul.iframes = 0
		for i in 20:
			var b = bullet.duplicate(5)
			$Bullets.add_child(b)
			b.position = $Soul.position + Vector2(0, 200).rotated(TAU / 20 * i)
			b.damage = Globals.HP - 1
			b.smooth = true
			b.show()
			b.go_towards($Soul.position, 150)
	if debug == 5 and Globals.debugAttack == 4:
		debug = 6
		for i in 20:
			var b = bullet.duplicate(5)
			$Bullets.add_child(b)
			b.position = $Box.position + Vector2(0, 350).rotated(TAU / 20 * i)
			b.damage = 1
			b.show()
			b.go_towards($Box.position + Vector2(0, 150).rotated(TAU / 20 * i), 150, false)
	if debug == 6 and Globals.debugAttack == 5:
		debug = 7
		var TW = create_tween().set_parallel()
		TW.tween_property($Wind, "position:x", 700, 1)
		TW.tween_property($Wind, "modulate:a", 1, 1)
	if debug == 7 and Globals.debugAttack == 6:
		debug = 8
		var TW = create_tween()
		TW.tween_property($Wind, "position:x", 600, 1./8)
		await TW.finished
		TW = create_tween().set_parallel()
		TW.tween_property($Wind, "position:x", -100, 7./8)
		TW.tween_property($Audio, "pitch_scale", .3, 7./8).set_trans(Tween.TRANS_CUBIC)\
		.set_ease(Tween.EASE_OUT)
		debVelocity = Vector2(-800, -250)
		await TW.finished
		$Audio.stop()
		okay()
	if debug == 8:
		time += delta
		$Melon.position += debVelocity * delta
		debVelocity.y += 500 * delta
	if Globals.debugAttack > 90:
		get_tree().change_scene_to_file("res://Battles/Watermelon/Cutscene.tscn")

func okay():
	while $Bullets.get_child_count() > 0:
		$Bullets.get_child(0).queue_free()
		await get_tree().create_timer(.01).timeout
	var TW = create_tween()
	TW.tween_property($Mari, "position:x", 480, 1)
	await TW.finished
	debug = 9
	$TextBox.start(load("res://Dialogue/materwelon.dialogue"), "mariiii")

func ouch(damage):
	Globals.HP -= damage
	if Globals.HP > GLOBALS.MHPfromLV(1):
		Globals.HP = GLOBALS.MHPfromLV(1)
	if Globals.debugAttack == 1:
		await get_tree().create_timer(1).timeout
		debug = 2
		$TextBox.start(load("res://Dialogue/materwelon.dialogue"), "hurt")
	if Globals.debugAttack == 2:
		await get_tree().physics_frame
		$Soul.iframes = 3
		await get_tree().create_timer(1).timeout
		debug = 4
		$TextBox.start(load("res://Dialogue/materwelon.dialogue"), "greend")
	if Globals.debugAttack == 3:
		await get_tree().physics_frame
		$Soul.iframes = 3
		$TextBox.start(load("res://Dialogue/materwelon.dialogue"), "troll")

func actual_mus():
	$Audio.stream = load("res://Assets/Audio/BGM/watermelon.mp3")
