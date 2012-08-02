//
//  GameStat.m
//  Verbosity
//
//  Created by Mustafa Shabib on 7/22/12.
//  Copyright (c) 2012 Betel Nut Games. All rights reserved.
//

#import "GameStat.h"
#import "VerbosityRepository.h"

@implementation GameStat
@synthesize AttemptedWords = _attempted_words;
@synthesize CurrentLanguage = _current_language;
@synthesize DatePlayed = _date_played;
@synthesize LongestStreak = _longest_streak;
@synthesize RareWordsFound=_rare_words_found;
@synthesize Score = _score;
@synthesize TotalWordsFound = _total_words_found;
@synthesize WordsPerMinute = _words_per_minute;
@synthesize LongestColdStreak = _longest_cold_streak;

-(id)init{
    if(self = [super init]){
        _attempted_words = 0;
        _current_language = (Language*)[[[VerbosityRepository context] getLanguages] objectAtIndex:0];
        
        _date_played = [NSDate date];
        _longest_streak = 0;
        _longest_cold_streak = 0;
        _rare_words_found = 0;
        _score = 0;
        _total_words_found = 0;
        _words_per_minute = 0;
    }
    return self;
}

-(id)initWithLanguage:(Language*)language{
    if(self = [self init]){
        _current_language = language;
    }
    return self;
}

-(id)initWithAttemptedWords:(int)attempted_words andCurrentLanguage:(Language*)language andDatePlayed:(NSDate*)date andLongestStreak:(int)longest_streak andLongestColdStreak:(int)longest_cold_streak andRareWordsFound:(int)rare_words_found andScore:(long)score andTotalWordsFound:(int)total_words_found andWordsPerMinute:(int)words_per_minute{
    if(self = [super init]){
        _attempted_words = attempted_words;
        _current_language = language;
        _date_played = date;
        _longest_streak = longest_streak;
        _rare_words_found = rare_words_found;
        _score = score;
        _total_words_found = total_words_found;
        _longest_cold_streak = longest_cold_streak;
        _words_per_minute = words_per_minute;
    }
    return self;
}
//computed property
-(int) TotalWordsMissed{
    return _attempted_words - _total_words_found;
}

-(void)resetStats{
    _attempted_words = 0;
    _date_played = [NSDate date]; //reset date to now
    _longest_streak = 0;
    _rare_words_found = 0;
    _score = 0;
    _longest_cold_streak = 0;
    _total_words_found = 0;
    _words_per_minute = 0;
    //keep language the same

}
@end
