@icon("res://Assets/Icons/Soul.svg")

extends CharacterBody2D
class_name Soul

@export var State : SoulState : set = setState
@export_group("Settings")
@export var inverted_controls := false
@export var mouse_controls := false
@export var controls := true
@export var rotation_settings : rSettings
@export_group("Settings/Visual")
@export var show_DT := true
@export var show_Trans := false
@export var show_BG := true
@export var show_Shadow := true
@export_group("Settings/Green")
@export var first_shield := true
@export var second_shield := false
@export var third_shield := false
@export var fourth_shield := false
@export_group("Settings/Mint")
@export var default_size := 1.1
@export_group("Settings/Blue")
@export var maximum_jumps := 2
@export_group("Settings/Purple")
@export var line_number = 3
@export var line_spacing = 100
@export var line_rotation = 0
@export var current_line = 0
@export var line_extents : PackedVector2Array
@onready var purpleStartPnt = position
@onready var purpleStartLin = Vector2(0, -current_line * line_spacing).rotated(deg_to_rad(line_rotation))
@onready var purpleStartPos = purpleStartPnt + purpleStartLin

@export_group("")
@export var debug = 0.0 # use for whatever

enum rSettings {
	DEFAULT, MOUSE, LAST_KEY_PRESSED, INVERSE_LAST_KEY_PRESSED
}

const ow := preload("res://Assets/Audio/Ouch.wav")
const thx = preload("res://Assets/Audio/Heal.wav")
const new = preload("res://Assets/Audio/Ding.wav")
const sht = preload("res://Assets/Audio/Shot.wav")
const blt = preload("res://SOUL/Bullet.tscn")
const swv = preload("res://SOUL/Shockwave.tscn")
var arc       := 0
var iframes   := 0.0
var vel       : Vector2
var pvel      := Vector2.UP * 100
var px = 100
var fall      := Vector2(0,0)
var fallspd   := 0.0
var jumps     := maximum_jumps
var jumping   := false
var bounced   := false
var bounceArea : Area2D
var dashcharg := 0.0
var dash      := 0.0
var mintshr   :=-2.0
var tping     := false
var plc       :  float
var h = false
var handle_rot = true
var mouse = true


func _ready():
	plc = current_line
	$Lines.position = purpleStartPos
	jumps = maximum_jumps
	floor_stop_on_slope = false
	$TP.add_collision_exception_with(self)
	var tw = create_tween()
	tw.tween_property(self, "arc", 360 * int(State.Green), .5)
	if not Engine.is_editor_hint():
		$Trail   .texture = $Sprite.get_texture()
		$Change  .texture = $Sprite.get_texture()
		$Sprite2D.texture = $Sprite.get_texture()

func setState(value:SoulState):
	value.connect("changed", func():
			$Change.restart()
			$Aud.volume_db = 2
			$Aud.stream = new
			$Aud.play()
			var tw = create_tween()
			tw.tween_property(self, "arc", 360 * int(State.Green), .5)
	)
	State = value

func _process(_delta):
	if Input.is_action_just_pressed("why"): mouse_controls = !mouse_controls
	if is_queued_for_deletion(): mouse_controls = false
	$Shields.position = global_position
	$Shields.scale    = scale
	$Line2D.visible   = State.Green
	if not State.Teal or not tping: $Shields.setang(pvel.angle() + PI/2)
	$Trail.process_material.angle_min = -$Sprite2D.global_rotation_degrees
	$Trail.process_material.angle_max = -$Sprite2D.global_rotation_degrees
	$Trail.process_material.scale_min = min(global_scale.x, global_scale.y)
	$Trail.process_material.scale_max = max(global_scale.x, global_scale.y)
	$Trail.emitting = State.Orange
	$Sprite/Bounce.visible = bounced and State.Blue
	$Sprite2D/Charge.visible = State.Orange
	modulate.a = 1 if iframes <= 0 else (.33 if fmod(iframes, .5) > .25 else .66)

