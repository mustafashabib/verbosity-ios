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
    int _streak;
    float _last_word_attempt_time;
    WordsAndLetters* _current_words_and_letters;
    NSMutableSet* _found_words;
    NSString *_current_word_attempt;
    NSMutableArray* _selected_letters;
}

@property(nonatomic) GameStat* Stats;
@property(nonatomic) NSMutableArray *WordsFoundOfLength;
@property(nonatomic) WordsAndLetters* CurrentWordsAndLetters;
@property(nonatomic) float TimeLeft;
@property(nonatomic) NSMutableSet* FoundWords;
@property(nonatomic) int Streak;
@property(nonatomic) NSString* CurrentWordAttempt;
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