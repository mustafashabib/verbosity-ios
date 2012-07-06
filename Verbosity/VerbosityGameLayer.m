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

static int const letterTileTagStart = 1000;

@implementation VerbosityGameLayer
// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
    CCLayerColor *bg = [CCLayerColor layerWithColor:ccc4(255,0,255,255)];
    
    [scene addChild:bg z:0];
	// 'layer' is an autorelease object.
	VerbosityGameLayer *layer = [VerbosityGameLayer node];
    
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}


-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init])) {
        self.isTouchEnabled = YES;
        
        UISwipeGestureRecognizer *swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleCancelWordAttemptGestureRecognizer:)];
        [self addGestureRecognizer:swipeGestureRecognizer];
        swipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight | UISwipeGestureRecognizerDirectionLeft;
        swipeGestureRecognizer.delegate = self;
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGestureRecognizer:)];
        [self addGestureRecognizer:tapGestureRecognizer];
        tapGestureRecognizer.numberOfTapsRequired = 1;
        tapGestureRecognizer.numberOfTouchesRequired = 2; //touch once with two fingers 
        tapGestureRecognizer.delegate = self;
        
        VerbosityGameState* current_state = [VerbosityGameState sharedState];
        [current_state setupGame];
        CGSize winSize = [CCDirector sharedDirector].winSize;
        
        _timeLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%f", current_state.TimeLeft] fontName:@"ArialRoundedMTBold" fontSize:20];
        _timeLabel.position = CGPointMake(winSize.width/2, winSize.height);
        _timeLabel.anchorPoint = CGPointMake(.5f, 1.0f);
        
        _yourScore = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Score: %d", current_state.Score] fontName:@"ArialRoundedMTBold" fontSize:20];
        _yourScore.position = CGPointMake(0, winSize.height);
        _yourScore.anchorPoint = ccp(0,1);
       
        _yourStreak = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Streak: %d", current_state.Streak] fontName:@"ArialRoundedMTBold" fontSize:20];
        _yourStreak.position = CGPointMake(0, winSize.height - 20);
        _yourStreak.anchorPoint = ccp(0,1);
        [self addChild:_timeLabel z:-1];
        [self addChild:_yourScore z:-1];
        [self addChild:_yourStreak z:-1];
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
    for(int i = 0; i < current_state.CurrentLanguage.MaximumWordLength; i++){
        
        if(i>0){
            useSpacing = YES;
        }
        
        NSString* current_letter = (NSString*)[current_state.CurrentWordsAndLetters.Letters objectAtIndex:i];
        LetterTile* lt = [[LetterTile alloc] initWithLetter:current_letter];
        CGSize letterSize = [lt getSize];
        if(useSpacing){
            lt.position =  ccp((i*letterSize.width + letterSize.width *.5f)+widthSpacing*i, winSize.height/2);
        }else{
            lt.position = ccp(i*letterSize.width + letterSize.width *.5f, winSize.height/2);   
        }
               
        [self addChild:lt z:0 tag:letterTileTagStart+i];
    }
    
}

-(void) update:(ccTime)delta{
    bool is_end_of_game = NO;
    [VerbosityGameState sharedState].TimeLeft -= delta;
    if( [VerbosityGameState sharedState].TimeLeft <= 0){
        [VerbosityGameState sharedState].TimeLeft = 0;
        is_end_of_game = YES;
    }
    [_timeLabel setString:[NSString stringWithFormat:@"%f", [VerbosityGameState sharedState].TimeLeft]];
    [_yourScore setString:[NSString stringWithFormat:@"Score: %d", [VerbosityGameState sharedState].Score]];
    [_yourStreak setString:[NSString stringWithFormat:@"Streak: %d", [VerbosityGameState sharedState].Streak]];
    if(is_end_of_game){
        CGSize winSize = [CCDirector sharedDirector].winSize;
        CCLabelTTF *end_game = [CCLabelTTF labelWithString:@"Time's Up!" fontName:@"ArialRoundedMTBold" fontSize:40.0];
        end_game.position = ccp(winSize.width/2, winSize.height/2);
        end_game.anchorPoint = ccp(.5,.5);
        
       [self addChild:end_game];

        [self unscheduleUpdate];
        
    }
    
}

- (void)handleCancelWordAttemptGestureRecognizer:(UISwipeGestureRecognizer*)aGestureRecognizer
{
    CCLOG(@"Got swipe gesture.");
    for(int i =0; i < [VerbosityGameState sharedState].CurrentLanguage.MaximumWordLength; i++){
        int current_tag = letterTileTagStart + i;
        LetterTile* current_letter_tile = (LetterTile*)[self getChildByTag:current_tag];
        [current_letter_tile resetState];
    }
    [VerbosityGameState sharedState].CurrentWordAttempt = @"";
}

- (void) handleTapGestureRecognizer:(UITapGestureRecognizer*)sender{
      if (sender.state == UIGestureRecognizerStateEnded)     
      { 
          NSString* current_word_attempt = [[VerbosityGameState sharedState] CurrentWordAttempt];
          int last_word_score = [[VerbosityGameState sharedState] submitWordAttempt];
          CCLOG(@"Got tap gesture (two fingers tapped once)");
          for(int i =0; i < [VerbosityGameState sharedState].CurrentLanguage.MaximumWordLength; i++){
              int current_tag = letterTileTagStart + i;
              LetterTile* current_letter_tile = (LetterTile*)[self getChildByTag:current_tag];
              [current_letter_tile resetState];
          }
         if(last_word_score > 0){
              //YES
            
              CCLOG(@"YES! Found word with score %d.", last_word_score);
             
             CGSize winSize = [CCDirector sharedDirector].winSize;
             
             
             CCLabelTTF *current_word_label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%@ - %d", current_word_attempt, last_word_score] fontName:@"ArialRoundedMTBold" fontSize:12.0];
             current_word_label.position = ccp(winSize.width/2, winSize.height - winSize.height/3);
             current_word_label.anchorPoint = ccp(.5,.5);
             id fadeOut = [CCFadeOut actionWithDuration:0.33f];
             id death = [CCCallFuncND actionWithTarget:current_word_label  selector:@selector(removeFromParentAndCleanup:) data:(void*)YES];
             id deathAction = [CCSequence actions:fadeOut, death, nil];
             [self addChild:current_word_label];
             
             [current_word_label runAction:deathAction];
          }else{
              //NO
              CCLOG(@"NO! Lost word.");
          }
          [VerbosityGameState sharedState].CurrentWordAttempt = @"";
      }
}

@end
