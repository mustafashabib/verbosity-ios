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
#import "CCUIViewWrapper.h"

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
        self.isTouchEnabled=YES;
        // Default font size will be 22 points.
        [CCMenuItemFont setFontSize:22];
        
        // Reset Button
        CCMenuItemLabel *back = [CCMenuItemFont itemWithString:@"Back" block:^(id sender){
            [[CCDirector sharedDirector] replaceScene: [MainMenu scene]];
        }];
        
        
        CCMenu *menu = [CCMenu menuWithItems: back, nil];
        
        [menu alignItemsHorizontally];
        
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        [menu setPosition:ccp( size.width/2, 20)];
        
        
        [self addChild: menu];	
        CGSize winSize = [CCDirector sharedDirector].winSize;
        UITextView* textView = [[UITextView alloc] initWithFrame:CGRectMake(0,0,winSize.width,winSize.height - 100)];
        
        [textView setEditable:NO];
        textView.showsVerticalScrollIndicator = NO;
        textView.showsHorizontalScrollIndicator = NO;
        textView.alwaysBounceVertical = YES;
        [textView setScrollEnabled:NO];
        
        HistoricalGameStat* historical_stats = [[VerbosityRepository context] getHistoricalBestStats];
    //select max(RareWordsFound), max(score), max(wordsperminute), avg(totalwordsfound)/avg(attemptedwords)*100 as avgSuccess, max(longeststreak) from gamestats;
        if(historical_stats){
        NSString* stats = [NSString stringWithFormat:@"Best Score: %ld\nAvg Success Rate: %.2f%%\nBest WPM: %d\nLongest Streak:%d\nMost Rare Words Found:%d", 
                          historical_stats.BestScore, historical_stats.AvgSuccessRate, historical_stats.AvgWPM, historical_stats.BestLongestStreak, historical_stats.MostRareWordsFound];
       textView.text = stats;
        }else{
            textView.text = @"You haven't played any games yet.";
        }
        textView.font = [UIFont fontWithName:@"ArialMT" size:25.0];
        textView.backgroundColor = [UIColor grayColor];
        
        CCUIViewWrapper* wrapper = [CCUIViewWrapper wrapperForUIView:textView];
        wrapper.contentSize = CGSizeMake(winSize.width,winSize.height - 100);
        
        [self addChild:wrapper];

        
    }
    return self;
}
@end
