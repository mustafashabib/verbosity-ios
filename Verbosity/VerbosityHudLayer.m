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

@implementation VerbosityHudLayer

/*private methods*/
-(void) _showNewAlert:(NSString*)labelString andColor:(ccColor3B) color{
    /*
    //old way with background
    CCLayerColor* label_bg = [CCLayerColor layerWithColor:ccc4(0, 0, 0, 128)];
    
    label_bg.ignoreAnchorPointForPosition = NO;
    label_bg.anchorPoint = ccp(0,0);
    
   
    CCLabelTTF* label = [[CCLabelTTF alloc] initWithString:labelString fontName:@"ArialRoundedMTBold" fontSize:12 ];
    
    label.anchorPoint = ccp(0,0);
    
    label.color = color;
    label_bg.contentSize =  CGSizeMake(label.contentSize.width*1.25, label.contentSize.height*1.25);
    
    
    [label_bg addChild:label];
    
    if([_current_labels count] == kMaxAlertsToShow){ //remove the oldest alert
        CCLayerColor* last_label = (CCLayerColor*)[_current_labels objectAtIndex:0];
        [self removeChild:last_label cleanup:YES];
        [_current_labels removeObjectAtIndex:0];
    }
    
    
    [_current_labels addObject:label_bg];
    int alpha_multiply = (int)(255.0f/kMaxAlertsToShow);
    
    for(int i = [_current_labels count]-1; i >= 0;i--){//start at newest
        int age = [_current_labels count]-1 - i;
        CCLayerColor* current_alert_label = [_current_labels objectAtIndex:i];
        current_alert_label.opacity = 255 -(alpha_multiply*age);
        for(int child = 0; child < [current_alert_label.children count]; child++){
            CCNode* child_node = [current_alert_label.children objectAtIndex:child];
            if([child_node isKindOfClass:[CCLabelTTF class]]){
                CCLabelTTF* label = (CCLabelTTF*)child_node;
                label.opacity = 255 - (alpha_multiply*age);
            }
        }
        current_alert_label.position = ccp(0, age*current_alert_label.contentSize.height);
        if(age==0){
            [self addChild:current_alert_label];
        }
    }
     */

    //new way without background
    //old way with background
        CCLabelTTF* label = [[CCLabelTTF alloc] initWithString:labelString fontName:@"ArialRoundedMTBold" fontSize:14 ];
    
    label.anchorPoint = ccp(0,0);
    
    label.color = color;
    
    
    
    if([_current_labels count] == kMaxAlertsToShow){ //remove the oldest alert
        CCLabelTTF* last_label = (CCLabelTTF*)[_current_labels objectAtIndex:0];
        [self removeChild:last_label cleanup:YES];
        [_current_labels removeObjectAtIndex:0];
    }
    
    
    [_current_labels addObject:label];
    int alpha_multiply = (int)(255.0f/kMaxAlertsToShow);
    
    for(int i = [_current_labels count]-1; i >= 0;i--){//start at newest
        int age = [_current_labels count]-1 - i;
        CCLabelTTF* current_alert_label = [_current_labels objectAtIndex:i];
        current_alert_label.opacity = 255 -(alpha_multiply*age);
        CGPoint destination = ccp(0, age*current_alert_label.contentSize.height);
        if(age==0){
            current_alert_label.position = ccp(0,-current_alert_label.contentSize.height); //off screen
            [self addChild:current_alert_label];
        }
    CCMoveTo *moveToAction = [CCMoveTo actionWithDuration:.25 position:destination];
    [current_alert_label runAction:moveToAction];
    }
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
        _timeLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%f", current_state.TimeLeft] fontName:@"ArialRoundedMTBold" fontSize:20];
        _timeLabel.position = CGPointMake(winSize.width/2, winSize.height);
        _timeLabel.anchorPoint = CGPointMake(.5f, 1.0f);
    
        _yourScore = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Score: %ld", current_state.Stats.Score] fontName:@"ArialRoundedMTBold" fontSize:12];
        _yourScore.position = CGPointMake(0, winSize.height);
        _yourScore.anchorPoint = ccp(0,1);
    
        
        [self addChild:_timeLabel z:1];
        [self addChild:_yourScore z:1];
    
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

    switch (alert.AlertType) {
        case kFoundRareWord:
        {
            NSString* word = (NSString*)alert.Data;
            
            CCLOG(@"Found rare word %@", word);
            [self _showNewAlert:[NSString stringWithFormat:@"Rare word! (%@)", word] andColor:ccc3(0, 255, 0)];
            
            break;
        }
        case kDuplicateWord:
        {
            CCLOG(@"Duplicate word.");
            NSString* word = (NSString*)alert.Data;
            [self _showNewAlert:[NSString stringWithFormat:@"Duplicate word! (%@)", word] andColor:ccc3(255, 0, 0)];
            break;
        }
        case kScoreIncreased:
        {
            NSNumber* current_word_score = (NSNumber*)alert.Data;
            CCLOG(@"Score increased by %d.", [current_word_score intValue]);
            
            //change score label
            //particle effects
            //color of layer
            [self _flashBGtoRed:0 andGreen:255 andBlue:0];
        break;
            
        }
        case kWordAttemptUpdated:{
            NSString* current_word = (NSString*)alert.Data;
            CCLOG(@"word attempt updated, it's now %@", current_word);
            //todo: play sound
            
            break;
        }
        case kHotStreakStarted:{
            CCLOG(@"hot streak started");
            [self _showNewAlert:@"Hot streak!" andColor:ccc3(0, 255, 0)];
            break; 
        }
        case kColdStreakEnded:
        {
            CCLOG(@"cold streak ended.");
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
            [self _showNewAlert:@"Hot streak ended!" andColor:ccc3(255, 0, 0)];
       
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
            CCSequence *seq = [CCSequence actions:[CCDelayTime actionWithDuration:.75],  showGameOver, nil];
            [self runAction:seq];
        }
            break;
        case kGreatScore:{
            
            NSNumber* current_word_score = (NSNumber*)alert.Data;
            CCLOG(@"great score! score was %d", [current_word_score intValue]);
            
            [self _showNewAlert:[NSString stringWithFormat:@"Great score! %d points!", [current_word_score intValue]] andColor:ccc3(0, 255, 0)];        
            break;
        }
        case kFastHands:{            
            NSNumber* seconds_per_letter = (NSNumber*)alert.Data;
            
            CCLOG(@"fast hands, %.2f seconds per letter", [seconds_per_letter floatValue]);

           [self _showNewAlert:@"Fast hands!" andColor:ccc3(0, 255, 0)];
           break;
        }

        case kFailedWordAttempt:{
            CCLOG(@"failed word attempt.");
            [self _flashBGtoRed:255 andGreen:0 andBlue:0];
            break;
        }
        default:
            break;
    }
    
}
-(void)update:(ccTime)delta{
   
    [_timeLabel setString:[NSString stringWithFormat:@"%f", [VerbosityGameState sharedState].TimeLeft]];
    [_yourScore setString:[NSString stringWithFormat:@"Score: %ld/%d words",[VerbosityGameState sharedState].Stats.Score,[[VerbosityGameState sharedState].FoundWords count]]];
    
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
    
    CCLabelTTF *end_game = [CCLabelTTF labelWithString:@"Time's Up!" fontName:@"ArialRoundedMTBold" fontSize:40.0];
    end_game.position = ccp(winSize.width/2, winSize.height/2);
    end_game.anchorPoint = ccp(.5,.5);
    
    [self addChild:end_game z:NSIntegerMax];

}
- (void)showPauseMenu{
    CCLayerColor* dark_overlay = [[CCLayerColor alloc] initWithColor:ccc4(0, 0, 0, 128)];
    [self addChild:dark_overlay z:NSIntegerMax-1];
}
@end
