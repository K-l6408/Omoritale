extends Node2D

var time = 0
var j = 1
var leaf = preload("res://Battles/Mari/Leaf.tscn")

func _ready():
	$Box.ChangeSize(Vector2(900, 250), 1)
	$Box2.ChangeSize(Vector2(500, 50), 1)
	go()

func go():
	$Box/Black/Warn2.modulate.a = 1
	$AudioStreamPlayer.play()
	await $AudioStreamPlayer.finished
	spawn($Box/Black/Leaves2)
	await get_tree().create_timer(2.5).timeout
	for _j in 5:
		var i = randi_range(0, 1)
		if i % 2: $Box/Black/Warn.modulate.a = 1
		else: $Box/Black/Warn2.modulate.a = 1
		$AudioStreamPlayer.play()
		await $AudioStreamPlayer.finished
		spawn($Box/Black/Leaves if i%2 else $Box/Black/Leaves2)
		await get_tree().create_timer(2.5).timeout
	$Box/Black/Warn.modulate.a = 1
	$Box/Black/Warn2.modulate.a = 1
	$AudioStreamPlayer.play()
	await $AudioStreamPlayer.finished
	spawn($Box/Black/Leaves)
	spawn($Box/Black/Leaves2)
	await get_tree().create_timer(1.5).timeout
	time = 1
	j = -1
	$Box.ChangeSize(Vector2(900, 200), 2)
	$Box2.ChangeSize(Vector2(0, 0), 2)
	await get_tree().create_timer(2.5).timeout
	queue_free()

func _process(delta):
	time += delta * j
	$Box/Black/Warn.modulate.a -= delta * 2
	$Box/Black/Warn2.modulate.a -= delta * 2
	$Box/Black/Wind.Size.y =  lerp(0, 100, min(time, 1))
	$Box/Black/Wind2.Size.y = lerp(0, 100, min(time, 1))
	for L in $Box/Black/Leaves.get_children():
		L.position.y += delta * 1000
		if L.position.y > 600: L.queue_free()
	for L in $Box/Black/Leaves2.get_children():
		L.position.y += delta * 1000
		if L.position.y > 600: L.queue_free()

func spawn(nd):
	for i in 150:
		var L = leaf.instantiate()
		nd.add_child(L)
		L.atkType = Atk.White
		L.T = randf_range(-PI, PI)
		L.position = Vector2(randf_range(-100, 100),randf_range(0, -500))

func h(wh): emit_signal("hit", wh)

signal hit(what)
