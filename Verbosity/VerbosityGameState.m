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
@synthesize CurrentWordsPerMinute = _current_words_per_minute;
@synthesize Streak = _streak;
@synthesize FoundWords = _found_words;
@synthesize CurrentWordAttempt = _current_word_attempt;

- (VerbosityGameState*) init{
    if(self = [super init]){
        self.CurrentLanguage = (Language*)[[[VerbosityRepository context] getLanguages] objectAtIndex:0];
        self.TimeLeft = 120;
        _start_time = 120;
        self.CurrentWordsPerMinute = 0;
        _last_word_attempt_time = 120;
        _found_words=[[NSMutableSet alloc] init];
        _current_words_and_letters = nil;
        self.Score = 0; 
        _current_word_attempt = @"";
        
        self.Streak = 0;
    }
    return self;
}


- (void) setupGame{
    self.CurrentWordsAndLetters = [[VerbosityRepository context] getWordsForLanguage:self.CurrentLanguage.ID withAtLeastOneWordOfLength:self.CurrentLanguage.MaximumWordLength];
    
    self.TimeLeft = 120;
    _start_time = 120;
    _last_word_attempt_time = 120;
    _found_words=[[NSMutableSet alloc] init];
    self.Score = 0;
    self.Streak = 0;
    _current_word_attempt = @"";
    self.CurrentWordsPerMinute = 0;
}

- (void) updateWordAttempt:(NSString*)newLetter{
    _current_word_attempt = [NSString stringWithFormat:@"%@%@", _current_word_attempt, newLetter];
}
//if yes, score will update, streak will increase by 1, current words per minute will update, and found words will update,  lastwordattempttime will always update
// will return positive number (score of last word) if succeeded
- (int) submitWordAttempt{
    
    Word* matching_word = (Word*) [self.CurrentWordsAndLetters.Words objectForKey:_current_word_attempt];
   
    if(![_found_words containsObject:_current_word_attempt] && matching_word != nil){
        [_found_words addObject:_current_word_attempt];
        
        _streak++;
        int time_to_enter_word = _last_word_attempt_time - (int) _time_left;
        int seconds_per_letter = time_to_enter_word/[_current_word_attempt length];
        int speed_multiplier = 1;
        switch (seconds_per_letter) {
            case 0:
                speed_multiplier = 3;
                break;
            case 1:
                speed_multiplier = 2;
                break;
            default:
                break;
        }
         //really popular words will end up being nearly 0
        //the rarest word will have a value of 100
        //everything else falls in between
        float popularity_multiplier = MAX(1,100/matching_word.Popularity);
        int current_word_score = (_streak * speed_multiplier * popularity_multiplier * [_current_word_attempt length]) * 100;
        _score += current_word_score;
        _last_word_attempt_time = _time_left;
        float minutes_passed = (_start_time - _time_left)/60.0f;
        _current_words_per_minute = [_found_words count]/minutes_passed;
        _current_word_attempt = @"";
        return current_word_score;
    }
    else{
        _streak = 0;
        _last_word_attempt_time = _time_left;
         _current_word_attempt = @"";
        return 0;
    }
}

+ (VerbosityGameState*)sharedState{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedState = [[VerbosityGameState alloc] init];
    });
    return sharedState;
}
@end
