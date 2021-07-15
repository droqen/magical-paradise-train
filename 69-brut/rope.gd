extends Sprite

onready var tween : Tween = $Tween

func itscomminghome(x):
	tween.interpolate_property(self, "position", self.position, x, 6, Tween.TRANS_BACK, Tween.EASE_OUT)