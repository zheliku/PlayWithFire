extends PowerUp

func execute():
	Global.fire_burn_seconds += 1.0
	Player.default.display_message("燃烧时长+1s")
