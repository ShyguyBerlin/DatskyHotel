extends Node

# Timespan for stuff which should change between sessions
# Should be normally a day long
signal LongCycleTick(ticks:int)
signal LongCycleProgress(progress:float)
var long_cycle:TimeCycle

# Timespan for stuff which should change seemingly continuous, but not fast
# Stuff that does not need to update very regularly, should fit most needs
# At most an hour
signal MediumCycleTick(ticks:int)
signal MediumCycleProgress(progress:float)
var medium_cycle:TimeCycle

# Timespan for rapidly changing stuff, and stuff on which the player is dependent to interact with
# This primarily affects the request cycle
# At most a few minutes
signal ShortCycleTick(ticks:int)
signal ShortCycleProgress(progress:float)
var short_cycle:TimeCycle

func _ready():
	var cycles=SaveSystem.save.gametimecycles
	var newgame=false
	if len(cycles)!=3:
		cycles.clear()
		long_cycle=TimeCycle.new()
		medium_cycle=TimeCycle.new()
		short_cycle=TimeCycle.new()
		cycles.append_array([long_cycle,medium_cycle,short_cycle])
		newgame=true
	else:
		long_cycle=cycles[0]
		medium_cycle=cycles[1]
		short_cycle=cycles[2]
	long_cycle.datetime_between_fire={"day":1}
	long_cycle.time_type=TimeCycle.TimeCheckType.CHECK_DAYS

	medium_cycle.datetime_between_fire={"minute":20}
	medium_cycle.time_type=TimeCycle.TimeCheckType.CHECK_TIME

	short_cycle.datetime_between_fire={"second":10}
	short_cycle.time_type=TimeCycle.TimeCheckType.CHECK_TIME
	
	long_cycle.cycles_completed.connect(LongCycleTick.emit)
	medium_cycle.cycles_completed.connect(MediumCycleTick.emit)
	short_cycle.cycles_completed.connect(ShortCycleTick.emit)
	
	if newgame:
		reset() # TODO this should be done when a new game is started, needs to be adjusted when implementing save system

func reset():
	var datetime= Time.get_datetime_dict_from_system()
	long_cycle.reset(datetime)
	medium_cycle.reset(datetime)
	short_cycle.reset(datetime)

var _last_update : Dictionary = {}

func _process(delta: float) -> void:
	var cycles : Array[TimeCycle]=[long_cycle,medium_cycle,short_cycle]
	var cycle_progress_signals : Array[Signal] = [LongCycleProgress,MediumCycleProgress,ShortCycleProgress]
	var datetime= Time.get_datetime_dict_from_system()
	if datetime==_last_update:
		return
	_last_update=datetime
	for i in range(len(cycles)):
		cycles[i].process_from_datetime(datetime)
		cycle_progress_signals[i].emit(cycles[i].progress_current_cycle)
	
