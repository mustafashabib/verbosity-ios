//
//  VerbosityGameLayer.m
//  Verbosity
//
//  Created by Mustafa Shabib on 4/5/12.
//  Copyright 2012 Betel Nut Games. All rights reserved.
//

#import "VerbosityGameLayer.h"
#import "VerbosityGameState.h"
#import "LetterTile.h"
#import "CCNode+SFGestureRecognizers.h"
#import "VerbosityHudLayer.h"
#import "VerbosityAlertManager.h"
#import "VerbosityAlert.h"
#import "LetterSlot.h"
#import "NSMutableArray+Shuffling.h"
#import "VerbosityGameConstants.h"
#import "NSMutableArray+Stack.h"
#import "FlurryAnalytics.h"

@implementation VerbosityGameLayer
// Helper class method that creates a Scene with the HelloWorldLayer as the only child.

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	NSArray* possibleBottoms = [NSArray arrayWithObjects:
                                @"GrayWave1.png",
                                @"Graywave2.png",
                                @"Graywave3.png",
                                @"Graywave4.png",
                                @"graywave5.png",
                                @"Graywave6.png",nil];
    NSUInteger randomIndex = arc4random() % [possibleBottoms count];
    NSString *randomBottomFilename = [possibleBottoms objectAtIndex:randomIndex];
  	// 'layer' is an autorelease object.
	VerbosityGameLayer *layer = [VerbosityGameLayer node];
    VerbosityHudLayer *hud = [VerbosityHudLayer node];
    CCLayerColor *bg = [CCLayerColor layerWithColor:ccc4(256,256,256,255)];
    NSString* bg_name = @"lightGrayBackground.jpg";
   // if(arc4random()%2 == 0){
    //    bg_name = @"lightGrayBackground.jpg";
   // }
    CCSprite* bg_sprite = [CCSprite spriteWithFile:bg_name];
    
    CCSprite* bg_sprite_bottom = [CCSprite spriteWithFile:randomBottomFilename];
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    bg_sprite.anchorPoint = ccp(0,0);
    bg_sprite_bottom.position = ccp(winSize.width/2, 0);
    [bg addChild:bg_sprite z:0 tag:kBackgroundSpriteTag];
    bg_sprite_bottom.color = ccc3(kBottomWaveColorR,kBottomWaveColorG,kBottomWaveColorB);
    [bg addChild:bg_sprite_bottom z:0 tag:kBackgroundSpriteBottomTag];
    [scene addChild:bg z:0 tag:kBackgroundTag];
	// add layer as a child to scene
	[scene addChild: layer z:0];
	[scene addChild: hud z:1];
	// return the scene
    scene.userData = (__bridge void *)(kGameLayerData);
	return scene;
}

-(void)onEnter{
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
    [super onEnter];
}
-(BOOL)containsTouchLocation:(UITouch*)touch{
    CGPoint touchPoint = [self convertTouchToNodeSpace:touch];
    return (touchPoint.y < _letter_slot_y_position);//only touches below the letter slots count
}

