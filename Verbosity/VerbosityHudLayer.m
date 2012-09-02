//
//  VerbosityHudLayer.m
//  Verbosity
//
//  Created by Mustafa Shabib on 7/6/12.
//  Copyright (c) 2012 Betel Nut Games. All rights reserved.
//

#import "VerbosityHudLayer.h"
#import "VerbosityGameLayer.h"
#import "VerbosityGameState.h"
#import "VerbosityAlertManager.h"
#import "VerbosityGameConstants.h"
#import "GameOverLayer.h"
#import "SimpleAudioEngine.h"
#import "PauseGameLayer.h"
#import "CCLabelButton.h"

@interface VerbosityHudLayer (hidden)
    
- (void) _showNewAlert:(NSString*)labelString andColor:(ccColor3B) color;
-(void) _colorBottomForAlertType:(const int)alert_type;
-(void) _tintBottomToRed:(int)red andGreen:(int)green andBlue:(int)blue;
-(void) _flashBGtoRed:(int)red andGreen:(int)green andBlue:(int)blue;
- (void)restartTapped:(id)sender ;
-(void) _processAlertForDisplay:(VerbosityAlert *)alert;

@end
@implementation VerbosityHudLayer

/*private methods*/
-(void) _showNewAlert:(NSString*)labelString andColor:(ccColor3B) color{
  

    //new way without background
        CCLabelTTF* label = [[CCLabelTTF alloc] initWithString:labelString fontName:@"AmerTypewriterITCbyBT-Medium" fontSize:VERBOSITYFONTSIZE(14) ];
    
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    label.anchorPoint = ccp(.5,0);
    label.color = color;
    
    
    if([_current_labels count] == kMaxAlertsToShow){ //remove the oldest alert
        CCLabelTTF* last_label = (CCLabelTTF*)[_current_labels objectAtIndex:0];
        [self removeChild:last_label cleanup:YES];
        [_current_labels removeObjectAtIndex:0];
    }
    
    
    [_current_labels addObject:label];
    int alpha_multiply = (int)(255.0f/kMaxAlertsToShow);
    CGSize biggest_size = CGSizeMake(0, 0);
    for(int i = [_current_labels count]-1; i >= 0;i--){//start at newest
        CCLabelTTF* current_alert_label = [_current_labels objectAtIndex:i];
        if(current_alert_label.contentSize.width > biggest_size.width){
            biggest_size = current_alert_label.contentSize;
        }
    }
    CCLayerColor* bg_layer = [CCLayerColor layerWithColor:ccc4(64, 64, 64, 128)];
    bg_layer.contentSize = CGSizeMake(biggest_size.width, biggest_size.height*[_current_labels count]);
    bg_layer.position = ccp(winSize.width/2, 0);
    bg_layer.anchorPoint = ccp(.5,0);
    bg_layer.ignoreAnchorPointForPosition = NO;
    [self removeChildByTag:987356 cleanup:YES];
    [self addChild:bg_layer z:0 tag:987356];
    
    for(int i = [_current_labels count]-1; i >= 0;i--){//start at newest
        int age = [_current_labels count]-1 - i;
        
        CCLabelTTF* current_alert_label = [_current_labels objectAtIndex:i];
        current_alert_label.opacity = 255 -(alpha_multiply*age);
        CGPoint destination = ccp(winSize.width/2, age*current_alert_label.contentSize.height);
        if(age==0){
            current_alert_label.position = ccp(winSize.width/2,-current_alert_label.contentSize.height); //off screen
            [self addChild:current_alert_label];
        }
    CCMoveTo *moveToAction = [CCMoveTo actionWithDuration:.25 position:destination];
    [current_alert_label runAction:moveToAction];
    }
}

-(void) _colorBottomForAlertType:(const int)alert_type{
    switch(alert_type){
        case kColdStreakEnded:
        case kHotStreakEnded:
             
            [self _tintBottomToRed:
             kBottomWaveColorR andGreen:kBottomWaveColorG andBlue:kBottomWaveColorB];
            break;
        case kColdStreakStarted:
            [self _tintBottomToRed:0 andGreen:0 andBlue:255];
            break;
        case kHotStreakStarted:
            //orange
            [self _tintBottomToRed:255 andGreen:127 andBlue:0];
            break;
        default:
            break;
            
    }
}

