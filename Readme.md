# Verbosity
## _betel nut games, inc._

A simple word game for the iOS. Make as many words as possible. Uses cocos2d 2.0 and ARC. 

### TO DOs

#### High Priority
* Graphics/Polish
* particle effects
* music
* sound
* settings
* share on facebook
* title screen
* stats

#### Mid Priority
* multiplayer
	* hand on top of hand baseball bat
	* same game, asynch.

#### Low priority (not initial release)
* buy language
* refresh language in case they re-install on another device
----
multiplayer plan

1. facebook connect sdk
2. create app on fb
3. log in 
	- get fb id, store in our db if doesn't exist
	- get friends list, store in our db if they don't exist
	- relate this person and friends
3. request permission from user to post to wall
4. invite friends who dont have the game
	- send message via fb to download the game and link fb account 
5. play friends who have the game
	- send challenge
	- play a round
	- go to step 7
6. play challenges you received
	- play
	- go to step 7
7. update remote game in db to show completion
8. async check db for active games and push notify when new games added, push notify when games ended
9. show historical games and records between you and friends

