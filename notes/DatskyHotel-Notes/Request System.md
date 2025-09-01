A Request is a desired interaction of the player with the contents of a room. This is mainly focused on the interaction between player and [[Habitant]], but may also be later expanded to maintenance of complex subsystems.

There must be maximum of concurrent requests presented to the player. This is to make the game less overwhelming, which is exactly not what we want.
### Control
It is not wished that important things happen outside of events. This includes every non subtle [[Relationship]] change as well as personal development 

### List of Requests

Based on needs:

- Fulfillment of Food need

Random:

- Want to meet [[Habitant]] X
- Want to romance [[Habitant]] X (requires good relationship)
- Want new job
- Want new Gender
- Want new Tattoo
- Want new Clothing
- Want new Property (Wealth)

Forced or Random under certain conditions:

- Start new addiction
- Want to forget [[Habitant]] X
### Fulfillment of Requests
A request will present the player with A "I want this" and B "are you willing to give it to me", this either presents the player with a dialog to represent A and either an implicit choice to fulfill B, or a question which will trigger a scene change or minigame when approved.
A is generally represented by a [[RequestMainDialog]] and B is represented by a [[RequestFullfillmentAction]] or [[RequestFullfillmentListener]].
