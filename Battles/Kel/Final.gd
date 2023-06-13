extends Node2D

var platform = preload("res://Battles/Kel/Platform.tscn")
var bone = preload("res://Battles/Kel/Bone.tscn")
var halfbone = preload("res://Battles/Kel/Halfbone.tscn")
var time = 0

func _ready():
	$Pongon.Interpolate([
		Vector2(-1200, -200),
		Vector2(- 100, -200),
		Vector2(- 100,  160),
		Vector2(- 100, -200),
		Vector2(  900, -200),
		Vector2(  900, -400),
		Vector2( 1000, -400),
		Vector2( 1000, -700),
		Vector2( 1200, -700),
		Vector2( 1200,  200),
		Vector2(-1200,  200)
	],[
		Vector2(- 101, -200),
		Vector2(- 100, -200),
		Vector2(- 100,  160),
		Vector2(- 100, -200),
		Vector2(  900, -200),
		Vector2(  900, -400),
		Vector2( 1000, -400),
		Vector2( 1000, -700),
		Vector2( 1200, -700),
		Vector2( 1200,  200),
		Vector2(- 101,  200)
	], 30)

func orange(body):
	if body == $Soul:
		body.State.Orange = true
		body.pvel.x = 300

func _physics_process(delta):
	if fmod(time, 2) < fmod(time - delta, 2):
		var plf = platform.instantiate()
		plf.position = Vector2(1200, 420)
		plf.length = 20
		$"Section 2/Platforms".add_child(plf)
	for p in $"Section 2/Platforms".get_children():
		if p.position.x > 600 and p.position.x < 1150:
			p.position.x -= 100 * delta
		elif p.position.x > 1000:
			p.position.x -= 50 * delta
			p.length += 100 * delta
		else:
			p.position.x -= 50 * delta
			p.length -= 100 * delta
		if p.position.x < 550:
			p.queue_free()
	if fmod(time, 0.21) < fmod(time - delta, 0.21):
		var b = bone.instantiate()
		b.position = Vector2(1200, 490)
		b.length = 80
		$"Section 2/Bones".add_child(b)
	for b in $"Section 2/Bones".get_children():
		b.position.x -= 150 * delta
		if b.position.x < 550:
			b.queue_free()
	if fmod(time + .5, 2) < fmod(time - delta + .5, 2):
		var b = halfbone.instantiate()
		b.position = Vector2(1200, 162)
		b.rotation_degrees = 180
		b.CollisionLayer = 2
		$"Section 2/Bones_above".add_child(b)
	for b in $"Section 2/Bones_above".get_children():
		b.position.x -= 100 * delta
		b.length = 110 + sin(time * PI) * 15
		if b.position.x < 550:
			b.queue_free()
	time += delta
