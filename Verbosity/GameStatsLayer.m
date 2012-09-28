//
//  MainMenu.m
//  Verbosity
//
//  Created by Mustafa Shabib on 7/22/12.
//  Copyright (c) 2012 Betel Nut Games. All rights reserved.
//

#import "MainMenu.h"
#import "GameStatsLayer.h"
#import "GameStat.h"
#import "VerbosityRepository.h"
#import "SimpleAudioEngine.h"
#import "CCUIViewWrapper.h"
#import "VerbosityGameConstants.h"
#import "CCLabelButton.h"
#import "SimpleAudioEngine.h"
#import "VerbosityGameLayer.h"
#import "FlurryAnalytics.h"

@implementation GameStatsLayer
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
  	// 'layer' is an autorelease object.
	GameStatsLayer *layer = [GameStatsLayer node];
    
    [scene addChild:layer];
	// return the scene
	return scene;
}

-(id)init{
    self = [super init];
    if(self){
        [FlurryAnalytics logEvent:@"historical stats"];
        CCSprite* bg = [CCSprite spriteWithFile:@"DarkGrayBackground.jpg"];
        [bg setAnchorPoint:ccp(0,0)];
        [self addChild:bg z:0];

        self.isTouchEnabled=YES;
        // Default font size will be 18 points.
        [CCMenuItemFont setFontSize:VERBOSITYFONTSIZE(18)];
        
        // Reset Button
        CCMenuItemLabel *back = [CCMenuItemFont itemWithString:@"Go Back" block:^(id sender){
            [[SimpleAudioEngine sharedEngine] playEffect:@"swipe_erase.wav"];
            
            [[CCDirector sharedDirector] replaceScene: [MainMenu scene]];
        }];
        
        
        CCMenu *menu = [CCMenu menuWithItems: back, nil];
        
        [menu alignItemsHorizontally];
        
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        [menu setPosition:ccp( size.width/2, 20)];
        
        
        [self addChild: menu];	
        CGSize winSize = [CCDirector sharedDirector].winSize;
       
        float fontSize = VERBOSITYFONTSIZE(25);
        float labelSize = VERBOSITYPOINTS(30);
        
        // Set the font type for the label text
        NSString *fontType = @"AmerTypewriterITCbyBT-Medium";
        HistoricalGameStat* historical_stats = [[VerbosityRepository context] getHistoricalBestStats];
    //select max(RareWordsFound), max(score), max(wordsperminute), avg(totalwordsfound)/avg(attemptedwords)*100 as avgSuccess, max(longeststreak) from gamestats;
        if(historical_stats){
            /*NSString stringWithFormat:@"Best Score: %ld\nAvg Success Rate: %.2f%%\nBest WPM
             -                          historical_stats.BestScore, historical_stats.AvgSuccessRate, historical_stats.Av
             -                           historical_stats.WorstColdStreak*/
            
            CCLabelTTF* score = [CCLabelTTF labelWithString:@"Best Score" fontName:fontType fontSize:fontSize];
            NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
            [numberFormatter setNumberStyle: NSNumberFormatterDecimalStyle];
            NSString *formattedScore = [numberFormatter stringFromNumber:[NSNumber numberWithLong:historical_stats.BestScore]];
            CCLabelTTF* scoreV = [CCLabelTTF labelWithString:formattedScore fontName:fontType fontSize:fontSize];
            [score setAnchorPoint:ccp(0,1)];
            [score setPosition:ccp(5,winSize.height-30)];
            [scoreV setAnchorPoint:ccp(1,1)];
            [scoreV setPosition:ccp(winSize.width-5,winSize.height-30)];
            [scoreV setColor:ccGREEN];
            
            CCLabelTTF* successRate = [CCLabelTTF labelWithString:@"Success Rate" fontName:fontType fontSize:fontSize];
            CCLabelTTF* successRateV = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%.0f%%", historical_stats.AvgSuccessRate] fontName:fontType fontSize:fontSize];
            [successRate setAnchorPoint:ccp(0,1)];
            [successRate setPosition:ccp(5,score.position.y - labelSize)];
            [successRateV setAnchorPoint:ccp(1,1)];
            [successRateV setPosition:ccp(winSize.width-5,scoreV.position.y - labelSize)];
            if(historical_stats.AvgSuccessRate > 50){
                [successRateV setColor:ccGREEN];
            }else if( historical_stats.AvgSuccessRate > 25){
                [successRateV setColor:ccYELLOW];
            }else{
                [successRateV setColor:ccRED];
            }
                        
            CCLabelTTF* hotStreak = [CCLabelTTF labelWithString:@"Best Hot Streak" fontName:fontType fontSize:fontSize];
            CCLabelTTF* hotStreakV = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d", historical_stats.BestLongestStreak] fontName:fontType fontSize:fontSize];
            [hotStreak setAnchorPoint:ccp(0,1)];
            [hotStreak setPosition:ccp(5,successRate.position.y - labelSize)];
            [hotStreakV setAnchorPoint:ccp(1,1)];
            [hotStreakV setPosition:ccp(winSize.width-5,successRateV.position.y - labelSize)];
            [hotStreakV setColor:ccGREEN];
            
            
            CCLabelTTF* coldStreak = [CCLabelTTF labelWithString:@"Worst Cold Streak" fontName:fontType fontSize:fontSize];
            CCLabelTTF* coldStreakV = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",  historical_stats.WorstColdStreak] fontName:fontType fontSize:fontSize];
            [coldStreak setAnchorPoint:ccp(0,1)];
            [coldStreak setPosition:ccp(5,hotStreak.position.y - labelSize)];
            [coldStreakV setAnchorPoint:ccp(1,1)];
            [coldStreakV setPosition:ccp(winSize.width-5,hotStreakV.position.y - labelSize)];
            [coldStreakV setColor:ccc3(135, 206, 250)];
            
            CCLabelTTF* rareWords = [CCLabelTTF labelWithString:@"Most Rare Words Found" fontName:fontType fontSize:fontSize];
            CCLabelTTF* rareWordsV = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",  historical_stats.MostRareWordsFound] fontName:fontType fontSize:fontSize];
            [rareWords setAnchorPoint:ccp(0,1)];
            [rareWords setPosition:ccp(5,coldStreak.position.y - labelSize)];
            [rareWordsV setAnchorPoint:ccp(1,1)];
            [rareWordsV setPosition:ccp(winSize.width-5,coldStreakV.position.y - labelSize)];
            [rareWordsV setColor:ccGREEN];
            
            [self addChild:score];
            [self addChild:scoreV];
            
            [self addChild:successRate];
            [self addChild:successRateV];
            
            [self addChild:hotStreak];
            [self addChild:hotStreakV];
            
            [self addChild:coldStreak];
            [self addChild:coldStreakV];
            
            [self addChild:rareWords];
            [self addChild:rareWordsV];

            
        }else{
            //you haven't played anything yet
            CCLabelTTF *no_stats = [CCLabelTTF labelWithString:@"You haven't played any games yet!" fontName:fontType fontSize:fontSize];
            CCLabelButton *play_now = [[CCLabelButton alloc] initWithString:@"Play Now" andFontName:fontType andFontSize:fontSize andTouchesEndBlock:^{
                [[SimpleAudioEngine sharedEngine] playEffect:@"Great_Score_1.wav"];
                [[CCDirector sharedDirector] replaceScene: [VerbosityGameLayer scene]];
            }];
            [no_stats setPosition:ccp(winSize.width/2, (winSize.height*2)/3)];
            [play_now setPosition:ccp(no_stats.position.x, no_stats.position.y-labelSize)];
            [self addChild:no_stats];
            [self addChild:play_now];
            
        }
        
        
    }
    return self;
}
@end
