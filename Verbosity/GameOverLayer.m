//
//  GameOverLayer.m
//  Verbosity
//
//  Created by Mustafa Shabib on 7/10/12.
//  Copyright (c) 2012 Betel Nut Games. All rights reserved.
//

#import "GameOverLayer.h"
#import "VerbosityGameLayer.h"
#import "VerbosityGameState.h"
#import "CCUIViewWrapper.h"
#import "Word.h"

@implementation GameOverLayer
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
  	// 'layer' is an autorelease object.
	GameOverLayer *layer = [GameOverLayer node];
    
    [scene addChild:layer];
	// return the scene
	return scene;
}

-(id)init{
    self = [super init];
    if(self){
        self.isTouchEnabled=YES;
        VerbosityGameState* currentState = [VerbosityGameState sharedState];
        CGSize winSize = [CCDirector sharedDirector].winSize;
        UITextView* textView = [[UITextView alloc] initWithFrame:CGRectMake(0,0,winSize.width,winSize.height)];
        
        [textView setEditable:NO];
        textView.showsVerticalScrollIndicator = NO;
        textView.showsHorizontalScrollIndicator = NO;
        textView.alwaysBounceVertical = YES;
        
        NSString* stats = [NSString stringWithFormat:@"Stats\nScore: %d\nPossible Words: %d\nFound Word: %d\nAttempted Words: %d\n%0f%% Correct\n%0f%% Found\nWPM: %d\nLongest Streak: %d\n", 
                        currentState.Score,
                        currentState.CurrentWordsAndLetters.Words.count,
                        currentState.FoundWords.count,
                        currentState.AttemptedWords,
                        currentState.FoundWords.count*100.0f/currentState.AttemptedWords,
                        currentState.FoundWords.count*100.0f/currentState.CurrentWordsAndLetters.Words.count,
                        currentState.CurrentWordsPerMinute,
                        currentState.LongestStreak];
        NSArray* keyArray = [[VerbosityGameState sharedState].CurrentWordsAndLetters.Words allKeys];
        int count = [keyArray count];
        NSString* word_list = [[NSString alloc] init];
        for(int i = 0; i < count; i++){
            Word* word = (Word*)[[VerbosityGameState sharedState].CurrentWordsAndLetters.Words objectForKey:[keyArray objectAtIndex:i]];

            if(![[VerbosityGameState sharedState].FoundWords containsObject:word.Value]){
                word_list = [NSString stringWithFormat:@"%@\n(X)%@", word_list, word.Value];
            }else{
                word_list = [NSString stringWithFormat:@"%@\n%@", word_list, word.Value];
            }
        }
        textView.text = [NSString stringWithFormat:@"%@\n---Words---\n%@", stats, word_list];

        textView.textColor = [UIColor colorWithWhite:1 alpha:1];
        textView.font = [UIFont fontWithName:@"ArialMT" size:25.0];
        textView.backgroundColor = [UIColor grayColor];

        CCUIViewWrapper* wrapper = [CCUIViewWrapper wrapperForUIView:textView];
        wrapper.contentSize = CGSizeMake(winSize.width/2, winSize.height);

        [self addChild:wrapper];
        // Default font size will be 22 points.
        [CCMenuItemFont setFontSize:22];
        
        // Reset Button
        CCMenuItemLabel *reset = [CCMenuItemFont itemWithString:@"Reset" block:^(id sender){
            [[CCDirector sharedDirector] replaceScene: [VerbosityGameLayer scene]];
        }];
        CCMenu *menu = [CCMenu menuWithItems: reset, nil];
        
        [menu alignItemsVertically];
        
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        [menu setPosition:ccp( size.width/2 + 50, size.height/2)];
        
        
        [self addChild: menu];	

    }
    return self;
}
@end
