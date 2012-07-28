//
//  VerbosityRepository.h
//  Verbosity
//
//  Created by Mustafa Shabib on 6/27/12.
//  Copyright (c) 2012 Betel Nut Games. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "WordsAndLetters.h"
#import "GameStat.h"
#import "HistoricalGameStat.h"

#if IS_LITE_VERSION
#define kDatabaseName @"verbosityLite"
#else
#define kDatabaseName @"verbosity"
#endif

#define kMinimumWordsForGame 20
#define kDBVersion 1

/* repository which gathers data from the database*/
/*schema is as follows
 
 CREATE TABLE GameStats(id INTEGER PRIMARY KEY AUTOINCREMENT, datePlayed INTEGER NOT NULL, RareWordsFound integer, Score integer NOT NULL, RelatedLanguageID INTEGER NOT NULL, WordsPerMinute INTEGER NOT NULL, AttemptedWords INTEGER NOT NULL, LongestStreak INTEGER NOT NULL, TotalWordsFound integer not null default 0, FOREIGN KEY(RelatedLanguageID) REFERENCES Languages(id));
 CREATE TABLE Languages(id INTEGER PRIMARY KEY AUTOINCREMENT,name text not null,font text not null, maximumwordlength integer not null);
 CREATE TABLE Words(id INTEGER PRIMARY KEY AUTOINCREMENT, word text not null, popularity integer not null, key integer not null,RelatedLanguageID integernot null, FOREIGN KEY(RelatedLanguageID) REFERENCES Languages(id));

 */
@interface VerbosityRepository : NSObject{
  sqlite3 *_context;
}

+ (VerbosityRepository*)context;
+ (void) loadDatabase;
-(WordsAndLetters*) getWordsForLanguage:(int)language_id withAtLeastOneWordOfLength:(int)length;
-(NSArray*) getLanguages;
//todo: once extracted stats into own object then pull it back here and save it
-(void) saveStats:(GameStat*)stat;

-(GameStat*) getAverageStats;
-(GameStat*) getAverageStatsForLanguage:(int)language_id;
-(HistoricalGameStat*) getHistoricalBestStats;
-(HistoricalGameStat*) getHistoricalBestStatsForLanguage:(int)language_id;
-(void) addNewLanguageFromFile:(NSString*)script_path;
@end