-(void) _tintBottomToRed:(int)red andGreen:(int)green andBlue:(int)blue{
    CCLayerColor* bg = (CCLayerColor*) [[self parent] getChildByTag:kBackgroundTag];
    CCSprite* bg_sprite_bottom = (CCSprite*)[bg getChildByTag:kBackgroundSpriteBottomTag];
    CCTintTo* tintColor = [[CCTintTo alloc] initWithDuration:.0625 red:red green:green blue:blue];
    
    [bg_sprite_bottom stopAllActions];
    [bg_sprite_bottom runAction:tintColor];
    
}
-(void) _flashBGtoRed:(int)red andGreen:(int)green andBlue:(int)blue
{
    
    CCLayerColor* bg = (CCLayerColor*) [[self parent] getChildByTag:kBackgroundTag];
    CCSprite* bg_sprite = (CCSprite*)[bg getChildByTag:kBackgroundSpriteTag];
    [bg_sprite stopAllActions];
    CCTintTo* fadeToNormalColor = [[CCTintTo alloc] initWithDuration:.06126 red:bg_sprite.color.r green:bg_sprite.color.g blue:bg_sprite.color.b];
    
    CCTintTo* fadeColor = [[CCTintTo alloc] initWithDuration:.125 red:red green:green blue:blue];
    CCSequence* sequence = [CCSequence actions:fadeColor, fadeToNormalColor, fadeColor, fadeToNormalColor, nil];
    [bg_sprite runAction:sequence];
    
}



-(id) init {
    if( (self=[super init]))
    {
        
        CGSize winSize = [CCDirector sharedDirector].winSize;
        VerbosityGameState* current_state = [VerbosityGameState sharedState];
        _current_labels = [[NSMutableArray alloc] init];
        _timeLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d sec.", (int)current_state.TimeLeft] fontName:@"AmerTypewriterITCbyBT-Medium" fontSize:VERBOSITYFONTSIZE(28)];
        _timeLabel.position = CGPointMake(winSize.width/2, winSize.height);
        _timeLabel.anchorPoint = CGPointMake(.5f, 1.0f);
    
        _timeLabel.color = kTimerColor;
        
        _yourScore = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"score: %ld", current_state.Stats.Score] fontName:@"AmerTypewriterITCbyBT-Medium" fontSize:VERBOSITYFONTSIZE(14)];
        _yourScore.position = CGPointMake(5, winSize.height - 5);
        _yourScore.anchorPoint = ccp(0,1);
        _yourWords = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"found: %d words", current_state.Stats.TotalWordsFound] fontName:@"AmerTypewriterITCbyBT-Medium" fontSize:VERBOSITYFONTSIZE(14)];
        _yourWords.position = CGPointMake(5, winSize.height - _yourScore.contentSize.height - 10);
        _yourWords.anchorPoint = ccp(0,1);
      
                 _yourScore.color = kScoreColor;
          _yourWords.color = kScoreColor;
    
        //pause button
        
        CCLabelButton *pause = [[CCLabelButton alloc] initWithString:@"pause" andFontName:@"AmerTypewriterITCbyBT-Medium" andFontSize:VERBOSITYFONTSIZE(14) andTouchesEndBlock:^{
            [[SimpleAudioEngine sharedEngine] playEffect:@"Letter_click.wav"];
            [VerbosityGameState sharedState].CurrentGameState = kGameStatePaused;
            [[CCDirector sharedDirector] pushScene: [CCTransitionMoveInT transitionWithDuration:.25f scene:[PauseGameLayer scene]]];
        }];
        pause.color = kPauseLabelColor;
        [pause setAnchorPoint:ccp(1,1)];
        [pause setPosition:ccp(winSize.width-5,winSize.height-5)];
        [pause setVisible:NO];
        [self addChild:pause z:2 tag:kPauseButtonTag];
        
              
        _yourStreak = [CCLabelTTF labelWithString:@"streak:" fontName:@"AmerTypewriterITCbyBT-Medium" fontSize:VERBOSITYFONTSIZE(14)];
        
        [_yourStreak setPosition:ccp(winSize.width-5, winSize.height-5 - pause.contentSize.height)];
        _yourStreak.anchorPoint = ccp(1,1);
        _yourStreak.color = kScoreColor;
        [_yourStreak setVisible:NO];

        
        [self addChild:_timeLabel z:1];
        [self addChild:_yourScore z:1];
        [self addChild:_yourWords z:1];
        [self addChild:_yourStreak z:1];
        [self scheduleUpdate];
    }
    return self;
}

- (void)restartTapped:(id)sender {
    
    // Reload the current scene
    CCScene *scene = [VerbosityGameLayer scene];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionZoomFlipX transitionWithDuration:0.5 scene:scene]];
    
}

