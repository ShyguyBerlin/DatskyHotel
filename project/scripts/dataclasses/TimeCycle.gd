extends Resource
class_name TimeCycle

# After this many cycles are done with one time step, cap at the given amount
# 0 means no limit
@export var skip_new_updates_after=0

signal cycles_completed(num:int)

@export var last_fire_unixtime : int

# Should only be read
var progress_current_cycle=0

enum TimeCheckType {
	CHECK_TIME, ## Does support datetime up to day
	CHECK_DAYS ## Does support datetime from day onwards
}

@export var time_type : TimeCheckType

@export var datetime_between_fire : Dictionary

static func datetime_to_seconds(datetime):
	return datetime.get("second",0)+60*(datetime.get("minute",0)+60*(datetime.get("hour",0)+24*datetime.get("day",0)))

func process_from_datetime(datetime:Dictionary):
	print("Time on day 30: ",Time.get_unix_time_from_datetime_dict({"day":30}))
	print("Time on day 31: ",Time.get_unix_time_from_datetime_dict({"day":31}))
	print("Time on day 32: ",Time.get_unix_time_from_datetime_dict({"day":32}))
	if time_type==TimeCheckType.CHECK_DAYS:
		var datediff={}
		var old_date = Time.get_datetime_dict_from_unix_time(last_fire_unixtime)
		var new_time = Time.get_unix_time_from_datetime_dict(datetime)
		datediff["year"]=datetime["year"]-old_date["year"]
		datediff["month"]=datetime["month"]-old_date["month"]+datediff["year"]*12
		
		# Calculate Days through seconds, because there is not a uniform way to find the days in a month/year
		var zero_date=Time.get_datetime_dict_from_unix_time(0)
		zero_date["day"]+=1
		datediff["day"]=floori((new_time-last_fire_unixtime)/Time.get_unix_time_from_datetime_dict(zero_date))
		
	else:
		var new_fire_unixtime=Time.get_unix_time_from_datetime_dict(datetime)
		var time_diff = new_fire_unixtime-last_fire_unixtime
		print("datetime ",datetime_between_fire)
		var cycle_seconds=datetime_to_seconds(datetime_between_fire)
		print("seconds ",cycle_seconds)
		var cycles_to_perform= floor(time_diff/cycle_seconds)
		if skip_new_updates_after>0:
			cycles_to_perform=min(cycles_to_perform,skip_new_updates_after)
		var last_cycle=last_fire_unixtime+cycle_seconds*cycles_to_perform
		last_fire_unixtime=last_cycle
		cycles_completed.emit(cycles_to_perform)

		progress_current_cycle = (time_diff as float%cycle_seconds)/cycle_seconds


func process():
	return process_from_datetime(Time.get_datetime_dict_from_system())
