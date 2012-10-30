# Verbosity
## _Betel Nut Games, inc._

A simple word game for the iOS. Make as many words as possible. Uses cocos- 2.0 and ARC. 

### TO DOs

#### High Priority
* multiplayer 
    * same game, asynch.
  	* hand on top of hand baseball bat

#### Low priority (not initial release)
* buy language
* refresh language in case they re-install on another device
----
multiplayer plan

- facebook connect sdk
- create app on fb
- log in 
	- get fb id, store in our db if doesn't exist
	- get friends list, store in our db if they don't exist
	- relate this person and friends
- request permission from user to post to wall
- invite friends who dont have the game
	- send message via fb to download the game and link fb account 
- play friends who have the game
	- send challenge
	- play a round
	- go to step 7
- play challenges you received
	- play
	- go to step 7
- update remote game in db to show completion
- async check db for active games and push notify when new games added, push notify when games ended
- show historical games and records between you and friends 