-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init])) {
         [FlurryAnalytics logEvent:@"GameStart"];
        _letter_slot_y_position = 0;
        _gesture_active = NO;
        _start_game = NO;
        CCLabelTTF* loading = [CCLabelTTF labelWithString:@"Finding Letters..." fontName:@"AmerTypewriterITCbyBT-Medium" fontSize:VERBOSITYFONTSIZE(48)];
        CGSize winSize = [CCDirector sharedDirector].winSize;
        loading.ignoreAnchorPointForPosition = NO;
        loading.anchorPoint = ccp(.5,.5);
        loading.position = ccp(winSize.width/2,winSize.height/2);
        [self addChild:loading];
               
        dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
        dispatch_async(queue, ^{
            [[VerbosityGameState sharedState] setupGame];
        
            dispatch_async(dispatch_get_main_queue(),^{
                self.isTouchEnabled = YES;
                self.isAccelerometerEnabled = YES;
                
                /*add swipe and multitap gesture recognizers*/
                UISwipeGestureRecognizer *swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleCancelWordAttemptGestureRecognizer:)];
                [self addGestureRecognizer:swipeGestureRecognizer];
                swipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight | UISwipeGestureRecognizerDirectionLeft;
                swipeGestureRecognizer.delegate = self;
                
                UISwipeGestureRecognizer *swipeGestureRecognizerForShuffle = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleShuffle:)];
                [self addGestureRecognizer:swipeGestureRecognizerForShuffle];
                swipeGestureRecognizerForShuffle.direction = UISwipeGestureRecognizerDirectionDown | UISwipeGestureRecognizerDirectionUp;
                swipeGestureRecognizerForShuffle.delegate = self;
                
                UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGestureRecognizer:)];
                [self addGestureRecognizer:tapGestureRecognizer];
                tapGestureRecognizer.numberOfTapsRequired = 1;
                tapGestureRecognizer.numberOfTouchesRequired = 2; //touch once with two fingers
                tapGestureRecognizer.delegate = self;
                
                       
                /*add shake gesture handler*/
                [[UIAccelerometer sharedAccelerometer] setUpdateInterval:1/60];
                _shake_once = false;
                              
                CCCallBlock* getReady = [CCCallBlock actionWithBlock:^{
                    loading.opacity = 0;
                    [loading setString:@"Get Ready..."];
                    loading.color = ccRED;
                    loading.opacity = 255;
                }];
                CCCallBlock* getSet = [CCCallBlock actionWithBlock:^{
                    loading.opacity = 0;
                    [loading setString:@"Get Set..."];
                    loading.color = ccYELLOW;
                    loading.opacity = 255;
                }];
                CCCallBlock* go = [CCCallBlock actionWithBlock:^{
                    loading.opacity = 0;
                    [loading setString:@"Go!"];
                    loading.color = ccGREEN;
                    loading.opacity = 255;

                }];
                
                CCCallBlock* addLettersCall = [CCCallBlock actionWithBlock:^{
                    [self removeChild:loading cleanup:YES];
                    [self addLetters];
                    _start_game = YES;
                }];
                
                CCSequence* startItUp = [CCSequence actions:[CCDelayTime actionWithDuration:.5],getReady,[CCDelayTime actionWithDuration:.5], getSet, [CCDelayTime actionWithDuration:.5], go, [CCDelayTime actionWithDuration:.5],addLettersCall,nil];
                [loading runAction:startItUp];
                
            });
        });
        
        [self scheduleUpdate];
    }
    return self;
}

-(void) addLetters
{ 
    
    VerbosityGameState* current_state = [VerbosityGameState sharedState];
    CGSize winSize = [CCDirector sharedDirector].winSize;
   // float widthSpacing = (winSize.width/current_state.Stats.CurrentLanguage.MaximumWordLength+1.0f)/(current_state.Stats.CurrentLanguage.MaximumWordLength+1.0f);
    //dummy tile just to get size
    
    
    LetterTile* dummy_tile = [[LetterTile alloc] initWithLetter:@"A"];
    
    
    _letter_positions = [[CCArray alloc] initWithCapacity:current_state.Stats.CurrentLanguage.MaximumWordLength];
    CGSize tile_size = [dummy_tile getSize];
    CCLOG(@"%f is winsize width", winSize.width);
    
    float widthSpacing =  (winSize.width - (current_state.Stats.CurrentLanguage.MaximumWordLength * tile_size.width)) / (current_state.Stats.CurrentLanguage.MaximumWordLength + 1);
    
    
    for(int i = 0; i < current_state.Stats.CurrentLanguage.MaximumWordLength; i++){
                
        NSString* current_letter = (NSString*)[current_state.CurrentWordsAndLetters.Letters objectAtIndex:i];
        LetterTile* lt = [[LetterTile alloc] initWithLetter:current_letter];
        LetterSlot* ls = [[LetterSlot alloc] init];
        int tile_number = i +1;
        //position =
        //(widthSpacing + letterSize.width)*i + widthSpacing;
        //float x = ((widthSpacing + letterSize.width)*i + widthSpacing) + letterSize.width*.5;
        float x = (tile_number*widthSpacing) + ((tile_number - 1)*tile_size.width) + (.5*tile_size.width);
        lt.position =  ccp(x, winSize.height*.75);
        
        ls.position = ccp(x, winSize.height*.75 - tile_size.height*1.25);
        _letter_slot_y_position = winSize.height*.75 - tile_size.height*1.25 - .5*tile_size.height;
        [_letter_positions addObject:[NSValue valueWithCGPoint:lt.position]];
        
        [lt setStartPosition:lt.position];
        [self addChild:lt z:1 tag:kLetterTileTagStart+i];
        [self addChild:ls z:0 tag:kLetterSlotID+i];
    }
    
}

