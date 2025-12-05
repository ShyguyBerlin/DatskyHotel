# GdUnit generated TestSuite
class_name TimeCycleTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source: String = 'res://scripts/dataclasses/TimeCycle.gd'

func test_reset_check_time() -> void:
	var testCycle= TimeCycle.new()
	testCycle.time_type=TimeCycle.TimeCheckType.CHECK_TIME
	
	for i in range(10):
		var unixtime = randi()
		var datetime=Time.get_datetime_dict_from_unix_time(unixtime)
		testCycle.reset(datetime)
		assert_int(testCycle.last_fire_unixtime).is_equal(unixtime)

func test_process_from_datetime_check_time() -> void:
	var testCycle= TimeCycle.new()
	testCycle.time_type=TimeCycle.TimeCheckType.CHECK_TIME
	
	var unixtime=0
	var zero_datetime=Time.get_datetime_dict_from_unix_time(unixtime)
	testCycle.datetime_between_fire={"minute":1}
	testCycle.reset(zero_datetime)
	
	assert_float(testCycle.progress_current_cycle).is_equal_approx(0.0,0.0)
	assert_int(testCycle.last_fire_unixtime).is_equal(0)

	var unixtime1=30
	var datetime1=Time.get_datetime_dict_from_unix_time(unixtime1)
	
	testCycle.process_from_datetime(datetime1)
	assert_float(testCycle.progress_current_cycle).is_equal(0.5)
	assert_int(testCycle.last_fire_unixtime).is_equal(0)

	unixtime1=60
	datetime1=Time.get_datetime_dict_from_unix_time(unixtime1)
	
	testCycle.process_from_datetime(datetime1)
	assert_signal(testCycle).is_emitted("cycles_completed",[1])
	assert_float(testCycle.progress_current_cycle).is_equal(0.0)
	assert_int(testCycle.last_fire_unixtime).is_equal(60)
	
	unixtime1=180
	datetime1=Time.get_datetime_dict_from_unix_time(unixtime1)
	
	testCycle.process_from_datetime(datetime1)
	assert_signal(testCycle).is_emitted("cycles_completed",[2])
	assert_float(testCycle.progress_current_cycle).is_equal(0.0)
	assert_int(testCycle.last_fire_unixtime).is_equal(180)
	
