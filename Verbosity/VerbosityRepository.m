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

@implementation VerbosityRepository

+ (VerbosityRepository *)context {
	if(_context == nil) {
		_context = [[VerbosityRepository alloc] init];
	}

	return _context;
}

- (id)init {
	if((self = [super init])) {
		NSString *sqLiteDb = [[NSBundle mainBundle] pathForResource:kDatabaseName
															 ofType:@"sqlite3"];

		if(sqlite3_open([sqLiteDb UTF8String], &_context) != SQLITE_OK) {          
            NSLog(@"Failed to open database!");
		}
	}
	return self;
}

- (void)dealloc {
	sqlite3_close(_context);
}


- (NSArray *)getLanguages {
    NSMutableArray *languages = [[NSMutableArray alloc] init];
    NSString *query = @"select id,name, font,maximumwordlength from Languages;";
	sqlite3_stmt *statement;
    
	if(sqlite3_prepare_v2(_context, [query UTF8String], -1, &statement, nil)
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
    
	if(sqlite3_prepare_v2(_context, [query UTF8String], -1, &statement, nil)
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

@end
