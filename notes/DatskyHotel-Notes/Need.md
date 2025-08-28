A need is a metric which generally constantly declines and can be replenished or else-way influenced through events or special actions.

The existence of multiple Needs requires a standardized Base class which includes:

A function to indicate whether the need can or must induce a request right now.

A function to handle changes based on time

A function to link to a [[Habitant]] so that signals can be connected and custom need adjusting functions can be bound



If other Needs/ System know of a specific Need, e.g. [[Mood]]. They can affect the need without the need needing a direct way to handle this change. Thus the need base class should have a general number value containing the general need fulfillment value.