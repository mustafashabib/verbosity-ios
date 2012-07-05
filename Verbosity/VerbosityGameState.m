//
//  GameState.m
//  Verbosity
//
//  Created by Mustafa Shabib on 7/5/12.
//  Copyright (c) 2012 We Are Mammoth. All rights reserved.
//

#import "VerbosityGameState.h"
#import "VerbosityRepository.h"

static VerbosityGameState *sharedState = nil;


@implementation VerbosityGameState
@synthesize CurrentWordsAndLetters = _current_words_and_letters;
@synthesize CurrentLanguage = _current_language;
@synthesize TimeLeft = _time_left;
@synthesize Score = _score;

- (VerbosityGameState*) init{
    if(self = [super init]){
        self.CurrentLanguage = (Language*)[[[VerbosityRepository context] getLanguages] objectAtIndex:0];
        self.TimeLeft = 120;
        self.Score = 0;
    }
    return self;
}


- (void) setupGame{
    self.CurrentWordsAndLetters = [[VerbosityRepository context] getWordsForLanguage:self.CurrentLanguage.ID withAtLeastOneWordOfLength:[self.CurrentLanguage.MaximumWordLength]];
    self.TimeLeft = 120;
    self.Score = 0;
}


+ (VerbosityGameState*)sharedState{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedState = [[VerbosityGameState alloc] init];
    });
    return sharedState;
}
@end
