@icon("res://Assets/Images/SVG/ShirtIcon.svg")
@tool

extends Resource
class_name Clothing


enum BodyPart {
	HEAD=1,
	NECK=2,
	TORSO=3,
	HIP=4,
	ARM_R=5,
	FOREARM_R=6,
	HAND_R=7,
	ARM_L=8,
	FOREARM_L=9,
	HAND_L=10,
	LEG_R=11,
	SHIN_R=12,
	FOOT_R=13,
	LEG_L=14,
	SHIN_L=16,
	FOOT_L=17
}

enum ClothingLayer {
	SKIN=1,
	HEADWEAR=2,
	FACIAL=3,
	TORSOCOVER=4,
	TORSOOUTER=5,
	PANTS=6,
	SHOES=7,
	HAND=8
}

@export var tint : Color = Color.WHITE
@export var parts : Array[ClothingPart]

func get_draw_infos(bodytype : HabitantOutfit.BodyType):
	var arr : Array=[]
	for i in parts:
		if i==null:
			continue
		arr.append(i.get_draw_info(bodytype,self))
	return arr
