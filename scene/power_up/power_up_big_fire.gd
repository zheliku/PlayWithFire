extends PowerUp

func execute():
	Global.big_fire = true
	Player.default.display_message("更大的火焰")