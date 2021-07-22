extends Label


var rat_attributes = [
	" cool",
	" heroic",
	" punk",
	" cottagecore",
	" gay",
	" friendly",
	"n adorable",
	" round",
	"n anthro",
	" seductive",
	" skaterboy",
	"n abstract",
	" mad",
	" hyperrealistic",
	" dad",
	" baby",
	" soft",
	" square",
	" minecraft",
	" slimy",
	" hot",
	" comically large",
	" miniscule",
	" screen-filling",
	" funny",
	"n evil", 
	" twisted",
	" minimalist"
	
]

func _ready():
	randomize()
	GetNewInstructions()


func GetNewInstructions():
	var txt = ""
	txt += "Make a"
	txt += rat_attributes[randi()%rat_attributes.size()]
	txt += " rat type beat"
	text = txt
	
	
	
	
	
	
	
	
	
	
	
	
