extends CharacterBody3D


const SPEED = 5
const JUMP = 3
const GRAVITY = 15
const HOLDBOOST = 14.5
const PLAYER = true
var jumping = false
var rotating = false
@export var CameraLimitX = Vector2(0, 0)
@export var CameraLimitZ = Vector2(0, 0)
@onready var RayCast = $RayCast2D
@onready var TextBox = %TextBox

func _ready():
	$Sprite.animation = "right"

func _process(_delta):
	$Pause.hide()
	if Input.is_action_just_pressed("menu") and not $TextBox.visible:
		get_tree().set_pause(true)

func _physics_process(delta):
	if not is_on_floor(): velocity.y -= GRAVITY * delta
	else: velocity.y = 0
	if not rotating:
		if Input.is_action_pressed("up"):
			if jumping: velocity.y += HOLDBOOST * delta
			elif is_on_floor():
				velocity.y = JUMP
				jumping = true
		else: jumping = false
		if velocity.y < 0: jumping = false
		var direction = Input.get_axis("left", "right")
		if direction:
			velocity.x = direction * cos(rotation.y) * SPEED
			velocity.z = direction * -sin(rotation.y) * SPEED
			if direction > 0: $Sprite.play("right")
			else: $Sprite.play("left")
			if direction != 0: RayCast.target_position.x = sign(direction)
		else:
			velocity.x = 0
			velocity.z = 0
			$Sprite.frame = 3
	move_and_slide()

func rot8(howmuch:int):
	var rd :int= rotation_degrees.y + howmuch
	rotating = true
	velocity.x = 0
	velocity.z = 0
	var tw = create_tween()
	tw.tween_property(self, "rotation_degrees:y", rd, 1).set_trans(Tween.TRANS_ELASTIC)
	await tw.finished
	rotating = false
	rotation_degrees.y = rd
