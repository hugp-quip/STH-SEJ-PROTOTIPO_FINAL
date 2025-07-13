extends Label

func _physics_process(delta):
	self.text = "fps = " + str(Engine.get_frames_per_second())
	