func _physics_process(delta):
	if State.Blue:
		motion_mode = CharacterBody2D.MOTION_MODE_GROUNDED
		if inverted_controls:
			up_direction = Vector2.UP.rotated(global_rotation+PI)
		else:
			up_direction = Vector2.UP.rotated(global_rotation)
	else:
		motion_mode = CharacterBody2D.MOTION_MODE_FLOATING
		$Sprite2D/Label.hide()
	if not Engine.is_editor_hint():
		$TP.collision_layer = 0
		$TP.collision_mask = 0
		$TP.visible = State.Teal and tping
		$TPLine.visible = State.Teal and tping
		process_texture()
		iframes -= delta
		handle_hitbox()
		var v = vel
		if State.Orange:
			v = pvel
		handle_input()
		if State.Teal and tping:
			velocity = Vector2.ZERO
			move_and_slide()
		else:
			if State.Red:
				velocity = velocity.rotated(global_rotation)
				vel = vel.rotated(global_rotation)
				if Input.is_action_pressed("cancel"):
					velocity /= 2
			if State.Blue:
				var j
				fallspd = fall.rotated(-rotation).y
				if State.Orange:
					jumps = int(is_on_floor())
					j = -pvel.rotated(-global_rotation).y
					var pj = -v.rotated(-global_rotation).y
					if j < -10 and pj > -10:
						fallspd = 200
					j = 100
				else:
					j = -vel.rotated(-global_rotation).y
					if j < 0:
						j = 0
						jumping = false
				if is_on_floor() and (
					bounceArea == null or not self in bounceArea.get_overlapping_bodies()
					):
					jumps = maximum_jumps
					fallspd = 50
					jumping = false
					bounced = false
					if State.Orange:
						pvel = Vector2(pvel.rotated(-global_rotation).x, -100).rotated(global_rotation)
				elif jumps == maximum_jumps:
					jumps -= 1
				if is_on_ceiling():
					jumps = 0
					fallspd = abs(fallspd)
				if j > 10:
					if jumping:
						fallspd -= delta * 300
					elif jumps > 0 or maximum_jumps < 0:
						fallspd = -150
						jumps -= 1
						jumping = true
				else:
					jumping = false
				if fallspd > 500:
					fallspd = 500
				var lt = jumps + int(not is_on_floor()) # Label Text
				if lt > 1:
					$Sprite2D/Label.show()
					$Sprite2D/Label.text = str(lt)
				elif lt < 0:
					$Sprite2D/Label.show()
					$Sprite2D/Label.text = "∞"
				else:
					$Sprite2D/Label.hide()
				var p = velocity.rotated(-global_rotation)
				p.y = 0
				fall = fall.rotated(-global_rotation)
				if dash > 0 and State.Orange:
					fall.y = 0
				else:
					fallspd += 400 * delta
					fall.y = fallspd
				fall.x = lerp(fall.x, 0., delta * 3)
				fall   = fall.rotated(global_rotation)
				velocity  = p.rotated(global_rotation)
				velocity += fall
			if State.Orange:
				set_collision_layer_value(2, dash < 0)
				set_collision_mask_value(2, dash < 0)
				$HitBox.set_collision_layer_value(2, dash < 0)
				$HitBox.set_collision_mask_value(2, dash < 0)
				if Input.is_action_pressed("accept") and dash < 0:
					dashcharg += delta
					$Aura.emitting = true
					if dashcharg > 1.5:
						iframes = dashcharg / 2
						Input.action_release("accept")
				if Input.is_action_just_released("accept"):
					$Aura.emitting = false
					dash = dashcharg / 2
					dashcharg = 0
				if dash > -1:
					dash -= delta
				if dash > 0:
					if State.Blue:
						var p = velocity.rotated(-global_rotation)
						p.x /= .375
						velocity = p.rotated(global_rotation)
					else:
						velocity /= .375
				$Sprite2D/Charge.region_rect.size.y = 20*dashcharg/1.5
				$Sprite2D/Charge.region_rect.position.y = 20-20*dashcharg/1.5
				$Sprite2D/Charge.position.y = 10-20*dashcharg/1.5
				if State.Purple:
					if dashcharg > 0:
						velocity -= Vector2(px, 0).rotated(global_rotation + deg_to_rad(line_rotation))
					elif abs(pvel.rotated(-global_rotation - deg_to_rad(line_rotation)).x) <= 10:
						pvel += Vector2(px, 0).rotated(global_rotation + deg_to_rad(line_rotation))
					else:
						px = pvel.rotated(-global_rotation - deg_to_rad(line_rotation)).x
				elif State.Blue:
					if dashcharg <= 0 and pvel.rotated(-global_rotation).x == 0:
						pvel += Vector2(px, 0).rotated(global_rotation)
					else:
						px = pvel.rotated(global_rotation).x
				elif dashcharg > 0:
					velocity = Vector2(0, 0)
			if State.Purple:
				if State.Blue:
					line_rotation = rotation_degrees - 90
				var temp = (position-purpleStartPos).rotated(deg_to_rad(-line_rotation))+purpleStartPos
				line_extents.resize(line_number)
				if State.Orange and temp.x != clamp(temp.x - purpleStartPos.x,\
				line_extents[current_line].x, line_extents[current_line].y) + purpleStartPos.x:
					pvel -= Vector2(px, 0).rotated(global_rotation + deg_to_rad(line_rotation))
					px *= -1
					velocity *= -1
				temp.x = clamp(temp.x - purpleStartPos.x,
				line_extents[current_line].x, line_extents[current_line].y) + purpleStartPos.x
				temp.y = lerp(temp.y, (current_line * line_spacing) + purpleStartPos.y, delta * 5)
				position = (temp-purpleStartPos).rotated(deg_to_rad(line_rotation))+purpleStartPos
				velocity.x = velocity.rotated(deg_to_rad(-line_rotation)).x
				velocity.y = 0
				velocity = velocity.rotated(deg_to_rad(line_rotation))
				if current_line > 0:
					if vel.rotated(deg_to_rad(-line_rotation)).y < -70 and not v.rotated(deg_to_rad(-line_rotation)).y < -70 \
					and temp.x - purpleStartPos.x == \
					clamp(temp.x - purpleStartPos.x, line_extents[current_line -1].x, line_extents[current_line -1].y):
						current_line -= 1
				if current_line < line_number - 1:
					if vel.rotated(deg_to_rad(-line_rotation)).y > 70 and not v.rotated(deg_to_rad(-line_rotation)).y > 70 \
					and temp.x - purpleStartPos.x == \
					clamp(temp.x - purpleStartPos.x, line_extents[current_line +1].x, line_extents[current_line +1].y):
						current_line += 1
			if State.Mint:
				if mintshr > -2:
					mintshr -= delta
				elif Input.is_action_just_pressed("cancel"):
					mintshr = 3
					var s = swv.instantiate()
					s.scale = Vector2(default_size, default_size) * 1.3
					add_sibling(s)
					s.global_position = global_position
				if mintshr > 0:
					scale.x = lerp(scale.x, default_size / 2, delta)
					scale.y = lerp(scale.y, default_size / 2, delta)
					if State.Blue:
						var p = velocity.rotated(-global_rotation)
						p.x /= scale.x / default_size
						velocity = p.rotated(global_rotation)
					else:
						velocity /= scale.x / default_size
					if (mintshr + .5) - floor(mintshr + .5) < delta:
						modulate.v = 0
					elif modulate.v < 1:
						modulate.v += delta * 2
				else:
					scale.x = lerp(scale.x, default_size, delta)
					scale.y = lerp(scale.y, default_size, delta)
			if State.Yellow:
				if Input.is_action_just_released("accept"):
					shoot()
		if State.Teal:
			set_collision_layer_value(3, not tping)
			set_collision_mask_value(3, not tping)
			$HitBox.set_collision_layer_value(3, not tping)
			$HitBox.set_collision_mask_value(3, not tping)
			if Input.is_action_just_pressed("menu"):
				if tping:
					tping = false
					position = $TP.position
				else:
					tping = true
					if State.Purple:
						var temp = ($TP.position - purpleStartPos).rotated(deg_to_rad(-line_rotation))
						current_line = int(temp.y / line_spacing +.5)
					$TP.position = position
		if State.Teal and tping:
			$TPLine.points[1] = ($TP.position - position) / scale
			$TP.velocity = vel * 2
			$TP.scale = scale
			$TP.collision_layer = 1
			$TP.collision_mask = 1
			$TP.move_and_slide()
		else:
			move_and_slide()
		if handle_rot:
			handle_rotation(delta)
		var collision = get_last_slide_collision()
		if is_on_wall() and collision and State.Orange:
			pvel = pvel.bounce(collision.get_normal())
	if State.Purple:
		plc = lerp(plc, float(current_line), delta*5)
		line_extents.resize(line_number)
		$Lines.rotation_degrees = line_rotation
		var lc = $Lines.get_child_count()
		if lc < line_number:
			var L = Line2D.new()
			$Lines.add_child(L)
		if lc > line_number:
			$Lines.get_child(0).queue_free()
		for c in min($Lines.get_child_count(), line_number):
			var L = $Lines.get_child(c)
			L.default_color = Color("9c279f")
			L.width = 2
			L.points = [Vector2(line_extents[c].x, 0), Vector2(line_extents[c].y, 0)]
			L.position = Vector2(0, c * line_spacing)
			if line_extents[c] == Vector2(0,0):
				line_extents[c] = Vector2(-150,150)
	else:
		for L in $Lines.get_children():
			L.queue_free()

