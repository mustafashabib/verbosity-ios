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
#import "GameStat.h"

//todo - extract stats into its own object

@interface VerbosityGameState : NSObject
{
    GameStat* _stats;
     NSMutableArray *_words_found_of_length;
    float _time_left;
    float _start_time; //save how many seconds the level timer started out with
    int _current_hot_streak;
    int _current_cold_streak;
    float _word_attempt_start_time;
    WordsAndLetters* _current_words_and_letters;
    NSMutableSet* _found_words;
    NSString *_current_word_attempt;
    NSMutableArray* _selected_letters;
    int _current_game_state;
}

@property(nonatomic) GameStat* Stats;
@property(nonatomic) NSMutableArray *WordsFoundOfLength;
@property(nonatomic) WordsAndLetters* CurrentWordsAndLetters;
@property(nonatomic) float TimeLeft;
@property(nonatomic) NSMutableSet* FoundWords;
@property(nonatomic) int CurrentHotStreak;
@property(nonatomic) NSString* CurrentWordAttempt;
@property(nonatomic) NSMutableArray* SelectedLetters;
@property(nonatomic) int CurrentColdStreak;
@property(nonatomic) int CurrentGameState;

+ (VerbosityGameState *)sharedState;
- (void) update:(float)delta;
- (BOOL) isGameActive;
- (void) setupGame;
- (BOOL) submitWordAttempt;
- (void) updateWordAttempt:(NSString*)newLetter withData:(id)data;
- (void) clearWordAttempt;
- (void) removeLastLetterFromWordAttempt;
@end