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
    [bg addChild:bg_sprite_bottom z:0 tag:kBackgroundSpriteBottomTag];
    [scene addChild:bg z:0 tag:kBackgroundTag];
	// add layer as a child to scene
	[scene addChild: layer z:0];
	[scene addChild: hud z:1];
	// return the scene
	return scene;
}


-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init])) {
        _start_game = NO;
        CCLabelTTF* loading = [CCLabelTTF labelWithString:@"Finding Letters..." fontName:@"AmerTypewriterITCbyBT-Medium" fontSize:48];
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
                
                UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGestureRecognizer:)];
                [self addGestureRecognizer:tapGestureRecognizer];
                tapGestureRecognizer.numberOfTapsRequired = 1;
                tapGestureRecognizer.numberOfTouchesRequired = 2; //touch once with two fingers
                tapGestureRecognizer.delegate = self;
                /*
                 UILongPressGestureRecognizer *longrec = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
                 [self addGestureRecognizer:longrec];
                 */
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
          
        
        [lt savePosition];
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
            [self unscheduleUpdate];
            _start_game = NO;
        }
    }
}


/* gesture recognizer handlers*/
/*
- (void)handleLongPress:(UILongPressGestureRecognizer*)aGestureRecognizer{
    if(aGestureRecognizer.state == UIGestureRecognizerStateEnded){
        CCLOG(@"Got long touch.");
        [self shakeLetters];
    }
}
 */
- (void)handleCancelWordAttemptGestureRecognizer:(UISwipeGestureRecognizer*)aGestureRecognizer
{
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
}

- (void) handleTapGestureRecognizer:(UITapGestureRecognizer*)sender{
    if([VerbosityGameState sharedState].CurrentGameState != kGameStateReady){
        return;
    }
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
      }
}

-(void) shakeLetters{
    
    CCArray* shakeable_letters = [[CCArray alloc] init];
    NSMutableArray* shakeable_positions = [[NSMutableArray alloc] init];
    
    for(int i =0; i < [VerbosityGameState sharedState].Stats.CurrentLanguage.MaximumWordLength; i++){
        int current_tag = kLetterTileTagStart + i;
        
        LetterTile* current_letter_tile = (LetterTile*)[self getChildByTag:current_tag];
       
        [current_letter_tile instantResetState:NO];
        [[VerbosityGameState sharedState] clearWordAttempt];
        
        [shakeable_positions addObject:[NSValue valueWithCGPoint:current_letter_tile.position]];
        [shakeable_letters addObject:current_letter_tile];
    }
    
    [shakeable_positions shuffle];
    
    for(int i = 0; i < [shakeable_letters count]; i++)
    {
        CGPoint new_position = [(NSValue*)[shakeable_positions objectAtIndex:i] CGPointValue];
        CCMoveTo* shuffle_action = [[CCMoveTo alloc] initWithDuration:.125 position:new_position];
        LetterTile* current_tile = (LetterTile*)[shakeable_letters objectAtIndex:i];
        [current_tile runAction:shuffle_action];
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
