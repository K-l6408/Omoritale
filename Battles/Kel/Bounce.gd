extends Area2D

func _on_body_entered(body):
	if body is Soul:
		if body.State.Blue:
			if body.bounced:
				body.fall = Vector2(0, -150).rotated(body.global_rotation)
			else:
				body.bounced = true
				body.fall *= -1.5
				body.bounceArea = self
