//
//  GameState.h
//  Verbosity
//
//  Created by Mustafa Shabib on 7/5/12.
//  Copyright (c) 2012 Betel Nut Games. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Language.h"
#import "WordsAndLetters.h"

//todo - extract stats into its own object

@interface VerbosityGameState : NSObject
{
    int _rare_words_founds;
    NSMutableArray *_words_found_of_length;
    long _score;
    float _time_left;
    float _start_time; //save how many seconds the level timer started out with
    Language* _current_language;
    int _streak;
    int _current_words_per_minute;
    float _last_word_attempt_time;
    WordsAndLetters* _current_words_and_letters;
    NSMutableSet* _found_words;
    NSString *_current_word_attempt;
    int _attempted_words;
    int _longest_streak;
    NSMutableArray* _selected_letters;
}

@property(nonatomic) NSMutableArray *WordsFoundOfLength;
@property(nonatomic) int RareWordsFound;
@property(nonatomic) Language* CurrentLanguage;
@property(nonatomic) WordsAndLetters* CurrentWordsAndLetters;
@property(nonatomic) float TimeLeft;
@property(nonatomic) NSMutableSet* FoundWords;
@property(nonatomic) long   Score;
@property(nonatomic) int CurrentWordsPerMinute;
@property(nonatomic) int Streak;
@property(nonatomic) NSString* CurrentWordAttempt;
@property(nonatomic) int AttemptedWords;
@property(nonatomic) int LongestStreak;
@property(nonatomic) NSMutableArray* SelectedLetters;

+ (VerbosityGameState *)sharedState;
- (void) update:(float)delta;
- (BOOL) isGameActive;
- (void) setupGame;
- (BOOL) submitWordAttempt;
- (void) updateWordAttempt:(NSString*)newLetter withData:(id)data;
- (void) clearWordAttempt;
- (void) removeLastLetterFromWordAttempt;
@end