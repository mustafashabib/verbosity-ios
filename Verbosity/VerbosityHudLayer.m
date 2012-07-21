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

-(id) init {
    if( (self=[super init])) 
    {

        CGSize winSize = [CCDirector sharedDirector].winSize;
        VerbosityGameState* current_state = [VerbosityGameState sharedState];
        _timeLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%f", current_state.TimeLeft] fontName:@"ArialRoundedMTBold" fontSize:20];
        _timeLabel.position = CGPointMake(winSize.width/2, winSize.height);
        _timeLabel.anchorPoint = CGPointMake(.5f, 1.0f);
    
        _yourScore = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Score: %d", current_state.Score] fontName:@"ArialRoundedMTBold" fontSize:12];
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

-(void) showAlert:(VerbosityAlert *)alert{

    switch (alert.AlertType) {
        case kFoundRareWord:
        {
            NSNumber* popularity = alert.Data;
            
            CCLOG(@"Found rare word with popularity %d", popularity);
            CCLayerColor* bg = (CCLayerColor*) [[self parent] getChildByTag:kBackgroundTag];
            CCLayerColor* label_bg = [CCLayerColor layerWithColor:ccc4(0, 0, 0, 255)];
            
            label_bg.ignoreAnchorPointForPosition = NO;
            CGSize winSize =[[CCDirector sharedDirector] winSize];
            label_bg.position = ccp(winSize.width/2.0, winSize.height/2.0);
            label_bg.anchorPoint = ccp(.5,.5);
            id fadeOut = [CCFadeOut actionWithDuration:1.5f];
            id death = [CCCallFuncND actionWithTarget:label_bg  selector:@selector(removeFromParentAndCleanup:) data:(void*)YES];
            
            CCLabelTTF* duplicate_label = [[CCLabelTTF alloc] initWithString:@"Rare word!" fontName:@"ArialRoundedMTBold" fontSize:28];
            duplicate_label.anchorPoint = ccp(0,0);
            
            duplicate_label.color = ccc3(0, 255, 0 );
            label_bg.contentSize =  CGSizeMake(duplicate_label.contentSize.width*1.25, duplicate_label.contentSize.height*1.25);
            
            id deathAction = [CCSequence actions:fadeOut, death, nil];
            
            [label_bg addChild:duplicate_label];
            [[bg parent] addChild:label_bg z:NSIntegerMax];

            id floatUp = [CCMoveBy actionWithDuration:.25 position:ccp(duplicate_label.position.x, duplicate_label.position.y*.75)];
            [label_bg runAction:floatUp];
            [label_bg runAction:deathAction];
            
            //todo: update personal stats

            break; 
        }
        case kDuplicateWord:
        {
            CCLOG(@"Duplicate word.");
            CCLayerColor* bg = (CCLayerColor*) [[self parent] getChildByTag:kBackgroundTag];
            CCLayerColor* label_bg = [CCLayerColor layerWithColor:ccc4(0, 0, 0, 255)];
            
            label_bg.ignoreAnchorPointForPosition = NO;
             CGSize winSize =[[CCDirector sharedDirector] winSize];
            label_bg.position = ccp(winSize.width/2.0, winSize.height/2.0);
            label_bg.anchorPoint = ccp(.5,.5);
            id fadeOut = [CCFadeOut actionWithDuration:1.5f];
            id death = [CCCallFuncND actionWithTarget:label_bg  selector:@selector(removeFromParentAndCleanup:) data:(void*)YES];
           
            CCLabelTTF* duplicate_label = [[CCLabelTTF alloc] initWithString:@"Already found!" fontName:@"ArialRoundedMTBold" fontSize:28];
            duplicate_label.anchorPoint = ccp(0,0);
            
            duplicate_label.color = ccc3(255, 0, 0 );
            label_bg.contentSize =  CGSizeMake(duplicate_label.contentSize.width*1.25, duplicate_label.contentSize.height*1.25);
            id deathAction = [CCSequence actions:fadeOut, death,nil];
            
            [label_bg addChild:duplicate_label];
            [[bg parent] addChild:label_bg z:NSIntegerMax];
            id floatUp = [CCMoveBy actionWithDuration:.25 position:ccp(duplicate_label.position.x, duplicate_label.position.y*.75)];
            [label_bg runAction:floatUp];

            [label_bg runAction:deathAction];
            break;
        }
        case kScoreIncreased:
        {
            NSNumber* current_word_score = (NSNumber*)alert.Data;
            CCLOG(@"Score increased by %d.", [current_word_score intValue]);
            
            //change score label
            //particle effects
            //color of layer
            CCLayerColor* bg = (CCLayerColor*) [[self parent] getChildByTag:kBackgroundTag];
            CCTintTo* fadeToNormalColor = [[CCTintTo alloc] initWithDuration:.06126 red:bg.color.r green:bg.color.g blue:bg.color.b];
            CCTintTo* fadeToWhiteAction = [[CCTintTo alloc] initWithDuration:.125 red:255 green:255 blue:255];
            CCSequence* sequence = [CCSequence actions:fadeToWhiteAction, fadeToNormalColor, fadeToWhiteAction, fadeToNormalColor, nil];
            [bg runAction:sequence];
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
            CCLayerColor* bg = (CCLayerColor*) [[self parent] getChildByTag:kBackgroundTag];
            CCLayerColor* label_bg = [CCLayerColor layerWithColor:ccc4(0, 0, 0, 255)];
            
            label_bg.ignoreAnchorPointForPosition = NO;
            CGSize winSize =[[CCDirector sharedDirector] winSize];
            label_bg.position = ccp(winSize.width/2.0, winSize.height/2.0);
            label_bg.anchorPoint = ccp(.5,.5);
            id fadeOut = [CCFadeOut actionWithDuration:1.5f];
            id death = [CCCallFuncND actionWithTarget:label_bg  selector:@selector(removeFromParentAndCleanup:) data:(void*)YES];
            
            CCLabelTTF* duplicate_label = [[CCLabelTTF alloc] initWithString:@"Hot Streak!" fontName:@"ArialRoundedMTBold" fontSize:28];
            duplicate_label.anchorPoint = ccp(0,0);
             id deathAction = [CCSequence actions:fadeOut, death, nil];
            
            duplicate_label.color = ccc3(0, 255, 0 );
            label_bg.contentSize =  CGSizeMake(duplicate_label.contentSize.width*1.25, duplicate_label.contentSize.height*1.25);
            
            [label_bg addChild:duplicate_label];
            [[bg parent] addChild:label_bg z:NSIntegerMax];
            
            id floatUp = [CCMoveBy actionWithDuration:.25 position:ccp(duplicate_label.position.x, duplicate_label.position.y*.75)];
            [label_bg runAction:floatUp];

            [label_bg runAction:deathAction];

       
            break; 
        }
        case kHotStreakEnded:{
            CCLOG(@"streak ended.");
            CCLayerColor* bg = (CCLayerColor*) [[self parent] getChildByTag:kBackgroundTag];
            CCTintTo* fadeToNormalColor = [[CCTintTo alloc] initWithDuration:.06126 red:bg.color.r green:bg.color.g blue:bg.color.b];
            CCTintTo* fadeToRed = [[CCTintTo alloc] initWithDuration:.125 red:255 green:0 blue:0];
            CCSequence* sequence = [CCSequence actions:fadeToRed, fadeToNormalColor, fadeToRed, fadeToNormalColor, nil];
            [bg runAction:sequence];
            CCLayerColor* label_bg = [CCLayerColor layerWithColor:ccc4(0, 0, 0, 255)];
            
            label_bg.ignoreAnchorPointForPosition = NO;
            CGSize winSize =[[CCDirector sharedDirector] winSize];
            label_bg.position = ccp(winSize.width/2.0, winSize.height/2.0);
            label_bg.anchorPoint = ccp(.5,.5);
            id fadeOut = [CCFadeOut actionWithDuration:1.5f];
            id death = [CCCallFuncND actionWithTarget:label_bg  selector:@selector(removeFromParentAndCleanup:) data:(void*)YES];
            
            CCLabelTTF* duplicate_label = [[CCLabelTTF alloc] initWithString:@"You've gone cold!" fontName:@"ArialRoundedMTBold" fontSize:28];
            duplicate_label.anchorPoint = ccp(0,0);
            
            duplicate_label.color = ccc3(255, 0, 0 );
            
            id deathAction = [CCSequence actions:fadeOut, death, nil];
            
            label_bg.contentSize =  CGSizeMake(duplicate_label.contentSize.width*1.25, duplicate_label.contentSize.height*1.25);
            
            [label_bg addChild:duplicate_label];
            [[bg parent] addChild:label_bg z:NSIntegerMax];
            id floatUp = [CCMoveBy actionWithDuration:.25 position:ccp(duplicate_label.position.x, duplicate_label.position.y*.75)];
            [label_bg runAction:floatUp];

            [label_bg runAction:deathAction];

       
            break; 
        }
        case kTimeRunningOut:
        case kTimeNearlyDone:{
            CCLOG(@"time running out.");
            
            int duration_multiplier = 1;
            if(alert.AlertType == kTimeRunningOut){
                duration_multiplier = 2;
            }
            //change music
            //flash background
            //change color of timer label to flash back and forth
            
            CCLayerColor* bg = (CCLayerColor*) [[self parent] getChildByTag:kBackgroundTag];
            [bg stopAllActions];
            CCTintTo* fadeToNormal = [CCTintTo actionWithDuration:.5 red:bg.color.r green:bg.color.g blue:bg.color.b];
            CCTintTo* fadeToYellow = [[CCTintTo alloc] initWithDuration:.5 red:255 green:255 blue:0];
           /* CCTintTo* fadeToMagenta = [[CCTintTo alloc] initWithDuration:.06126*duration_multiplier red:255 green:0 blue:255];
            CCTintTo* fadeToCyan = [[CCTintTo alloc] initWithDuration:.06126*duration_multiplier red:0 green:255 blue:255];
            CCTintTo* fadeToWhite = [[CCTintTo alloc] initWithDuration:.06126*duration_multiplier red:255 green:255 blue:255];
            
            CCTintTo* fadeToRed = [[CCTintTo alloc] initWithDuration:.06126*duration_multiplier red:255 green:0 blue:0];
            CCTintTo* fadeToGreen = [[CCTintTo alloc] initWithDuration:.06126*duration_multiplier red:0 green:255 blue:0];
            CCTintTo* fadeToBlue = [[CCTintTo alloc] initWithDuration:.06126*duration_multiplier red:0 green:0 blue:255];
            CCTintTo* fadeToBlack = [[CCTintTo alloc] initWithDuration:.06126*duration_multiplier red:0 green:0 blue:0];
            
            CCSequence* sequence = [CCSequence actions:fadeToYellow, fadeToMagenta, fadeToCyan, fadeToWhite, fadeToRed, fadeToGreen, fadeToBlue, fadeToBlack, nil];
             */
            CCSequence* sequence = [CCSequence actions:fadeToYellow, fadeToNormal, nil];
            CCRepeat* repeat = [CCRepeat actionWithAction:sequence times:5*duration_multiplier];
           
            
            [bg runAction:repeat];

            break;
        }
        case kTimeOver:{
            [self stopAllActions];
            [[CCDirector sharedDirector] replaceScene:[GameOverLayer scene]];
        }
            break;
        case kGreatScore:{
            
            NSNumber* current_word_score = (NSNumber*)alert.Data;
            CCLOG(@"great score! score was %d", [current_word_score intValue]);
            
            CCLayerColor* bg = (CCLayerColor*) [[self parent] getChildByTag:kBackgroundTag];
            CCLayerColor* label_bg = [CCLayerColor layerWithColor:ccc4(0, 0, 0, 255)];
            
            label_bg.ignoreAnchorPointForPosition = NO;
            CGSize winSize =[[CCDirector sharedDirector] winSize];
            label_bg.position = ccp(winSize.width/2.0, winSize.height/2.0);
            label_bg.anchorPoint = ccp(.5,.5);
            id fadeOut = [CCFadeOut actionWithDuration:1.5f];
            id death = [CCCallFuncND actionWithTarget:label_bg  selector:@selector(removeFromParentAndCleanup:) data:(void*)YES];
            
           
            CCLabelTTF* duplicate_label = [[CCLabelTTF alloc] initWithString:@"Great Score!" fontName:@"ArialRoundedMTBold" fontSize:28];
            id deathAction = [CCSequence actions:fadeOut, death, nil];
            
            duplicate_label.anchorPoint = ccp(0,0);
            
            duplicate_label.color = ccc3(0, 255, 0 );
            label_bg.contentSize =  CGSizeMake(duplicate_label.contentSize.width*1.25, duplicate_label.contentSize.height*1.25);
            
            [label_bg addChild:duplicate_label];
            [[bg parent] addChild:label_bg z:NSIntegerMax];
            id floatUp = [CCMoveBy actionWithDuration:.25 position:ccp(duplicate_label.position.x, duplicate_label.position.y*.75)];
            [label_bg runAction:floatUp];

            [label_bg runAction:deathAction];

        
            break;
        }
        case kFastHands:{            
            NSNumber* seconds_per_letter = (NSNumber*)alert.Data;
            
            CCLOG(@"fast hands, %.2f seconds per letter", [seconds_per_letter floatValue]);

            CCLayerColor* bg = (CCLayerColor*) [[self parent] getChildByTag:kBackgroundTag];
            CCLayerColor* label_bg = [CCLayerColor layerWithColor:ccc4(0, 0, 0, 255)];
            
            label_bg.ignoreAnchorPointForPosition = NO;
            CGSize winSize =[[CCDirector sharedDirector] winSize];
            label_bg.position = ccp(winSize.width/2.0, winSize.height/2.0);
            label_bg.anchorPoint = ccp(.5,.5);
            id fadeOut = [CCFadeOut actionWithDuration:1.5f];
            id death = [CCCallFuncND actionWithTarget:label_bg  selector:@selector(removeFromParentAndCleanup:) data:(void*)YES];
            
            CCLabelTTF* duplicate_label = [[CCLabelTTF alloc] initWithString:@"Fast hands!" fontName:@"ArialRoundedMTBold" fontSize:28];
            
            id deathAction = [CCSequence actions:fadeOut, death, nil];
            
            duplicate_label.anchorPoint = ccp(0,0);
            
            duplicate_label.color = ccc3(0, 255, 0 );
            label_bg.contentSize =  CGSizeMake(duplicate_label.contentSize.width*1.25, duplicate_label.contentSize.height*1.25);
            
            [label_bg addChild:duplicate_label];
            [[bg parent] addChild:label_bg z:NSIntegerMax];
            id floatUp = [CCMoveBy actionWithDuration:.25 position:ccp(duplicate_label.position.x, duplicate_label.position.y*.75)];
            [label_bg runAction:floatUp];

            [label_bg runAction:deathAction];
            break;
        }

        case kFailedWordAttempt:{
            CCLOG(@"failed word attempt.");
            CCLayerColor* bg = (CCLayerColor*) [[self parent] getChildByTag:kBackgroundTag];
            CCTintTo* fadeToNormalColor = [[CCTintTo alloc] initWithDuration:.06126 red:bg.color.r green:bg.color.g blue:bg.color.b];
            CCTintTo* fadeToRed = [[CCTintTo alloc] initWithDuration:.125 red:255 green:0 blue:0];
            CCSequence* sequence = [CCSequence actions:fadeToRed, fadeToNormalColor, fadeToRed, fadeToNormalColor, nil];
            [bg runAction:sequence];
            break;
        }
        default:
            break;
    }
    
}
-(void)update:(ccTime)delta{
   
    [_timeLabel setString:[NSString stringWithFormat:@"%f", [VerbosityGameState sharedState].TimeLeft]];
    [_yourScore setString:[NSString stringWithFormat:@"Score: %d/%d words",[VerbosityGameState sharedState].Score,[[VerbosityGameState sharedState].FoundWords count]]];
    
    if(![[VerbosityGameState sharedState] isGameActive]){
        [self showRestartMenu];        
        [self unscheduleUpdate];
    }
    
    NSArray* pending_alerts = [[VerbosityAlertManager sharedAlertManager] getAll];
    for(VerbosityAlert* alert in pending_alerts){
        [self showAlert:alert];
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
