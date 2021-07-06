extends Node
class_name NavdiContactCollector

signal contacts_changed(contacts)

export (NodePath) var _whose_contacts: String = ".."
export var _collect_area_contacts: bool
export var _collect_body_contacts: bool

var contacts: Array = []

func _enter_tree():
	var contactor = get_node(_whose_contacts)
	if _collect_area_contacts:
		contactor.connect("area_entered", self, "_on_contact_entered")
		contactor.connect("area_exited", self, "_on_contact_exited")
	if _collect_body_contacts:
		contactor.connect("body_entered", self, "_on_contact_entered")
		contactor.connect("body_exited", self, "_on_contact_exited")
func _exit_tree():
	contacts = []
	emit_signal("contacts_changed", contacts) # cleared
	if has_node(_whose_contacts):
		var contactor = get_node(_whose_contacts)
		if _collect_area_contacts:
			contactor.disconnect("area_entered", self, "_on_contact_entered")
			contactor.disconnect("area_exited", self, "_on_contact_exited")
		if _collect_body_contacts:
			contactor.disconnect("body_entered", self, "_on_contact_entered")
			contactor.disconnect("body_exited", self, "_on_contact_exited")
func _on_contact_entered(contact):
	if not contact in contacts:
		contacts.append(contact)
		emit_signal("contacts_changed", contacts)
func _on_contact_exited(contact):
	var count = contacts.count(contact)
	for _i in range(count):
		contacts.erase(contact)
	if count:
		emit_signal("contacts_changed", contacts)
