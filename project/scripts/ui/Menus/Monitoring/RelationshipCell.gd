extends PanelContainer
class_name RelationshipCell
## Displays a relationship between two habitants
## Shows both habitant names, a visual line, and relationship strength metrics

@onready var habitant_a_label: Label = %HabitantALabel
@onready var habitant_b_label: Label = %HabitantBLabel
@onready var bonding_a_label: Label = %BondingALabel
@onready var bonding_b_label: Label = %BondingBLabel
@onready var satisfaction_a_label: Label = %SatisfactionALabel
@onready var satisfaction_b_label: Label = %SatisfactionBLabel
@onready var happiness_a_label: Label = %HappinessALabel
@onready var happiness_b_label: Label = %HappinessBLabel
@onready var line_drawing: Control = %LineDrawing

var affiliation_data: RelationshipAffiliationData
var account_a: RelationshipAccount
var account_b: RelationshipAccount

func setup(affiliation: RelationshipAffiliationData, accounts: Dictionary):
	affiliation_data = affiliation
	print(accounts)
	print(affiliation.id_A)
	print(affiliation.id_B)
	if affiliation.id_A in accounts:
		account_a = accounts[affiliation.id_A]
	if affiliation.id_B in accounts:
		account_b = accounts[affiliation.id_B]
	
	update_display()

func update_display():
	if not affiliation_data:
		return
	
	# Get habitant names
	var name_a = "Unknown"
	var name_b = "Unknown"
	
	if account_a and account_a.origin is Habitant:
		name_a = account_a.origin.name
	if account_b and account_b.origin is Habitant:
		name_b = account_b.origin.name
	
	# Update labels
	if habitant_a_label:
		habitant_a_label.text = name_a
	if habitant_b_label:
		habitant_b_label.text = name_b
	
	if bonding_a_label:
		bonding_a_label.text = "%.1f" % affiliation_data.bonding_A
	if bonding_b_label:
		bonding_b_label.text = "%.1f" % affiliation_data.bonding_B
	
	if satisfaction_a_label:
		satisfaction_a_label.text = "S: %.1f" % affiliation_data.satisfaction_A
	if satisfaction_b_label:
		satisfaction_b_label.text = "S: %.1f" % affiliation_data.satisfaction_B

	if happiness_a_label:
		happiness_a_label.text = "H: %.1f" % account_a.happiness
	if happiness_b_label:
		happiness_b_label.text = "H: %.1f" % account_b.happiness
	
	# Queue redraw for the line
	if line_drawing:
		line_drawing.queue_redraw()

func _on_line_drawing_draw():
	if not line_drawing or not habitant_a_label or not habitant_b_label:
		return
	
	# Draw a line between the two habitant labels
	var from_pos = habitant_a_label.global_position - line_drawing.global_position + Vector2(habitant_a_label.size.x / 2, habitant_a_label.size.y)
	var to_pos = habitant_b_label.global_position - line_drawing.global_position + Vector2(habitant_b_label.size.x / 2, 0)
	
	# Color based on average happiness (green = good, red = bad)
	var avg_happiness = (affiliation_data.happiness_A + affiliation_data.happiness_B) / 2.0
	var line_color = Color.GREEN.lerp(Color.RED, 1.0 - clamp(avg_happiness, 0.0, 1.0))
	
	line_drawing.draw_line(from_pos, to_pos, line_color, 2.0)
