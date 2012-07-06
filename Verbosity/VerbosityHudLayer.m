//
//  VerbosityHudLayer.m
//  Verbosity
//
//  Created by Mustafa Shabib on 7/6/12.
//  Copyright (c) 2012 We Are Mammoth. All rights reserved.
//

#import "VerbosityHudLayer.h"
#import "VerbosityGameLayer.h"
#import "VerbosityGameState.h"
#import "VerbosityAlertManager.h"


#define kBackgroundTag 102342234241

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
    
        
        CCLayerColor *bg = [CCLayerColor layerWithColor:ccc4(128,128,128,255)];
        
        [self addChild:bg z:0 tag:kBackgroundTag];
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
            CCLOG(@"Found rare word.");
            NSNumber* popularity = alert.Data;
            CCLayerColor* bg = (CCLayerColor*) [self getChildByTag:kBackgroundTag];
            CCLayerColor* label_bg = [CCLayerColor layerWithColor:ccc4(0, 0, 0, 255)];
            
            label_bg.ignoreAnchorPointForPosition = NO;
            CGSize winSize =[[CCDirector sharedDirector] winSize];
            label_bg.position = ccp(winSize.width/2.0, winSize.height/2.0);
            label_bg.anchorPoint = ccp(.5,.5);
            id fadeOut = [CCFadeOut actionWithDuration:1.5f];
            id death = [CCCallFuncND actionWithTarget:label_bg  selector:@selector(removeFromParentAndCleanup:) data:(void*)YES];
            
            CCLabelTTF* duplicate_label = [[CCLabelTTF alloc] initWithString:@"Rare word!" fontName:@"ArialRoundedMTBold" fontSize:28];
            duplicate_label.anchorPoint = ccp(0,0);
            id death2 = [CCCallFuncND actionWithTarget:duplicate_label  selector:@selector(removeFromParentAndCleanup:) data:(void*)YES];
            
            duplicate_label.color = ccc3(0, 255, 0 );
            label_bg.contentSize =  CGSizeMake(duplicate_label.contentSize.width*1.25, duplicate_label.contentSize.height*1.25);
            id deathAction = [CCSequence actions:fadeOut, death,death2, nil];
            
            [label_bg addChild:duplicate_label];
            [[bg parent] addChild:label_bg z:NSIntegerMax];
            [label_bg runAction:deathAction];
            
            //todo: update personal stats

            break; 
        }
        case kDuplicateWord:
        {
            CCLOG(@"Duplicate word.");
            CCLayerColor* bg = (CCLayerColor*) [self getChildByTag:kBackgroundTag];
            CCLayerColor* label_bg = [CCLayerColor layerWithColor:ccc4(0, 0, 0, 255)];
            
            label_bg.ignoreAnchorPointForPosition = NO;
             CGSize winSize =[[CCDirector sharedDirector] winSize];
            label_bg.position = ccp(winSize.width/2.0, winSize.height/2.0);
            label_bg.anchorPoint = ccp(.5,.5);
            id fadeOut = [CCFadeOut actionWithDuration:1.5f];
            id death = [CCCallFuncND actionWithTarget:label_bg  selector:@selector(removeFromParentAndCleanup:) data:(void*)YES];
           
            CCLabelTTF* duplicate_label = [[CCLabelTTF alloc] initWithString:@"Already found!" fontName:@"ArialRoundedMTBold" fontSize:28];
            duplicate_label.anchorPoint = ccp(0,0);
            id death2 = [CCCallFuncND actionWithTarget:duplicate_label  selector:@selector(removeFromParentAndCleanup:) data:(void*)YES];
            
            duplicate_label.color = ccc3(255, 0, 0 );
            label_bg.contentSize =  CGSizeMake(duplicate_label.contentSize.width*1.25, duplicate_label.contentSize.height*1.25);
            id deathAction = [CCSequence actions:fadeOut, death, death2,nil];
            
            [label_bg addChild:duplicate_label];
            [[bg parent] addChild:label_bg z:NSIntegerMax];
            [label_bg runAction:deathAction];
            break;
        }
        case kScoreIncreased:
        {
            CCLOG(@"Score increased.");
            NSNumber* current_word_score = (NSNumber*)alert.Data;
            //change score label
            //particle effects
            //color of layer
            CCLayerColor* bg = (CCLayerColor*) [self getChildByTag:kBackgroundTag];
            CCTintTo* fadeToNormalColor = [[CCTintTo alloc] initWithDuration:.06126 red:bg.color.r green:bg.color.g blue:bg.color.b];
            CCTintTo* fadeToWhiteAction = [[CCTintTo alloc] initWithDuration:.125 red:255 green:255 blue:255];
            CCSequence* sequence = [CCSequence actions:fadeToWhiteAction, fadeToNormalColor, fadeToWhiteAction, fadeToNormalColor, nil];
            [bg runAction:sequence];
        break;
            
        }
        case kWordAttemptUpdated:{
            CCLOG(@"word attempt updated.");
            NSString* current_word = (NSString*)alert.Data;
            //todo: play sound
            
            break;
        }
        case kHotStreakStarted:{
            CCLOG(@"hot streak started");
            CCLayerColor* bg = (CCLayerColor*) [self getChildByTag:kBackgroundTag];
            CCLayerColor* label_bg = [CCLayerColor layerWithColor:ccc4(0, 0, 0, 255)];
            
            label_bg.ignoreAnchorPointForPosition = NO;
            CGSize winSize =[[CCDirector sharedDirector] winSize];
            label_bg.position = ccp(winSize.width/2.0, winSize.height/2.0);
            label_bg.anchorPoint = ccp(.5,.5);
            id fadeOut = [CCFadeOut actionWithDuration:1.5f];
            id death = [CCCallFuncND actionWithTarget:label_bg  selector:@selector(removeFromParentAndCleanup:) data:(void*)YES];
            
            CCLabelTTF* duplicate_label = [[CCLabelTTF alloc] initWithString:@"Hot Streak!" fontName:@"ArialRoundedMTBold" fontSize:28];
            duplicate_label.anchorPoint = ccp(0,0);
            id death2 = [CCCallFuncND actionWithTarget:duplicate_label  selector:@selector(removeFromParentAndCleanup:) data:(void*)YES];
            id deathAction = [CCSequence actions:fadeOut, death,death2, nil];
            
            duplicate_label.color = ccc3(0, 255, 0 );
            label_bg.contentSize =  CGSizeMake(duplicate_label.contentSize.width*1.25, duplicate_label.contentSize.height*1.25);
            
            [label_bg addChild:duplicate_label];
            [[bg parent] addChild:label_bg z:NSIntegerMax];
            [label_bg runAction:deathAction];

       
            break; 
        }
        case kHotStreakEnded:{
            CCLOG(@"streak ended.");
            CCLayerColor* bg = (CCLayerColor*) [self getChildByTag:kBackgroundTag];
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
            id death2 = [CCCallFuncND actionWithTarget:duplicate_label  selector:@selector(removeFromParentAndCleanup:) data:(void*)YES];
            
            id deathAction = [CCSequence actions:fadeOut, death,death2, nil];
            
            label_bg.contentSize =  CGSizeMake(duplicate_label.contentSize.width*1.25, duplicate_label.contentSize.height*1.25);
            
            [label_bg addChild:duplicate_label];
            [[bg parent] addChild:label_bg z:NSIntegerMax];
            [label_bg runAction:deathAction];

       
            break; 
        }
        case kTimeRunningOut:{
            CCLOG(@"time running out.");
            
            //change music
            //flash background
            //change color of timer label to flash back and forth
            CCLayerColor* bg = (CCLayerColor*) [self getChildByTag:kBackgroundTag];
            CCTintTo* fadeToNormalColor = [[CCTintTo alloc] initWithDuration:.125 red:bg.color.r green:bg.color.g blue:bg.color.b];
            CCTintTo* fadeToYellow = [[CCTintTo alloc] initWithDuration:.125 red:255 green:255 blue:0];
            CCSequence* sequence = [CCSequence actions:fadeToYellow, fadeToNormalColor, nil];
            CCRepeat* repeatAction = [[CCRepeat alloc] initWithAction:sequence times:40];
            [bg runAction:repeatAction];
            break;
        }
        case kGreatScore:{
            CCLOG(@"great score!");
            
            NSNumber* current_word_score = (NSNumber*)alert.Data;
            CCLayerColor* bg = (CCLayerColor*) [self getChildByTag:kBackgroundTag];
            CCLayerColor* label_bg = [CCLayerColor layerWithColor:ccc4(0, 0, 0, 255)];
            
            label_bg.ignoreAnchorPointForPosition = NO;
            CGSize winSize =[[CCDirector sharedDirector] winSize];
            label_bg.position = ccp(winSize.width/2.0, winSize.height/2.0);
            label_bg.anchorPoint = ccp(.5,.5);
            id fadeOut = [CCFadeOut actionWithDuration:1.5f];
            id death = [CCCallFuncND actionWithTarget:label_bg  selector:@selector(removeFromParentAndCleanup:) data:(void*)YES];
            
           
            CCLabelTTF* duplicate_label = [[CCLabelTTF alloc] initWithString:@"Great Score!" fontName:@"ArialRoundedMTBold" fontSize:28];
            id death2 = [CCCallFuncND actionWithTarget:duplicate_label  selector:@selector(removeFromParentAndCleanup:) data:(void*)YES];
            id deathAction = [CCSequence actions:fadeOut, death,death2, nil];
            
            duplicate_label.anchorPoint = ccp(0,0);
            
            duplicate_label.color = ccc3(0, 255, 0 );
            label_bg.contentSize =  CGSizeMake(duplicate_label.contentSize.width*1.25, duplicate_label.contentSize.height*1.25);
            
            [label_bg addChild:duplicate_label];
            [[bg parent] addChild:label_bg z:NSIntegerMax];
            [label_bg runAction:deathAction];

        
            break;
        }
        case kFastHands:{
            CCLOG(@"fast hands");
            
            NSNumber* seconds_per_letter = (NSNumber*)alert.Data;
            NSNumber* current_word_score = (NSNumber*)alert.Data;
            CCLayerColor* bg = (CCLayerColor*) [self getChildByTag:kBackgroundTag];
            CCLayerColor* label_bg = [CCLayerColor layerWithColor:ccc4(0, 0, 0, 255)];
            
            label_bg.ignoreAnchorPointForPosition = NO;
            CGSize winSize =[[CCDirector sharedDirector] winSize];
            label_bg.position = ccp(winSize.width/2.0, winSize.height/2.0);
            label_bg.anchorPoint = ccp(.5,.5);
            id fadeOut = [CCFadeOut actionWithDuration:1.5f];
            id death = [CCCallFuncND actionWithTarget:label_bg  selector:@selector(removeFromParentAndCleanup:) data:(void*)YES];
            
            CCLabelTTF* duplicate_label = [[CCLabelTTF alloc] initWithString:@"Fast hands!" fontName:@"ArialRoundedMTBold" fontSize:28];
            id death2 = [CCCallFuncND actionWithTarget:duplicate_label  selector:@selector(removeFromParentAndCleanup:) data:(void*)YES];
            
            id deathAction = [CCSequence actions:fadeOut, death,death2, nil];
            
            duplicate_label.anchorPoint = ccp(0,0);
            
            duplicate_label.color = ccc3(0, 255, 0 );
            label_bg.contentSize =  CGSizeMake(duplicate_label.contentSize.width*1.25, duplicate_label.contentSize.height*1.25);
            
            [label_bg addChild:duplicate_label];
            [[bg parent] addChild:label_bg z:NSIntegerMax];
            [label_bg runAction:deathAction];
            break;
        }

        case kFailedWordAttempt:{
            CCLOG(@"failed word attempt.");
            CCLayerColor* bg = (CCLayerColor*) [self getChildByTag:kBackgroundTag];
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
