//
//  VerbosityRepository.m
//  Verbosity
//
//  Created by Mustafa Shabib on 6/27/12.
//  Copyright (c) 2012 Betel Nut Games. All rights reserved.
//

#import "VerbosityRepository.h"
#import "Word.h"
#import "Language.h"
#import "GameCache.h"
#import "NSMutableArray+Shuffling.h"
#import "cocos2d.h"

#define kMinimumWordsForGame 20

static VerbosityRepository *_context;
static sqlite3* _db;
@implementation VerbosityRepository

+ (VerbosityRepository *)context {
	if(_context == nil) {
		_context = [[VerbosityRepository alloc] init];
        
	}

	return _context;
}

- (BOOL)_executeNonQuery:(NSString*)sql_query{
    sqlite3_stmt *statement;
    BOOL is_success = NO;
    if(sqlite3_prepare_v2(_db, [sql_query UTF8String], -1, &statement, nil)
	   == SQLITE_OK){
        if(sqlite3_step(statement) == SQLITE_DONE) {
            CCLOG(@"Executed non query");
            is_success= NO;
		}
        else{
            CCLOG(@"Can't execute non query!");
            is_success = NO;
        }
		sqlite3_finalize(statement);
    }
    return is_success;
}

-(void)addNewLanguageFromFile:(NSString *)path_to_language_file{
    //backup db
    
    NSString* dbFilename = [NSString stringWithFormat:@"%@.sqlite3", kDatabaseName];
    NSString* dbBackupFilename = [NSString stringWithFormat:@"backup_%@.sqlite3"];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *docDBPath = [documentsDirectory stringByAppendingPathComponent:dbFilename];
    NSString *docBackupDBPath = [documentsDirectory stringByAppendingPathComponent:dbBackupFilename];
    
    
    NSString *language_file_path = [documentsDirectory stringByAppendingPathComponent:path_to_language_file];
    
    
    //docDBPath is existing db within docs
    
    //clear out any old backups
    if([[NSFileManager defaultManager] fileExistsAtPath:docBackupDBPath]){
        [[NSFileManager defaultManager] removeItemAtPath:docBackupDBPath error:nil];
    }
    
    //make sure it exists in docs path    
    if ([[NSFileManager defaultManager] fileExistsAtPath:docDBPath] == NO) {
        NSString *resourcePath = [[NSBundle mainBundle] pathForResource:kDatabaseName  ofType:@"sqlite3"];
        [[NSFileManager defaultManager] copyItemAtPath:resourcePath toPath:docDBPath error:&error];
    }

    [[NSFileManager defaultManager] copyItemAtPath:docDBPath toPath:docBackupDBPath error:nil]; //back it up
    
    NSString *contents = [NSString stringWithContentsOfFile:language_file_path encoding:NSUTF8StringEncoding error:nil];
    NSArray *lines = [contents componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\r\n"]];
    BOOL has_error = NO;
    for (NSString* line in lines) {
        
        if (line.length) {
            CCLOG(@"line: %@", line);
            if(![self _executeNonQuery:line]){
                has_error = YES;
                break;
            }
        }
    }
    //rollback to old db
    if(has_error){
        if([[NSFileManager defaultManager] isReadableFileAtPath:docBackupDBPath]){
            [[NSFileManager defaultManager] removeItemAtPath:docDBPath error:nil];
            [[NSFileManager defaultManager] copyItemAtPath:docBackupDBPath toPath:docDBPath error:nil];
        }
    }
    
    //remove backup
    [[NSFileManager defaultManager] removeItemAtPath:docBackupDBPath error:nil];
    
    //clear cache
    [[GameCache sharedCache] removeObjectForKey:@"Languages"];
    
    //releoad sql db
    [self loadDB];
    
    
}

- (void)loadDB{
    sqlite3_close(_db);
    //copy db to docs path if necessary. always open from docs.
    NSString* dbFilename = [NSString stringWithFormat:@"%@.sqlite3", kDatabaseName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *docDBPath = [documentsDirectory stringByAppendingPathComponent:dbFilename];
    
    if ([fileManager fileExistsAtPath:docDBPath] == NO) {
        NSString *resourcePath = [[NSBundle mainBundle] pathForResource:kDatabaseName  ofType:@"sqlite3"];
        [fileManager copyItemAtPath:resourcePath toPath:docDBPath error:&error];
    }
    
    if(sqlite3_open([docDBPath UTF8String], &_db) != SQLITE_OK) {          
        NSLog(@"Failed to open database!");
    }

}

- (id)init {
	if((self = [super init])) {
        [self loadDB];
    }
	return self;
}

- (void)dealloc {
	sqlite3_close(_db);
}


- (NSArray *)getLanguages {
    NSMutableArray *languages = [[NSMutableArray alloc] init];
    NSString *query = @"select id,name, font,maximumwordlength from Languages;";
	sqlite3_stmt *statement;
    NSArray* cached_languages = (NSArray*)[[GameCache sharedCache] objectForKey:@"Languages"];
    if(cached_languages != nil){
        return cached_languages;
    }
    
     if(sqlite3_prepare_v2(_db, [query UTF8String], -1, &statement, nil)
	   == SQLITE_OK)
	{
    	while(sqlite3_step(statement) == SQLITE_ROW) {
           
			int uniqueID = sqlite3_column_int(statement, 0);
			char *nameChars = (char *)sqlite3_column_text(statement, 1);
			char *fontChars = (char *)sqlite3_column_text(statement, 2);
            int maxLen = sqlite3_column_int(statement, 3);
            NSString *name = [[NSString alloc] initWithUTF8String:nameChars];
            NSString *font = [[NSString alloc] initWithUTF8String:fontChars];
			Language* lang = [[Language alloc] initWithUniqueID:uniqueID andName:name andFont:font andMaximumWordLength:maxLen];
            [languages addObject:lang];
		}
		sqlite3_finalize(statement);
	}
    [[GameCache sharedCache] setObject:languages forKey:@"Languages"];
   	return languages;
}

/* 
 * get random letters where at least one word of length len can be made of those letters for a specific language and get all the words that can
 * be made of those letters.
 * select letters.random,letters.key letters_key,words.id,words.word,words.popularity,words.key,words.relatedlanguageid from words, 
 * (select word as random, key from words where relatedlanguageid==%d and 
 * length(word) == %d order by random() limit 1) as letters where words.relatedlanguageid == %d and words.key <= letters.key and letters.key%%words.key == 0;
 */
- (WordsAndLetters *)getWordsForLanguage:(int)language_id withAtLeastOneWordOfLength:(int)length {
	NSMutableDictionary *words =  [[NSMutableDictionary alloc] init];
    NSMutableArray *letters = [[NSMutableArray alloc] init];
    NSString *query = [NSString stringWithFormat:@"select letters.random,letters.key letters_key,words.id,words.word,words.popularity,words.key,words.relatedlanguageid from words,                        (select word as random, key from words where relatedlanguageid==%d and length(word) == %d order by random() limit 1) as letters where words.relatedlanguageid == %d and words.key <= letters.key and letters.key%%words.key == 0;", language_id, length,language_id];
	sqlite3_stmt *statement;
    
	if(sqlite3_prepare_v2(_db, [query UTF8String], -1, &statement, nil)
	   == SQLITE_OK)
	{
        BOOL got_letters = NO;
		while(sqlite3_step(statement) == SQLITE_ROW) {
            if(!got_letters){
                char *randomChars = (char *)sqlite3_column_text(statement,0);//must always be six letters long
                for(int i = 0; i < 6;i++){
                    NSString* current_letter = [NSString stringWithFormat:@"%c", randomChars[i]];
                    [letters addObject:current_letter];
                }
                got_letters = YES;
            }
			int uniqueID = sqlite3_column_int(statement, 2);
			char *valueChars = (char *)sqlite3_column_text(statement, 3);
            long popularity = sqlite3_column_int64(statement, 4);
			long key = sqlite3_column_int64(statement, 5);
			NSString *value = [[NSString alloc] initWithUTF8String:valueChars];
			Word *current_word = [[Word alloc]initWithUniqueId:uniqueID value:value key:key popularity:popularity language:language_id];
			[words setObject:current_word forKey:value];
		}
		sqlite3_finalize(statement);
	}
    if([words count] < kMinimumWordsForGame){
        CCLOG(@"Only found %d words for this game. Trying again.", [words count]);
        return [self getWordsForLanguage:language_id withAtLeastOneWordOfLength:length];
    }else{
        CCLOG(@"Found %d words", [words count]);
    }
	
	 [letters shuffle];//shuffle up the letters
    return [[WordsAndLetters alloc] initWithWords:words andLetters:letters];	
}

-(void) saveStats:(GameStat*)stat{
   
    NSDate* today = [NSDate date];
    long today_in_unix_time = (long)[today timeIntervalSince1970];
    
    /*bind values*/
    NSString *query = [NSString stringWithFormat:@"insert into gamestats(datePlayed,RareWordsFound , Score, RelatedLanguageID, WordsPerMinute, AttemptedWords, LongestStreak,TotalWordsFound) values(%ld, %d, %ld, %d, %d, %d, %d, %d);", today_in_unix_time, stat.RareWordsFound, stat.Score, stat.CurrentLanguage.ID, stat.WordsPerMinute, stat.AttemptedWords, stat.LongestStreak, stat.TotalWordsFound];
    
   
	sqlite3_stmt *statement;
    
	if(sqlite3_prepare_v2(_db, [query UTF8String], -1, &statement, nil)
	   == SQLITE_OK)
	{        
        if(sqlite3_step(statement) == SQLITE_DONE) {
            CCLOG(@"Saved stats.");
		}
        else{
            CCLOG(@"Can't save stats!");
        }
		sqlite3_finalize(statement);
	}
   	return;

}



-(Language*) _getLanguageByID:(int)language_id{
    NSArray* languages = [self getLanguages];//grab known langs
    for(int i = 0; i < [languages count]; i++){
        Language* lang = [languages objectAtIndex:i];
        if(lang.ID == language_id){
            return lang;
        }
    }
    return nil;
    
}

-(HistoricalGameStat*) getHistoricalBestStats{
    //select max(RareWordsFound), max(score), max(wordsperminute), avg(totalwordsfound)/avg(attemptedwords) as avgSuccess, max(longeststreak) from gamestats;
    
    NSString *query = @"select max(RareWordsFound), max(score), max(wordsperminute), avg(totalwordsfound)/avg(attemptedwords)*100 as avgSuccess, max(longeststreak) from gamestats";
    
    HistoricalGameStat *historical_stat = nil;
	sqlite3_stmt *statement;
    if(sqlite3_prepare_v2(_db, [query UTF8String], -1, &statement, nil)
	   == SQLITE_OK)
	{
    	if(sqlite3_step(statement) == SQLITE_ROW) {
            int rare_words_found = sqlite3_column_int(statement, 0);
            long score = sqlite3_column_int64(statement, 1);
            int wpm = sqlite3_column_int(statement, 2);
            float avg_success = sqlite3_column_double(statement, 3);
            int longest_streak = sqlite3_column_int(statement, 4);
            
            historical_stat = [[HistoricalGameStat alloc] initWithMostRareWordsFound:rare_words_found andBestScore:score andAvgWPM:wpm andAvgSuccessRate:avg_success andBestLongestStreak:longest_streak];
            
        }
		sqlite3_finalize(statement);
	}
    return historical_stat;
}



-(HistoricalGameStat*) getHistoricalBestStatsForLanguage:(int)language_id{
    //select max(RareWordsFound), max(score), max(wordsperminute), avg(totalwordsfound)/avg(attemptedwords) as avgSuccess, max(longeststreak) from gamestats;
    
    NSString *query = [NSString stringWithFormat:@"select max(RareWordsFound), max(score), max(wordsperminute), avg(totalwordsfound)/avg(attemptedwords)*100 as avgSuccess, max(longeststreak) from gamestats where relatedlanguageid = %d", language_id];
    
    HistoricalGameStat *historical_stat = nil;
	sqlite3_stmt *statement;
    if(sqlite3_prepare_v2(_db, [query UTF8String], -1, &statement, nil)
	   == SQLITE_OK)
	{
    	if(sqlite3_step(statement) == SQLITE_ROW) {
            int rare_words_found = sqlite3_column_int(statement, 0);
            long score = sqlite3_column_int64(statement, 1);
            int wpm = sqlite3_column_int(statement, 2);
            float avg_success = sqlite3_column_double(statement, 3);
            int longest_streak = sqlite3_column_int(statement, 4);
            
            historical_stat = [[HistoricalGameStat alloc] initWithMostRareWordsFound:rare_words_found andBestScore:score andAvgWPM:wpm andAvgSuccessRate:avg_success andBestLongestStreak:longest_streak];
            
        }
		sqlite3_finalize(statement);
	}
    return historical_stat;
}


-(GameStat*) getAverageStats{
    NSString *query = @"select avg(RareWordsFound) as RareWordsFound, avg(score) as score, avg(WordsPerMinute) as WordsPerMinute, avg(AttemptedWords) as AttemptedWords, avg(LongestStreak),avg(TotalWordsFound) from GameStats";
    
    GameStat *avg_stat = nil;
	sqlite3_stmt *statement;
    if(sqlite3_prepare_v2(_db, [query UTF8String], -1, &statement, nil)
	   == SQLITE_OK)
	{
    	if(sqlite3_step(statement) == SQLITE_ROW) {
                int rare_words_found = sqlite3_column_int(statement, 0);
                long score = sqlite3_column_int64(statement, 1);
                int wpm = sqlite3_column_int(statement, 2);
                int attempted_words = sqlite3_column_int(statement, 3);
                int longest_streak = sqlite3_column_int(statement, 4);
                int total_words_found = sqlite3_column_int(statement, 5);
             avg_stat = [[GameStat alloc] initWithAttemptedWords:attempted_words andCurrentLanguage:nil andDatePlayed:nil andLongestStreak:longest_streak andRareWordsFound:rare_words_found andScore:score andTotalWordsFound:total_words_found andWordsPerMinute:wpm];
            
        }
		sqlite3_finalize(statement);
	}
    return avg_stat;
}

-(GameStat*) getAverageStatsForLanguage:(int)language_id{
    NSString *query = [NSString stringWithFormat:@"select avg(RareWordsFound) as RareWordsFound, avg(score) as score, avg(WordsPerMinute) as WordsPerMinute, avg(AttemptedWords) as AttemptedWords, avg(LongestStreak),avg(TotalWordsFound) from GameStats where RelatedLanguageID = %d", language_id];
    
    GameStat *avg_stat = nil;
	sqlite3_stmt *statement;
    if(sqlite3_prepare_v2(_db, [query UTF8String], -1, &statement, nil)
	   == SQLITE_OK)
	{
    	if(sqlite3_step(statement) == SQLITE_ROW) {
            int rare_words_found = sqlite3_column_int(statement, 0);
            long score = sqlite3_column_int64(statement, 1);
            int wpm = sqlite3_column_int(statement, 2);
            int attempted_words = sqlite3_column_int(statement, 3);
            int longest_streak = sqlite3_column_int(statement, 4);
            int total_words_found = sqlite3_column_int(statement, 5);
            avg_stat = [[GameStat alloc] initWithAttemptedWords:attempted_words andCurrentLanguage:nil andDatePlayed:nil andLongestStreak:longest_streak andRareWordsFound:rare_words_found andScore:score andTotalWordsFound:total_words_found andWordsPerMinute:wpm];
            
        }
		sqlite3_finalize(statement);
	}
    return avg_stat;
}
@end
