//
//  VerbosityRepository.h
//  Verbosity
//
//  Created by Mustafa Shabib on 6/27/12.
//  Copyright (c) 2012 We Are Mammoth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface VerbosityRepository : NSObject{
  sqlite3 *_context;
}

+ (VerbosityRepository*)context;

-(NSArray*) getWordsForLetters:(NSArray*) letters andLanguage:(int)language_id;
-(NSArray*) getLettersForLanguage:(int) language_id;
-(NSArray*) getLanguages;

//local high scores?
@end



