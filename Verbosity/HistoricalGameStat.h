//
//  HistoricalGameStat.h
//  Verbosity
//
//  Created by Mustafa Shabib on 7/22/12.
//  Copyright (c) 2012 Betel Nut Games. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HistoricalGameStat : NSObject
{
    //select max(RareWordsFound), max(score), max(wordsperminute), avg(totalwordsfound)/avg(attemptedwords)*100 as avgSuccess, max(longeststreak) from gamestats;
    int _most_rare_words_found;
    long _best_score;
    int _avg_wpm;
    float _avg_success_rate;
    int _best_longest_streak;
}
@property(nonatomic) int MostRareWordsFound;
@property(nonatomic) long BestScore;
@property(nonatomic) int AvgWPM;
@property(nonatomic) float AvgSuccessRate;
@property(nonatomic) int BestLongestStreak;

-(id) initWithMostRareWordsFound:(int)most_rare_words andBestScore:(long)best_score andAvgWPM:(int)avg_wpm andAvgSuccessRate:(float)avg_success_rate andBestLongestStreak:(int)best_longest_streak;
@end
