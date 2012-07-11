//
//  GameOverLayer.m
//  Verbosity
//
//  Created by Mustafa Shabib on 7/10/12.
//  Copyright (c) 2012 We Are Mammoth. All rights reserved.
//

#import "GameOverLayer.h"
#import "VerbosityGameState.h"
#import "CCUIViewWrapper.h"

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
        
        textView.text =[NSString stringWithFormat:@"Stats\nScore: %d\nPossible Words: %d\nFound Word: %d\nAttempted Words: %d\n%0f%% Correct\n %0f%% Found\nWPM: %d\nLongest Streak: %d\n", 
                        currentState.Score,
                        currentState.CurrentWordsAndLetters.Words.count,
                        currentState.FoundWords.count,
                        currentState.AttemptedWords,
                        currentState.FoundWords.count*100.0f/currentState.AttemptedWords,
                        currentState.FoundWords.count*100.0f/currentState.CurrentWordsAndLetters.Words.count,
                        currentState.CurrentWordsPerMinute,
                        currentState.LongestStreak];
        textView.textColor = [UIColor colorWithWhite:1 alpha:1];
        textView.font = [UIFont fontWithName:@"ArialMT" size:25.0];
        textView.backgroundColor = [UIColor redColor];

        CCUIViewWrapper* wrapper = [CCUIViewWrapper wrapperForUIView:textView];
        wrapper.contentSize = CGSizeMake(winSize.width, winSize.height);

        [self addChild:wrapper];
    }
    return self;
}
@end
