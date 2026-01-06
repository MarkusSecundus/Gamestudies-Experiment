class_name Economy
extends Node

@export var current_balance : int = 0

@export_group("Money Tweens")
@export var _big_balance_label_tween_duration_seconds = 2.0
@export var _balance_change_fade_in_duration_seconds = 0.3
@export var _balance_change_stay_seconds = 2.0
@export var _balance_change_fade_out_duration_seconds = 0.3

@onready var _balance_change_marker : Node2D = $Shop/BalanceChangeMarker
@onready var _balance_change_label : Label = $Shop/BalanceChangeMarker/Label
@onready var _big_balance_label : Label = $Shop/BalanceLabel

@export_group("Purchasable Tweens")
@export var _purchasable_available_alpha :float = 1.0
@export var _purchasable_unavailable_alpha :float = 0.5
@export var _purchasable_fade_duration_seconds : float = 0.5

signal on_balance_change()

var _big_balance_label_writer : int:
	get: return _big_balance_label_writer
	set(val):
		_big_balance_label_writer = val
		_big_balance_label.text = "%d"%val

var _balance_change_label_writer : int:
	get: return _balance_change_label_writer
	set(val):
		_balance_change_label_writer = val
		_balance_change_label.text = ("+ " if _balance_change_label_writer >= 0 else "- ") + ("%d"%abs(_balance_change_label_writer))

static var INSTANCE : Economy

func _ready() -> void:
	assert(not INSTANCE)
	INSTANCE = self
	
	_big_balance_label_writer = current_balance
	

var _big_balance_label_tween := EffectsUtils.TweenWrapper.new(self)
var _balance_change_label_tween := EffectsUtils.TweenWrapper.new(self)
var _balance_change_tween := EffectsUtils.TweenWrapper.new(self)
var _balance_change_amount : int = 0

func _internal_change_money_amount(delta : int)->void:
	current_balance += delta
	on_balance_change.emit()
	_balance_change_amount += delta
	_big_balance_label_tween.create_tween().tween_property(self, "_big_balance_label_writer", current_balance, _big_balance_label_tween_duration_seconds)
	_balance_change_label_writer = _balance_change_amount
	
	var tw := _balance_change_tween.create_tween()
	EffectsUtils.do_fade_with_tween(tw, _balance_change_marker, 1.0, _balance_change_fade_in_duration_seconds)
	EffectsUtils.do_fade_with_tween(tw, _balance_change_marker, 0.0, _balance_change_fade_out_duration_seconds).set_delay(_balance_change_stay_seconds)
	await tw.finished
	_balance_change_amount = 0
	_balance_change_label_writer = 0
	

func add_money(amount_to_add : int)->void:
	var original_balance := self.current_balance
	_internal_change_money_amount(amount_to_add)
	EyePiedestal.write_record({"type": "add_money", "amount": amount_to_add, "original_balance": original_balance, "new_balance": self.current_balance})
	

func can_spend_money(amount_to_spend: int)->bool:
	return amount_to_spend <= current_balance
	
func spend_money(amount_to_spend : int)->void:
	assert(can_spend_money(amount_to_spend))
	_internal_change_money_amount(-amount_to_spend)
