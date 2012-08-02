//
//  GameState.m
//  Verbosity
//
//  Created by Mustafa Shabib on 7/5/12.
//  Copyright (c) 2012 Betel Nut Games. All rights reserved.
//

#import "VerbosityGameState.h"
#import "VerbosityRepository.h"
#import "VerbosityGameConstants.h"
#import "VerbosityAlertManager.h"
#import "VerbosityAlert.h"
#import "NSMutableArray+Stack.h"

static VerbosityGameState *sharedState = nil;


@implementation VerbosityGameState
@synthesize CurrentWordsAndLetters = _current_words_and_letters;
@synthesize TimeLeft = _time_left;
@synthesize CurrentHotStreak = _current_hot_streak;
@synthesize CurrentColdStreak = _current_cold_streak;
@synthesize FoundWords = _found_words;
@synthesize CurrentWordAttempt = _current_word_attempt;
@synthesize WordsFoundOfLength = _words_found_of_length;
@synthesize SelectedLetters = _selected_letters;
@synthesize CurrentGameState = _current_game_state;
@synthesize Stats = _stats;

- (VerbosityGameState*) init{
    if(self = [super init]){
        _current_game_state = kGameStateLoading;
        [[VerbosityAlertManager sharedAlertManager] resetAlerts];
        _stats = [[GameStat alloc] init];
         _time_left= kGameTime;
        _start_time = kGameTime;
        _word_attempt_start_time = kGameTime;
        _found_words=[[NSMutableSet alloc] init];
        
        _stats.CurrentLanguage = (Language*)[[[VerbosityRepository context] getLanguages] objectAtIndex:0];
        _current_words_and_letters = [[VerbosityRepository context] getWordsForLanguage:_stats.CurrentLanguage.ID withAtLeastOneWordOfLength:_stats.CurrentLanguage.MaximumWordLength];
        
        _selected_letters = [[NSMutableArray alloc] init];
        _current_word_attempt = @"";
        _current_hot_streak = 0;
        _current_cold_streak = 0;
        
        _words_found_of_length = [[NSMutableArray alloc] initWithCapacity:_stats.CurrentLanguage.MaximumWordLength];
        for(int i = 0; i < _stats.CurrentLanguage.MaximumWordLength;i++){
            [_words_found_of_length addObject:[NSNumber numberWithInt:0]];
        }
        
}
    _current_game_state = kGameStateReady;
    return self;
}

-(BOOL) isGameActive
{
    return (_time_left > 0 && [_found_words count] < [[_current_words_and_letters Words] count]);
}


- (void) setupGame{
    [[VerbosityAlertManager sharedAlertManager] resetAlerts];
    [_stats resetStats];
    _current_game_state = kGameStateLoading;
    _time_left= kGameTime;
    _start_time = kGameTime;
    _word_attempt_start_time = kGameTime;
    _found_words=[[NSMutableSet alloc] init];
    
    _current_words_and_letters = [[VerbosityRepository context] getWordsForLanguage:_stats.CurrentLanguage.ID withAtLeastOneWordOfLength:_stats.CurrentLanguage.MaximumWordLength];
    
    _selected_letters = [[NSMutableArray alloc] init];
    _current_word_attempt = @"";
    _current_hot_streak = 0;
    _current_cold_streak = 0;
    
    _words_found_of_length = [[NSMutableArray alloc] initWithCapacity:_stats.CurrentLanguage.MaximumWordLength];
    for(int i = 0; i < _stats.CurrentLanguage.MaximumWordLength;i++){
        [_words_found_of_length addObject:[NSNumber numberWithInt:0]];
    }
    _current_game_state = kGameStateReady;
    
}

- (void) update:(float)delta{
    if(kGameStateReady){
        _time_left -= delta;
        if(_time_left < 10){
            VerbosityAlert* running_out_of_time_alert= [[VerbosityAlert alloc] initWithType:kTimeRunningOut andData:nil];
            [[VerbosityAlertManager sharedAlertManager] addAlert:running_out_of_time_alert];
        }
        if(_time_left < 5){
            VerbosityAlert* time_nearly_done_alert= [[VerbosityAlert alloc] initWithType:kTimeNearlyDone andData:nil];
            [[VerbosityAlertManager sharedAlertManager] addAlert:time_nearly_done_alert];
        }
    
        if(_time_left < 0){
            _time_left = 0; 
            VerbosityAlert* time_done_alert= [[VerbosityAlert alloc] initWithType:kTimeOver andData:nil];
            [[VerbosityAlertManager sharedAlertManager] addAlert:time_done_alert];
            _current_game_state = kGameStateOver;
        }
    
        if([_current_word_attempt length] == 0){
            _word_attempt_start_time = _time_left;
        }
    }
}
-(void) clearWordAttempt{
    _current_word_attempt = @"";
    [_selected_letters removeAllObjects];
    VerbosityAlert* cleared_alert = [[VerbosityAlert alloc] initWithType:kClearedAttempt andData:nil];
    [[VerbosityAlertManager sharedAlertManager] addAlert:cleared_alert];
}