-(void) update:(ccTime)delta{
    if([VerbosityGameState sharedState].CurrentGameState == kGameStateReady && _start_game){
        [[VerbosityGameState sharedState] update:delta];
        if(![[VerbosityGameState sharedState] isGameActive]){
            for(int i =0; i < [VerbosityGameState sharedState].Stats.CurrentLanguage.MaximumWordLength; i++){
                int current_tag = kLetterTileTagStart + i;
                LetterTile* current_letter_tile = (LetterTile*)[self getChildByTag:current_tag];
                [current_letter_tile instantResetState:YES];
                
            }
            [[VerbosityGameState sharedState] clearWordAttempt];
              [VerbosityGameState sharedState].CurrentGameState = kGameStateReady;
            [self unscheduleUpdate];
            _start_game = NO;
        }
    }
}


/* gesture recognizer handlers*/

- (void)handleShuffle:(UISwipeGestureRecognizer*)aGestureRecognizer
{
    if([VerbosityGameState sharedState].CurrentGameState != kGameStateReady){
        return;
    }
    CCLOG(@"Shaking Letters");
    [self shakeLetters];
}


- (void)handleCancelWordAttemptGestureRecognizer:(UISwipeGestureRecognizer*)aGestureRecognizer
{
    _gesture_active = YES;
    if([VerbosityGameState sharedState].CurrentGameState != kGameStateReady){
        return;
    }
    CCLOG(@"Got swipe gesture.");
    if([[VerbosityGameState sharedState].CurrentWordAttempt length] == 0){
        return;
    }
    
    for(int i =0; i < [VerbosityGameState sharedState].Stats.CurrentLanguage.MaximumWordLength; i++){
        int current_tag = kLetterTileTagStart + i;
        LetterTile* current_letter_tile = (LetterTile*)[self getChildByTag:current_tag];
        [current_letter_tile resetState];
    }
    
    [[VerbosityGameState sharedState] clearWordAttempt];
    _gesture_active = NO;
}

