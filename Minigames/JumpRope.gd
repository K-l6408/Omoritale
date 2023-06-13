extends Node2D

var Combo = 0
var Speed = 2
var time = 0
var phase = PI
var HP = 26

func _ready():
	pass

func _process(delta):
	time += delta
	$BG.color = Color.from_hsv(((time * Speed + phase) / TAU), 1, .2)
	$Combo.play("%02d" % (Combo % 80 - Combo % 5))
	$Combo.visible = (Combo > 0)
	$Combo/Label.text = "%d in a row? That's" % Combo
	if int(Combo / 80.) > $Combo.get_child_count() - 2:
		var j = $Combo/V0.duplicate(0)
		j.position -= Vector2(5, 24) * ($Combo.get_child_count() - 2)
		j.name = "V%d" % (Combo / 80.)
		j.show()
		$Combo.add_child(j)
	elif int(Combo / 80.) < $Combo.get_child_count() - 2:
		$Combo.get_child($Combo.get_child_count() - 1).queue_free()
	$Rope.scale.y = sin(time * Speed + phase) * 4
	if cos(time * Speed + phase) > 0:
		$Rope.z_index = 15
	else:
		$Rope.z_index = -1
	$Rope/Area2D/CollisionShape2D.disabled = (abs(cos(time * Speed + phase)) > 0.25)
	if (abs(cos(time * Speed + phase)) > 0.25) and \
	(abs(cos((time - delta) * Speed + phase)) < 0.25) \
	and cos(time * Speed + phase) < 0:
		if $Soul.iframes < delta:
			Combo += 1
			if Combo % 5 == 0:
				phase += time * Speed
				time = 0
				Speed += .1
				if HP < 26:
					HP += 1
	$HP/Bar.size.x = HP * 1.2

func ow(damage):
	Combo = 0
	Speed = 2
	phase += time * Speed
	phase = fmod(phase, TAU)
	time = 0
	HP -= damage
