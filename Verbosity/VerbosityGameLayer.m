//
//  VerbosityGameLayer.m
//  Verbosity
//
//  Created by Mustafa Shabib on 4/5/12.
//  Copyright 2012 We Are Mammoth. All rights reserved.
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

@implementation VerbosityGameLayer
// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
  	// 'layer' is an autorelease object.
	VerbosityGameLayer *layer = [VerbosityGameLayer node];
    
    VerbosityHudLayer *hud = [VerbosityHudLayer node];
    CCLayerColor *bg = [CCLayerColor layerWithColor:ccc4(128,128,128,255)];
    
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
        
        [[VerbosityGameState sharedState] setupGame];
        
        [self addLetters];
        [self scheduleUpdate];
    }
    return self;
    
}

-(void) addLetters
{ 
    
    VerbosityGameState* current_state = [VerbosityGameState sharedState];
    CGSize winSize = [CCDirector sharedDirector].winSize;
    float widthSpacing = (winSize.width/current_state.CurrentLanguage.MaximumWordLength+1.0f)/(current_state.CurrentLanguage.MaximumWordLength+1.0f);
    
    BOOL useSpacing = NO;
    srand(time(NULL));
    for(int i = 0; i < current_state.CurrentLanguage.MaximumWordLength; i++){
        
        if(i>0){
            useSpacing = YES;
        }
        
        NSString* current_letter = (NSString*)[current_state.CurrentWordsAndLetters.Letters objectAtIndex:i];
        LetterTile* lt = [[LetterTile alloc] initWithLetter:current_letter];
        LetterSlot* ls = [[LetterSlot alloc] init];
        CGSize letterSize = [lt getSize];
        if(useSpacing){
            lt.position =  ccp((i*letterSize.width + letterSize.width *.5f)+widthSpacing*i, winSize.height*.75);
            ls.position = ccp((i*letterSize.width + letterSize.width * .5f) +widthSpacing*i, winSize.height*.75 - letterSize.height*1.05);
          
        }else{
            lt.position = ccp(i*letterSize.width + letterSize.width *.5f, winSize.height*.75); 
            ls.position = ccp((i*letterSize.width + letterSize.width * .5f), winSize.height*.75 - letterSize.height*1.05);            
        }
        
        float val = arc4random()%5;
        
        CCLOG(@"%f is random", val);
        if(val < 1){
            lt.rotation = 15;
        }else if(val >= 1 && val < 2){
            lt.rotation = 5;
        }else if(val>= 2 && val < 3){
            lt.rotation = -5;
        }
        else
        {
            lt.rotation = -15;
        }
        [lt savePositionAndRotation];
        [self addChild:lt z:1 tag:kLetterTileTagStart+i];
        [self addChild:ls z:0 tag:kLetterSlotID+i];
    }
    
}

-(void) update:(ccTime)delta{
    [[VerbosityGameState sharedState] update:delta];
    if(![[VerbosityGameState sharedState] isGameActive]){
        for(int i =0; i < [VerbosityGameState sharedState].CurrentLanguage.MaximumWordLength; i++){
            int current_tag = kLetterTileTagStart + i;
            LetterTile* current_letter_tile = (LetterTile*)[self getChildByTag:current_tag];
            [current_letter_tile instantResetState:YES];
            
        }
        [self unscheduleUpdate];
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
    CCLOG(@"Got swipe gesture.");
    for(int i =0; i < [VerbosityGameState sharedState].CurrentLanguage.MaximumWordLength; i++){
        int current_tag = kLetterTileTagStart + i;
        LetterTile* current_letter_tile = (LetterTile*)[self getChildByTag:current_tag];
        [current_letter_tile resetState];
    }
    [VerbosityGameState sharedState].CurrentWordAttempt = @"";
}

- (void) handleTapGestureRecognizer:(UITapGestureRecognizer*)sender{
      if (sender.state == UIGestureRecognizerStateEnded)     
      { 
           BOOL is_valid = [[VerbosityGameState sharedState] submitWordAttempt];
          CCLOG(@"Got tap gesture (two fingers tapped once)");
          for(int i =0; i < [VerbosityGameState sharedState].CurrentLanguage.MaximumWordLength; i++){
              int current_tag = kLetterTileTagStart + i;
              LetterTile* current_letter_tile = (LetterTile*)[self getChildByTag:current_tag];
              [current_letter_tile resetState];
          }
         if(is_valid){
              //YES
            
              CCLOG(@"YES! Found word with score");
             
             
             /*add floating score label
             CCLabelTTF *current_word_label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%@ - %d", current_word_attempt, last_word_score] fontName:@"ArialRoundedMTBold" fontSize:12.0];
             current_word_label.position = ccp(winSize.width/2, winSize.height - winSize.height/3);
             current_word_label.anchorPoint = ccp(.5,.5);
             id fadeOut = [CCFadeOut actionWithDuration:0.5f];
             id death = [CCCallFuncND actionWithTarget:current_word_label  selector:@selector(removeFromParentAndCleanup:) data:(void*)YES];
             id deathAction = [CCSequence actions:fadeOut, death, nil];
             [self addChild:current_word_label];
             [current_word_label runAction:deathAction];
              */
             
          }else{
              //NO
              CCLOG(@"NO! Lost word.");
          }
          
                   
          [VerbosityGameState sharedState].CurrentWordAttempt = @"";
      }
}

-(void) shakeLetters{
    CCArray* shakeable_letters = [[CCArray alloc] init];
    NSMutableArray* shakeable_positions = [[NSMutableArray alloc] init];
    
    for(int i =0; i < [VerbosityGameState sharedState].CurrentLanguage.MaximumWordLength; i++){
        int current_tag = kLetterTileTagStart + i;
        
        LetterTile* current_letter_tile = (LetterTile*)[self getChildByTag:current_tag];
        [current_letter_tile instantResetState:NO];
        [VerbosityGameState sharedState].CurrentWordAttempt = @"";
        
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
    
    float THRESHOLD = 2;
    
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
