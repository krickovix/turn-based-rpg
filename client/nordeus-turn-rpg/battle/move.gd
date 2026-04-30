class_name Move

enum EFFECT {DAMAGE, HEAL, BUFF, DEBUFF}
enum TYPE {PHYSICAL, MAGIC}

static var static_id: int
var id: int
var string_id: String
var name: String
var effect: EFFECT
var type: TYPE
var base_value: int
var description: String

func _init() -> void:
	id = static_id
	static_id += 1
