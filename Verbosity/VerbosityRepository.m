//
//  VerbosityRepository.m
//  Verbosity
//
//  Created by Mustafa Shabib on 6/27/12.
//  Copyright (c) 2012 We Are Mammoth. All rights reserved.
//

#import "VerbosityRepository.h"

@implementation VerbosityRepository

static VerbosityRepository *_context;

+ (VerbosityRepository*)context{
    if(_context == nil){
        _context = [[VerbosityRepository alloc] init];
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



-(NSArray*) wordsForLetters:(NSArray*) letters andLanguage:(int)language_id{
    
    NSMutableArray *retval = [[NSMutableArray alloc] init] ;
    NSString *query = @"SELECT * FROM failed_banks ORDER BY close_date DESC";
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(_database, [query UTF8String], -1, &statement, nil) 
        == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            int uniqueId = sqlite3_column_int(statement, 0);
            char *nameChars = (char *) sqlite3_column_text(statement, 1);
            char *cityChars = (char *) sqlite3_column_text(statement, 2);
            char *stateChars = (char *) sqlite3_column_text(statement, 3);
            NSString *name = [[NSString alloc] initWithUTF8String:nameChars];
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
