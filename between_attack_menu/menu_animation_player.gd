extends AnimationPlayer

enum State {
	CLOSED,
	KRIS_TURN,
	SUSIE_TURN,
	RALSEI_TURN,
}

func handle_state(state):
	match state:
		State.CLOSED:
			pass
		State.KRIS_TURN:
			open_Kris()
		State.SUSIE_TURN:
			pass
		State.RALSEI_TURN:
			pass


func open_Kris():
	play("kris_turn")

func open_susie_from_kris():
	play("kris_turn", -1, 1.0, true)
	play("susie_turn")
