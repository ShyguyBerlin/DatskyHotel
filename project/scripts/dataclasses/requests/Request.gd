@abstract
extends Resource
class_name Request

enum RequestFulfillmentType {
	## Quest
	DIALOG,
	GIFT
}

signal fulfilled(req : Request)

# Not sure if this is necessary as the request itself is mostly reponsible for handling its completion
@export var type : RequestFulfillmentType
@export var priority : int
@export var title : String
@export var origin : Room

# This can be overwritten by subclasses, so that a request can deny its usage if other request are(n't) already used
# this way, a "only one instance of this request per hotel" can be achieved
func can_be_added_to_accepted_request_list(accepted_requests:Array[Request]) -> bool:
	return true

@abstract func accept() -> void

func fulfill():
	fulfilled.emit(self)
