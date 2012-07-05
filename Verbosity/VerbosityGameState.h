//
//  GameState.h
//  Verbosity
//
//  Created by Mustafa Shabib on 7/5/12.
//  Copyright (c) 2012 We Are Mammoth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Language.h";
#import "WordsAndLetters.h"

@interface VerbosityGameState : NSObject
{
    long _score;
    float _time_left;
    Language* _current_language;
    WordsAndLetters* _current_words_and_letters;
}

@property(nonatomic) Language* CurrentLanguage;
@property(nonatomic) WordsAndLetters* CurrentWordsAndLetters;
@property(nonatomic) float TimeLeft;
@property(nonatomic) long   Score;
+ (VerbosityGameState *)sharedState;
- (void) setupGame;

@end