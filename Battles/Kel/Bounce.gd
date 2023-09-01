extends Area2D

func _on_body_entered(body):
	if body is Soul:
		if body.State.Blue:
			if body.bounced:
				body.bounced = true
				body.fall *= -0.99
				body.bounceArea = self
			else:
				body.bounced = true
				body.fall *= -1.5
				body.bounceArea = self
