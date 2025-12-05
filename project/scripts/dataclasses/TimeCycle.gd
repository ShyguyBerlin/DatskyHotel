extends Resource
class_name TimeCycle

# After this many cycles are done with one time step, cap at the given amount
# 0 means no limit
@export var skip_new_updates_after=0

signal cycles_completed(num:int)

@export var last_fire_unixtime : int

# Should only be read
var progress_current_cycle:float=0

enum TimeCheckType {
	CHECK_TIME, ## Converts timespan to seconds and checks if that amount of time has passed
	CHECK_DAYS ## Checks for an appropriate difference in each time scale, for now resets to the current time after doing a cycle, not more than one cycle at a time
}

@export var time_type : TimeCheckType

@export var datetime_between_fire : Dictionary

# Set last_cycle without causing any cycle completions, might bug for the CHECK_DAYS cycles
func reset(datetime):
	datetime=datetime.duplicate()
	if time_type==TimeCheckType.CHECK_DAYS:
		datetime["hour"]=0
		datetime["minute"]=0
		datetime["second"]=0
	var unixtime=Time.get_unix_time_from_datetime_dict(datetime)
	last_fire_unixtime=unixtime
	progress_current_cycle=0

static func datetime_to_seconds(datetime):
	return datetime.get("second",0)+60*(datetime.get("minute",0)+60*(datetime.get("hour",0)+24*datetime.get("day",0)))

func process_from_datetime(datetime:Dictionary):
	datetime=datetime.duplicate()
	if time_type==TimeCheckType.CHECK_DAYS:
		datetime["hour"]=0
		datetime["minute"]=0
		datetime["second"]=0
		
		var datediff={}
		var old_date = Time.get_datetime_dict_from_unix_time(last_fire_unixtime)
		var new_time = Time.get_unix_time_from_datetime_dict(datetime)
		datediff["year"]=datetime["year"]-old_date["year"]
		datediff["month"]=datetime["month"]-old_date["month"]+datediff["year"]*12
		
		# Calculate Days through seconds, because there is not a uniform way to find the days in a month/year
		var zero_date=Time.get_datetime_dict_from_unix_time(0)
		zero_date["day"]+=1
		datediff["day"]=floori((new_time-last_fire_unixtime)/Time.get_unix_time_from_datetime_dict(zero_date))
		
		if datediff["day"]>=datetime_between_fire.get("day",0) and datediff["month"]>=datetime_between_fire.get("month",0) and datediff["year"]>=datetime_between_fire.get("year",0):
			var last_cycle=new_time
			last_fire_unixtime=last_cycle
			cycles_completed.emit(1)
			progress_current_cycle=0
		else:
			var min_prog=1
			if datetime_between_fire.get("day",0)!=0:
				min_prog=min(min_prog,datediff["day"]/datetime_between_fire.get("day"))
			if datetime_between_fire.get("month",0)!=0:
				min_prog=min(min_prog,datediff["month"]/datetime_between_fire.get("month"))
			if datetime_between_fire.get("year",0)!=0:
				min_prog=min(min_prog,datediff["year"]/datetime_between_fire.get("year"))


	else:
		var new_fire_unixtime=Time.get_unix_time_from_datetime_dict(datetime)
		var time_diff = new_fire_unixtime-last_fire_unixtime
		var cycle_seconds=datetime_to_seconds(datetime_between_fire)
		var cycles_to_perform= floor(time_diff/cycle_seconds)
		if skip_new_updates_after>0:
			cycles_to_perform=min(cycles_to_perform,skip_new_updates_after)
		var last_cycle=last_fire_unixtime+cycle_seconds*cycles_to_perform
		last_fire_unixtime=last_cycle
		if cycles_to_perform>0:
			cycles_completed.emit(cycles_to_perform)

		progress_current_cycle = (time_diff as int%cycle_seconds)/(cycle_seconds as float)


func process():
	return process_from_datetime(Time.get_datetime_dict_from_system())
