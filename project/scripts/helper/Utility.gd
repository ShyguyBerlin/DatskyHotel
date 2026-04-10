class_name Utility

static func weighted_select_random(arr,f:Callable):
	var sum=0
	var weights=[]
	weights.resize(len(arr))
	for i in range(len(arr)):
		var weight=f.call(arr[i])
		weights[i]=weight
		sum+=weight
		
	var pull = randf()*sum
	for i in range(len(weights)):
		if pull<weights[i]:
			return arr[i]
		else:
			pull-=weights[i]
	
	return arr[-1]

static func does_script_inherit(script:Script, parent:Script):
	if not script or not parent:
		return false
	while script!=parent:
		print("testing: ",script.get_global_name())
		script=script.get_base_script()
		if not script:
			return false
	print("found: ",script.get_global_name())
	return true
