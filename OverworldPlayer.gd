extends CharacterBody2D

const SPEED = 100
var prev : Vector2
@export var limitTopLeft : Vector2
@export var limitBottomRight : Vector2
@onready var RayCast = $RayCast2D
@onready var TextBox = %TextBox

func _ready():
	$Sprite.animation = "down"

func _physics_process(_delta):
	if $Sprite.animation == "prebattle":
		return
	if TextBox.visible:
		RayCast.enabled = false
		$Sprite.frame = 3
		return
	$Camera2D.limit_top = limitTopLeft.y
	$Camera2D.limit_bottom = limitBottomRight.y
	$Camera2D.limit_left = limitTopLeft.x
	$Camera2D.limit_right = limitBottomRight.x
	var direction = Input.get_vector("left", "right", "up", "down")
	var ang = rad_to_deg(direction.angle())
	if direction:
		velocity = direction * SPEED
		if abs(ang) < 30:
			$Sprite.play("right")
		elif abs(fmod(ang + 180, 360)) < 30:
			$Sprite.play("left")
		elif abs(fmod(ang + 90, 360)) < 30:
			$Sprite.play("up")
		elif abs(fmod(ang - 90, 360)) < 30:
			$Sprite.play("down")
		if prev:
			RayCast.rotation_degrees = ang
		else:
			$Sprite.frame = 0
	else:
		velocity = Vector2(0, 0)
		$Sprite.frame = 3
	$BattleTime.animation = $Sprite.animation
	$Sprite.speed_scale = 1
	if Input.is_action_pressed("cancel"):
		velocity *= 1.5
		$Sprite.speed_scale = 1.5
	if Input.is_action_just_pressed("accept") and RayCast.is_colliding():
		if get_parent() is TileMap and RayCast.get_collider() == get_parent():
			var pos = get_parent().local_to_map(
				get_parent().to_local(RayCast.get_collision_point()))
			var layer = null
			if   get_parent().get_cell_tile_data(0, pos).get_custom_data("Source") != "":
				layer = 0
			elif get_parent().get_cell_tile_data(1, pos).get_custom_data("Source") != "":
				layer = 1
			elif get_parent().get_cell_tile_data(2, pos).get_custom_data("Source") != "":
				layer = 2
			TextBox.start(load("res://Dialogue/flavortext.dialogue"), 
			get_parent().get_cell_tile_data(layer, pos).get_custom_data("Source"))
		else:
			TextBox.start(load("res://Dialogue/flavortext.dialogue"),
			RayCast.get_collider().get_meta("FlavorTextSource"))
	if RayCast.enabled == false:
		RayCast.enabled = true
	prev = direction
	move_and_slide()

func BattleStart(gpos):
	$AnimationPlayer.play("battle")
	await get_tree().create_timer(.65).timeout
	var Twn = create_tween()
	$Camera2D/Soul.show()
	Twn.tween_property($Camera2D/Soul, "position", (gpos - Vector2(480, 360)) / 2, .4)
	await Twn.finished