- (void) handleTapGestureRecognizer:(UITapGestureRecognizer*)sender{
    if([VerbosityGameState sharedState].CurrentGameState != kGameStateReady){
        return;
    }
    
    _gesture_active = YES;
    if (sender.state == UIGestureRecognizerStateEnded && [[VerbosityGameState sharedState].CurrentWordAttempt length] > 1)
      { 
           BOOL is_valid = [[VerbosityGameState sharedState] submitWordAttempt];
          CCLOG(@"Got tap gesture (two fingers tapped once)");
          for(int i =0; i < [VerbosityGameState sharedState].Stats.CurrentLanguage.MaximumWordLength; i++){
              int current_tag = kLetterTileTagStart + i;
              LetterTile* current_letter_tile = (LetterTile*)[self getChildByTag:current_tag];
              [current_letter_tile resetState];
          }
          
         if(is_valid){
              //YES
            
              CCLOG(@"YES! Found word with score");
             
             
          }else{
              //NO
              CCLOG(@"NO! Lost word.");
          }
          
                   
          [[VerbosityGameState sharedState] clearWordAttempt];
          _gesture_active = NO;
      }
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    return [self containsTouchLocation:touch];
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    
    // If it weren't for the TouchDispatcher, you would need to keep a reference
    // to the touch from touchBegan and check that the current touch is the same
    // as that one.
    // Actually, it would be even more complicated since in the Cocos dispatcher
    // you get NSSets instead of 1 UITouch, so you'd need to loop through the set
    // in each touchXXX method.
    
    return;
    
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    if([VerbosityGameState sharedState].CurrentGameState != kGameStateReady){
        return;
    }

       
    if ([[VerbosityGameState sharedState].CurrentWordAttempt length] > 1
        && [self containsTouchLocation:touch])
    {
        BOOL is_valid = [[VerbosityGameState sharedState] submitWordAttempt];
        CCLOG(@"Got tap gesture (one finger tapped below letters)");
        for(int i =0; i < [VerbosityGameState sharedState].Stats.CurrentLanguage.MaximumWordLength; i++){
            int current_tag = kLetterTileTagStart + i;
            LetterTile* current_letter_tile = (LetterTile*)[self getChildByTag:current_tag];
            [current_letter_tile resetState];
        }
        
        if(is_valid){
            //YES
            
            CCLOG(@"YES! Found word with score");
            
            
        }else{
            //NO
            CCLOG(@"NO! Lost word.");
        }
        
        
        [[VerbosityGameState sharedState] clearWordAttempt];
    }
}


-(void) shakeLetters{
    if([VerbosityGameState sharedState].CurrentGameState != kGameStateReady){
        return;
    }
    CCArray* shakeable_letters = [[CCArray alloc] initWithCapacity:[VerbosityGameState sharedState].Stats.CurrentLanguage.MaximumWordLength];
    for(int i =0; i < [VerbosityGameState sharedState].Stats.CurrentLanguage.MaximumWordLength; i++){
        
        int current_tag = kLetterTileTagStart + i;
        
        LetterTile* current_letter_tile = (LetterTile*)[self getChildByTag:current_tag];
       
        CCLOG(@"Adding position %f,%f as shakeable position", current_letter_tile.position.x, current_letter_tile.position.y);
        [shakeable_letters addObject:current_letter_tile];
        [current_letter_tile instantResetState:NO];
    }
    NSMutableArray* shakeable_positions = [[NSMutableArray alloc] initWithCapacity: [VerbosityGameState sharedState].Stats.CurrentLanguage.MaximumWordLength];
    for(int i = 0; i < [_letter_positions count]; i++){
        [shakeable_positions addObject:[_letter_positions objectAtIndex:i]];
    } 
    [shakeable_positions shuffle];

    for(int i = 0; i < [shakeable_positions count]; i++)
    {
        CGPoint new_position = [(NSValue*)[shakeable_positions objectAtIndex:i] CGPointValue];
        CCMoveTo* shuffle_action = [[CCMoveTo alloc] initWithDuration:.0625 position:new_position];
        CCCallBlockN* save_position = [CCCallBlockN actionWithBlock:^(CCNode *node) {
            //code
            [((LetterTile*)node) setStartPosition:new_position];
        }];
        CCSequence* seq = [CCSequence actions:shuffle_action,save_position, nil];
        LetterTile* current_tile = (LetterTile*)[shakeable_letters objectAtIndex:i];
        [current_tile runAction:seq];
    }
}


-(void) accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
    if([VerbosityGameState sharedState].CurrentGameState != kGameStateReady){
        return;
    }
    float THRESHOLD = 1.5;
    
    if (acceleration.x > THRESHOLD || acceleration.x < -THRESHOLD || 
        acceleration.y > THRESHOLD || acceleration.y < -THRESHOLD ||
        acceleration.z > THRESHOLD || acceleration.z < -THRESHOLD) 
    {
        if (!_shake_once) {
            _shake_once = true;
        }
        [self shakeLetters];
    }
    else {
        _shake_once = false;
    }
}


@end
