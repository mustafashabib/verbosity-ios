//
//  GameStat.h
//  Verbosity
//
//  Created by Mustafa Shabib on 7/22/12.
//  Copyright (c) 2012 Betel Nut Games. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Language.h"

@interface GameStat : NSObject
{
NSDate *_date_played;
int _rare_words_found;
long _score;
Language* _current_language;
int _words_per_minute;
int _attempted_words;
int _longest_streak;
int _total_words_found;
    int _longest_cold_streak;
}
@property(nonatomic) NSDate* DatePlayed;
@property(nonatomic) int RareWordsFound;
@property(nonatomic) long Score;
@property(nonatomic) Language* CurrentLanguage;
@property(nonatomic) int WordsPerMinute;
@property(nonatomic) int AttemptedWords;
@property(nonatomic) int LongestStreak;
@property(nonatomic) int LongestColdStreak;
@property(nonatomic) int TotalWordsFound;
@property(nonatomic,readonly) int TotalWordsMissed;

-(id)initWithLanguage:(Language*)language;

-(id)initWithAttemptedWords:(int)attempted_words andCurrentLanguage:(Language*)language andDatePlayed:(NSDate*)date andLongestStreak:(int)longest_streak andLongestColdStreak:(int)longest_cold_streak andRareWordsFound:(int)rare_words_found andScore:(long)score andTotalWordsFound:(int)total_words_found andWordsPerMinute:(int)words_per_minute;
-(void)resetStats;
@end