- (void) removeLastLetterFromWordAttempt{
     _current_word_attempt = [_current_word_attempt substringWithRange:NSMakeRange(0, [_current_word_attempt length] - 1)];
    id letter = [_selected_letters pop];
    VerbosityAlert* removed_letter_alert = [[VerbosityAlert alloc] initWithType:kRemovedLastLetter andData:letter];
    [[VerbosityAlertManager sharedAlertManager] addAlert:removed_letter_alert];
    
}
- (void) updateWordAttempt:(NSString*)newLetter withData:(id)data{
    [_selected_letters push:data];
    _current_word_attempt = [NSString stringWithFormat:@"%@%@", _current_word_attempt, newLetter];
    VerbosityAlert* new_letter_alert = [[VerbosityAlert alloc] initWithType:kWordAttemptUpdated andData:_current_word_attempt];
    [[VerbosityAlertManager sharedAlertManager] addAlert:new_letter_alert];
}
//if yes, score will update, streak will increase by 1, current words per minute will update, and found words will update,  lastwordattempttime will always update
// will return positive number (score of last word) if succeeded
- (BOOL) submitWordAttempt{
    _stats.AttemptedWords++;
    Word* matching_word = (Word*) [self.CurrentWordsAndLetters.Words objectForKey:_current_word_attempt];
   
    if(![_found_words containsObject:_current_word_attempt] && matching_word != nil){
        [_found_words addObject:_current_word_attempt];
        _stats.TotalWordsFound++;
        _current_hot_streak++;
        if(_current_cold_streak >= 3){
            //you were on a cold streak but now you're not
            VerbosityAlert*  cold_streak_ended = [[VerbosityAlert alloc] initWithType:kColdStreakEnded andData:nil];
                [[VerbosityAlertManager sharedAlertManager] addAlert:cold_streak_ended];
        }
        
        
        _current_cold_streak = 0;
        if(_current_hot_streak > _stats.LongestStreak){
            _stats.LongestStreak++;
        }
        float time_to_enter_word = _word_attempt_start_time - (int) _time_left;
        float seconds_per_letter = time_to_enter_word/[_current_word_attempt length];
        int speed_multiplier = 1;
        if(seconds_per_letter < .5){
                speed_multiplier = 3;
        }else if(seconds_per_letter >= 1 && seconds_per_letter < 2){
                speed_multiplier = 2;
        }
        
        if(speed_multiplier == 3){
                VerbosityAlert* fast_hands_alert = [[VerbosityAlert alloc] initWithType:kFastHands andData:[NSNumber numberWithInt:seconds_per_letter]];
                [[VerbosityAlertManager sharedAlertManager] addAlert:fast_hands_alert];
        }
         //really popular words will end up being nearly 0
        //the rarest word will have a value of 100
        //everything else falls in between
        float popularity_multiplier = MAX(1,100/matching_word.Popularity);
        int length = [_current_word_attempt length];
        if(popularity_multiplier >= 75){
            
            _stats.RareWordsFound++;
            VerbosityAlert* rare_word_found_alert = [[VerbosityAlert alloc] initWithType:kFoundRareWord andData:_current_word_attempt];
            [[VerbosityAlertManager sharedAlertManager] addAlert:rare_word_found_alert];            
        }
        
        int current_word_score = (_current_hot_streak * speed_multiplier * popularity_multiplier * length) * 100;
        _stats.Score += current_word_score;
        _word_attempt_start_time = _time_left;
        float minutes_passed = (_start_time - _time_left)/60.0f;
        _stats.WordsPerMinute = _stats.TotalWordsFound/minutes_passed;
        
        _current_word_attempt = @"";
        
        VerbosityAlert* score_alert = [[VerbosityAlert alloc] initWithType:kScoreIncreased andData:[NSNumber numberWithInt:current_word_score]];
        [[VerbosityAlertManager sharedAlertManager] addAlert:score_alert];  
        
        if(current_word_score > 50000){
            VerbosityAlert* great_score_alert = [[VerbosityAlert alloc] initWithType:kGreatScore andData:[NSNumber numberWithInt:current_word_score]];
            [[VerbosityAlertManager sharedAlertManager] addAlert:great_score_alert];  
        }
        NSNumber* oldVal = (NSNumber*)[_words_found_of_length objectAtIndex:length-1];
        NSNumber* newVal = [NSNumber numberWithInt:[oldVal intValue] + 1];
        [_words_found_of_length replaceObjectAtIndex:length-1 withObject:newVal];
        if(_current_hot_streak == 3){
            VerbosityAlert* streak_started = [[VerbosityAlert alloc] initWithType:kHotStreakStarted andData:nil];
            [[VerbosityAlertManager sharedAlertManager] addAlert:streak_started];  
        }
        return YES;
    }
    else{
        if(matching_word != nil){
            VerbosityAlert* duplicate_word = [[VerbosityAlert alloc] initWithType:kDuplicateWord andData:_current_word_attempt];
            [[VerbosityAlertManager sharedAlertManager] addAlert:duplicate_word]; 
        }
        if(_current_hot_streak > 3){//you missed a word and your streak was greater than 3 (hot streak)
            VerbosityAlert* streak_ended = [[VerbosityAlert alloc] initWithType:kHotStreakEnded andData:nil];
            [[VerbosityAlertManager sharedAlertManager] addAlert:streak_ended];  
        }
        
        
        _current_hot_streak = 0;
        _current_cold_streak++;
        if(_current_cold_streak == 3){
            //you've gone cold
            VerbosityAlert*  cold_streak_started = [[VerbosityAlert alloc] initWithType:kColdStreakStarted andData:nil];
            [[VerbosityAlertManager sharedAlertManager] addAlert:cold_streak_started];
        }
        
        if(_current_cold_streak > _stats.LongestColdStreak){
            _stats.LongestColdStreak = _current_cold_streak;
        }
        
        VerbosityAlert* failed_word_attempt = [[VerbosityAlert alloc] initWithType:kFailedWordAttempt andData:_current_word_attempt];
        [[VerbosityAlertManager sharedAlertManager] addAlert:failed_word_attempt];
        _word_attempt_start_time = _time_left;
         _current_word_attempt = @"";         
        
        return NO;
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
