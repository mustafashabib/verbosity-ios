//
//  HistoricalGameStat.m
//  Verbosity
//
//  Created by Mustafa Shabib on 7/22/12.
//  Copyright (c) 2012 Betel Nut Games. All rights reserved.
//

#import "HistoricalGameStat.h"

@implementation HistoricalGameStat
@synthesize AvgSuccessRate = _avg_success_rate;
@synthesize AvgWPM = _avg_wpm;
@synthesize BestScore = _best_score;
@synthesize BestLongestStreak = _best_longest_streak;
@synthesize WorstColdStreak = _worst_cold_streak;
@synthesize MostRareWordsFound = _most_rare_words_found;

-(id) initWithMostRareWordsFound:(int)most_rare_words andBestScore:(long)best_score andAvgWPM:(int)avg_wpm andAvgSuccessRate:(float)avg_success_rate andBestLongestStreak:(int)best_longest_streak andWorstColdStreak:(int)worst_cold_streak;
{
    self = [super init];
    if(self){
        _worst_cold_streak = worst_cold_streak;
        _most_rare_words_found = most_rare_words;
        _best_score = best_score;
        _avg_wpm = avg_wpm;
        _avg_success_rate = avg_success_rate;
        _best_longest_streak = best_longest_streak;    
    }
    return self;
}
@end

