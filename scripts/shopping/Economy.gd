class_name Economy
extends Node

@export var current_balance : int = 0

static var INSTANCE : Economy

func _ready() -> void:
	assert(not INSTANCE)
	INSTANCE = self
	

func add_money(amount_to_add : int)->void:
	current_balance += amount_to_add
	

func can_spend_money(amount_to_spend: int)->bool:
	return amount_to_spend < current_balance
	
func spend_money(amount_to_spend : int)->void:
	current_balance -= amount_to_spend