func handle_rotation(delta):
	var r = global_rotation
	match rotation_settings:
		rSettings.MOUSE:
			if State.Blue or State.Red:
				rotation_settings = rSettings.DEFAULT
			else:
				if mouse:
					rotation = get_global_mouse_position().angle_to_point(global_position) + PI/2
				else:
					var alt = Input.get_vector("leftAlt", "rightAlt", "upAlt", "downAlt")
					if alt.length_squared() > 0.01:
						rotation = alt.angle() - PI/2
		rSettings.LAST_KEY_PRESSED:
			if State.Blue or State.Red:
				rotation_settings = rSettings.DEFAULT
			else:
				rotation = pvel.angle() - PI / 2
		rSettings.INVERSE_LAST_KEY_PRESSED:
			if State.Blue or State.Red:
				rotation_settings = rSettings.DEFAULT
			else:
				rotation = pvel.angle() + PI / 2
	if abs(wrapf(r - global_rotation, -TAU, TAU)) <= 0.0001 or abs($Sprite2D.rotation) >= 0.01:
		$Sprite2D.rotation = lerp_angle($Sprite2D.rotation, 0, delta * 7)
	else:
		$Sprite2D.global_rotation += r - global_rotation

func process_texture():
	var total = int(State.Red) + int(State.Orange) + int(State.Yellow) + int(State.Green) + \
	int(State.Mint) + int(State.Teal) + int(State.Blue) + int(State.Purple)
	var i = 0.0
	for j in $Sprite/Colors.get_children():
		if State.get(j.name):
			j.show()
			j.region_rect.position.x = i / total * 19.
			i += 1
			j.region_rect.size.x = 19. / total
			j.modulate = Globals.Colors[j.name]
		else:
			j.hide()
		j.region_rect.size.y = 20
		j.region_rect.position.y = 0
		j.position = j.region_rect.position
	$Sprite2D/BG.visible = show_BG
	$Sprite2D/DT.visible = show_DT
	$Sprite2D/trans.visible = show_Trans
	$Sprite2D/Shadow.visible = show_Shadow

