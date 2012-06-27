//
//  VerbosityRepository.m
//  Verbosity
//
//  Created by Mustafa Shabib on 6/27/12.
//  Copyright (c) 2012 We Are Mammoth. All rights reserved.
//

#import "VerbosityRepository.h"
#import "Word.h"
#import "Letter.h"

@implementation VerbosityRepository

static VerbosityRepository *_context;
static NSCache *_cache;

+ (VerbosityRepository*)context{
    if(_context == nil){
        _context = [[VerbosityRepository alloc] init];
    }
    if(_cache == nil){
        _cache = [[NSCache alloc] init];
    }
    return _context;
}

- (id)init {
    if ((self = [super init])) {
        NSString *sqLiteDb = [[NSBundle mainBundle] pathForResource:@"verbosity" 
                                                             ofType:@"sqlite3"];
        
        if (sqlite3_open([sqLiteDb UTF8String], &_context) != SQLITE_OK) {
            NSLog(@"Failed to open database!");
        }
    }
    return self;
}

- (void)dealloc {
    sqlite3_close(_context);
}



-(NSArray*) wordsForLetters:(NSString*) letters andLanguage:(int)language_id{
    
    NSMutableArray *retval = [[NSMutableArray alloc] init] ;
    Language* lang = [[Language alloc] init];
    lang.ID = language_id;
    
    long key = [Letter makeKeyForLetters:letters andLanguage:lang];
    
    NSString *query = @"select * from words where key < 70467397 and 70467397%key = 0 order by length(word) asc;";
    
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(_context, [query UTF8String], -1, &statement, nil) 
        == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            int uniqueId = sqlite3_column_int(statement, 0);
            char *wordChars = (char *) sqlite3_column_text(statement, 1);
            int popularity = sqlite3_column_int(statement, 2);
            sqlite3_int64 key = sqlite3_column_int64(statement, 3);
            int relatedLanguage = [[NSString alloc] initWithUTF8String:nameChars];
            NSString *city = [[NSString alloc] initWithUTF8String:cityChars];
            NSString *state = [[NSString alloc] initWithUTF8String:stateChars];
            FailedBankInfo *info = [[FailedBankInfo alloc] 
                                    initWithUniqueId:uniqueId name:name city:city state:state];                        
            [retval addObject:info];
            [name release];
            [city release];
            [state release];
            [info release];
        }
        sqlite3_finalize(statement);
    }
    return retval;
}
@end
