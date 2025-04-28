extends PigActor

func call_jump():
	velocity.y -= 150

func call_run():
	if state == State.DEAD:
		return
	state = State.MOVING
	$PlayerDetector.set_deferred("monitorable", true)
	$PlayerDetector.set_deferred("monitoring", true)