func shoot():
	if dash > 0.1:
		return
	var bullet
	bullet =   blt.instantiate()
	$Aud.stream =   sht
	$Aud.volume_db = 0
	$Aud.play()
	get_parent().add_child(bullet)
	bullet.start(global_position + Vector2(0,20).rotated(rotation),rotation,self)
	bullet.global_scale = global_scale / 1.5
	if State.Blue:
		var f = fall.rotated(global_rotation)
		f.y = -150
		fall = f.rotated(-global_rotation)

func slam(rot8ion, speed = 200):
	State.Blue = true
	rotation_degrees = rot8ion
	fallspd = speed

func handle_input():
	if controls:
		if mouse_controls:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			vel = Input.get_last_mouse_velocity()
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			vel = Input.get_vector("left", "right", "up", "down")
		vel = vel.normalized() * global_scale * 100
	else:
		vel = Vector2(0, 0)
	if inverted_controls:
		vel *= -1
	if vel != Vector2(0, 0):
		if State.Red:
			pvel = vel.rotated(global_rotation)
		else:
			pvel = vel
	if State.Orange:
		velocity = pvel
	else:
		velocity = vel

func _input(event):
	if event is InputEventJoypadMotion:
		if event.axis == 2 or event.axis == 3:
			if event.axis_value > 0.01:
				mouse = false
	elif event is InputEventMouseMotion:
		if event.velocity.length_squared() > 0.01:
			mouse = true