-(void) _processAlertForDisplay:(VerbosityAlert *)alert{

    [self _colorBottomForAlertType:alert.AlertType];
    switch (alert.AlertType) {
            
        case kMaxWordLenFound:
        {
            NSString* alert_str = (NSString*)alert.Data;
            
            CCLOG(alert_str);
            [self _showNewAlert:alert_str andColor:ccc3(0, 255, 0)];
            [[SimpleAudioEngine sharedEngine] playEffect:@"seven_letter.wav"];
            
            break;
        }

        case kFoundRareWord:
        {
            NSString* word = (NSString*)alert.Data;
            
            CCLOG(@"Found rare word %@", word);
            [self _showNewAlert:[NSString stringWithFormat:@"Rare word! (%@)", word] andColor:ccc3(0, 255, 0)];
            [[SimpleAudioEngine sharedEngine] playEffect:@"ding.wav"];            
            break;
        }
        case kDuplicateWord:
        {
            CCLOG(@"Duplicate word.");
            NSString* word = (NSString*)alert.Data;
            [self _showNewAlert:[NSString stringWithFormat:@"Duplicate word! (%@)", word] andColor:ccc3(255, 0, 0)];
            [[SimpleAudioEngine sharedEngine] playEffect:@"already_got_word.wav"];
            break;
        }
        case kScoreIncreased:
        {
            NSNumber* current_word_score = (NSNumber*)alert.Data;
            CCLOG(@"Score increased by %d.", [current_word_score intValue]);
            
            //change score label
            //particle effects
            //color of layer
            NSString *score_increased_sound_file = @"Word_accept.wav";
            if(arc4random()%2 == 0){
                score_increased_sound_file = @"Word_accept-2.wav";
            }
             [[SimpleAudioEngine sharedEngine] playEffect:score_increased_sound_file];
            [self _flashBGtoRed:0 andGreen:255 andBlue:0];
        break;
            
        }
        case kWordAttemptUpdated:{
            NSString* current_word = (NSString*)alert.Data;
            CCLOG(@"word attempt updated, it's now %@", current_word);
            [[SimpleAudioEngine sharedEngine] playEffect:@"Letter_click.wav"];
            
            break;
        }
        case kHotStreakStarted:{
            CCLOG(@"hot streak started");
            [self _showNewAlert:@"Hot streak!" andColor:ccORANGE];
            
            break; 
        }
        case kColdStreakEnded:
        {
            CCLOG(@"cold streak ended.");
            [[SimpleAudioEngine sharedEngine] playEffect:@"icebreak.wav"];
            
            [self _showNewAlert:@"Cold streak ended!" andColor:ccc3(255, 255, 255)];
            
            break; 

        }
        case kColdStreakStarted:
        {
            CCLOG(@"cold streak started.");
            
            [self _showNewAlert:@"Cold streak!" andColor:ccc3(0, 0, 255)];
            
            
            break;
            
        }
        case kHotStreakEnded:{
            CCLOG(@"streak ended.");
            [self _showNewAlert:@"Hot streak ended!" andColor:ccRED];
            [[SimpleAudioEngine sharedEngine] playEffect:@"hotstreak_end.wav"];
            [_yourStreak setColor:ccRED];
            break; 
        }
        case kTimeRunningOut:{
            CCLOG(@"time running out.");
            CCLayerColor* bg = (CCLayerColor*) [[self parent] getChildByTag:kBackgroundTag];
            [bg stopAllActions];
            CCSprite* bg_sprite = (CCSprite*)[bg getChildByTag:kBackgroundSpriteTag];
            [bg_sprite stopAllActions];
            
            CCTintTo* fadeToNormal = [CCTintTo actionWithDuration:.5 red:bg_sprite.color.r green:bg_sprite.color.g blue:bg_sprite.color.b];
            CCTintTo* fadeToYellow = [[CCTintTo alloc] initWithDuration:.5 red:255 green:255 blue:0];
            CCSequence* sequence = [CCSequence actions:fadeToYellow, fadeToNormal, nil];
            
            CCRepeat* repeat = [CCRepeat actionWithAction:sequence times:5];
            
            
            [bg_sprite runAction:repeat];
            
            break;
        }
        case kTimeNearlyDone:{
            
            CCLOG(@"time nearly done.");
            
            //change music
            //flash background
            //change color of timer label to flash back and forth
            
            CCLayerColor* bg = (CCLayerColor*) [[self parent] getChildByTag:kBackgroundTag];
            [bg stopAllActions];
            CCSprite* bg_sprite = (CCSprite*)[bg getChildByTag:kBackgroundSpriteTag];
            [bg_sprite stopAllActions];
            
            CCTintTo* fadeToNormal = [CCTintTo actionWithDuration:.25 red:bg_sprite.color.r green:bg_sprite.color.g blue:bg_sprite.color.b];
            CCTintTo* fadeToYellow = [[CCTintTo alloc] initWithDuration:.25 red:255 green:255 blue:0];
            CCSequence* sequence = [CCSequence actions:fadeToYellow, fadeToNormal, nil];
            
            CCRepeat* repeat = [CCRepeat actionWithAction:sequence times:10];
           
            
            [bg_sprite runAction:repeat];

            break;
        }
        case kTimeOver:{
            [self stopAllActions];
            CCCallBlock* showGameOver = [CCCallBlock actionWithBlock:^{
                
                [[CCDirector sharedDirector] replaceScene:[GameOverLayer scene]];

            }];
            CCSequence *seq = [CCSequence actions:[CCDelayTime actionWithDuration:1.25],  showGameOver, nil];
            [self runAction:seq];
        }
            break;
        case kClearedAttempt:
        {
            CCLOG(@"swiped");
            [[SimpleAudioEngine sharedEngine] playEffect:@"swipe_erase.wav"];
            break;
        }
        case kGreatScore:{
            
            NSNumber* current_word_score = (NSNumber*)alert.Data;
            CCLOG(@"great score! score was %d", [current_word_score intValue]);
            
            [self _showNewAlert:[NSString stringWithFormat:@"Great score! %d points!", [current_word_score intValue]] andColor:ccc3(0, 255, 0)];
            [[SimpleAudioEngine sharedEngine] playEffect:@"Great_Score_1.wav"];
            break;
        }
        case kFastHands:{            
            NSNumber* seconds_per_letter = (NSNumber*)alert.Data;
            
            CCLOG(@"fast hands, %.2f seconds per letter", [seconds_per_letter floatValue]);
            [[SimpleAudioEngine sharedEngine] playEffect:@"fast_hands_2.wav"];
            [self _showNewAlert:@"Fast hands!" andColor:ccc3(0, 255, 0)];
            break;
        }
        case kFailedWordAttempt:{
            CCLOG(@"failed word attempt.");
            [self _flashBGtoRed:255 andGreen:0 andBlue:0];
            [[SimpleAudioEngine sharedEngine] playEffect:@"failed_word.wav"];
            break;
        }
        default:
            break;
    }
    
}
-(void)update:(ccTime)delta{
    
    [_timeLabel setString:[NSString stringWithFormat:@"%d sec.", (int)[VerbosityGameState sharedState].TimeLeft]];
    [_yourScore setString:[NSString stringWithFormat:@"score: %ld",[VerbosityGameState sharedState].Stats.Score]];
    if([VerbosityGameState sharedState].CurrentHotStreak > 1 && [[VerbosityGameState sharedState] isGameActive]){
        [_yourStreak setColor:kScoreColor];
        [_yourStreak setVisible:YES];
        [_yourStreak setString:[NSString stringWithFormat:@"streak: x%d",[VerbosityGameState sharedState].CurrentHotStreak]];
    }else{
        [_yourStreak setVisible:NO];
    }

    [_yourWords setString:[NSString stringWithFormat:@"found: %d words", [VerbosityGameState sharedState].Stats.TotalWordsFound]];
    CCLabelButton* pause =(CCLabelButton*)[self getChildByTag:kPauseButtonTag];
    if([[VerbosityGameState sharedState] isGameActive] && !pause.visible){
        [pause setVisible:YES];
    }
    
    if(![[VerbosityGameState sharedState] isGameActive]){
        [self showRestartMenu];        
        [self unscheduleUpdate];
    }
    
    NSArray* pending_alerts = [[VerbosityAlertManager sharedAlertManager] getAll];
    for(VerbosityAlert* alert in pending_alerts){
        [self _processAlertForDisplay:alert];
    }
}

- (void) showRestartMenu{
    CCLayerColor* dark_overlay = [[CCLayerColor alloc] initWithColor:ccc4(0, 0, 0, 128)];
    [self addChild:dark_overlay z:NSIntegerMax-1];
    CGSize winSize = [CCDirector sharedDirector].winSize;
    
    CCLabelTTF *end_game = [CCLabelTTF labelWithString:@"Time's Up!" fontName:@"AmerTypewriterITCbyBT-Medium" fontSize:VERBOSITYFONTSIZE(40)];
    end_game.position = ccp(winSize.width/2, winSize.height/2);
    end_game.anchorPoint = ccp(.5,.5);
    
    [self addChild:end_game z:NSIntegerMax];

}
- (void)showPauseMenu{
    CCLayerColor* dark_overlay = [[CCLayerColor alloc] initWithColor:ccc4(0, 0, 0, 128)];
    [self addChild:dark_overlay z:NSIntegerMax-1];
}
@end
