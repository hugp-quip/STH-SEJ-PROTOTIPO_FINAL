extends Label

#var color_rgb_flip : bool = true
# var color_goal0 : Color = Color(0,0,0)
# var color_goal1 : Color = Color(1,1,1)
# var color_goal : Color =  Color(1,1,1)
# var color_dir : float = 0.1
# @export var curColor : Color

func _physics_process(delta):
	self.text = "fps = " + str(Engine.get_frames_per_second())








	# #print(self.get_theme_color("font_color").lerp(Color(1,1,1), 0.1))
	# curColor = self.get_theme_color("font_color")

	# self.add_theme_color_override("font_color", curColor.lerp(Color(move_toward(curColor.r, color_goal.r, 0.9), move_toward(curColor.g, color_goal.g, 0.6), move_toward(curColor.b, color_goal.b, 0.3)), 0.01))
	# # self.add_theme_color_override("font_color", self.get_theme_color("font_color").lerp(color_goal, 0.05))
	
	# #print(self.get_theme_color("font_color").r)
	
	# print(str(self.get_theme_color("font_color").r) + "/" + str(color_goal.r))
	# if floorf(self.get_theme_color("font_color")) == color_goal:
	# # 	print("flip")
	# 	if color_goal == color_goal0:
	# 		color_goal = color_goal1
	# 	else:
	# 		color_goal = color_goal0