func handle_hitbox():
	for Obj in $HitBox.get_overlapping_areas():
		if iframes <= 0:
			iframes = 0
			if (zero(Obj.get("atkType")) & Atk.Blue and not get_velocity() == Vector2.ZERO) or \
			(zero(Obj.get("atkType"))    & Atk.Orange  and  get_velocity() == Vector2.ZERO):
				$Aud.stop()
				if Obj.get("attacker") != null and Obj.get("attacker") != "":
					emit_signal("hurt", Obj.get("attacker"))
					$Aud.stream = ow
					$Aud.play()
				elif Obj.get("damage") != null:
					if zero(Obj.damage) > 0:
						$Aud.stream = ow
						$Aud.play()
					else:
						$Aud.stream = thx
						$Aud.play()
					emit_signal("hurt_fixed", zero(Obj.get("damage")))
				iframes = 1
				$Aud.volume_db = 0
		else:
			if zero(Obj.get("delete")):
				Obj.queue_free()
	if State.Green:
		$"Shields/1".monitoring  = first_shield
		$"Shields/1".visible     = first_shield
		$"Shields/1".monitorable = first_shield
		$"Shields/2".monitoring  = second_shield
		$"Shields/2".monitorable = second_shield
		$"Shields/2".visible     = second_shield
		$"Shields/3".monitoring  = third_shield
		$"Shields/3".monitorable = third_shield
		$"Shields/3".visible     = third_shield
		$"Shields/4".monitoring  = fourth_shield
		$"Shields/4".monitorable = fourth_shield
		$"Shields/4".visible     = fourth_shield
		if first_shield:
			for Obj in $"Shields/1".get_overlapping_areas():
				if zero(Obj.get("atkType")) & Atk.Block: if Obj.Block(1): 
					if State.Blue and abs(wrapf(180+rotation_degrees - $Shields.rotation_degrees, -180, 180)) < 50:
						fall = Vector2(0,-150).rotated(rotation)
						jumping = true
		if second_shield:
			for Obj in $"Shields/2".get_overlapping_areas():
				if zero(Obj.get("atkType")) & Atk.Block: if Obj.Block(2):
					if State.Blue and abs(wrapf(rotation_degrees - $Shields.rotation_degrees, -180, 180)) < 50:
						fall = Vector2(0,-150).rotated(rotation)
						jumping = true
		if third_shield:
			for Obj in $"Shields/3".get_overlapping_areas():
				if zero(Obj.get("atkType")) & Atk.Block: if Obj.Block(3):
					if State.Blue and abs(wrapf(90+rotation_degrees - $Shields.rotation_degrees, -180, 180)) < 50:
						fall = Vector2(0,-150).rotated(rotation)
						jumping = true
		if fourth_shield:
			for Obj in $"Shields/4".get_overlapping_areas():
				if zero(Obj.get("atkType")) & Atk.Block: if Obj.Block(4):
					if State.Blue and abs(wrapf(-90+rotation_degrees - $Shields.rotation_degrees, -180, 180)) < 50:
						fall = Vector2(0,-150).rotated(rotation)
						jumping = true
	else: for s in $Shields.get_children():
		s.monitoring  = false
		s.monitorable = false
		s.visible     = false

func zero(arg):
	if arg:
		return arg
	else:
		return 0

signal hurt(attacker)
signal hurt_fixed(damage)
