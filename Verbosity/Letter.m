//
//  Letter.m
//  Verbosity
//
//  Created by Mustafa Shabib on 6/27/12.
//  Copyright (c) 2012 We Are Mammoth. All rights reserved.
//

#import "Letter.h"
#import "VerbosityRepository.h"
#import "cocos2d.h"

@implementation Letter
@synthesize ID;
@synthesize Value;
@synthesize RelatedLanguageID;
@synthesize Key;


-(id) initWithID:(int)uniqueID andValue:(NSString*)value andKey:(long)key andLanguage:(int)related_language_id{
    if(self = [super init]){
        self.ID = uniqueID;
        self.Value = value;
        self.Key = key;
        self.RelatedLanguageID = related_language_id;
    }
    return self;
}

+ (long) makeKeyForLetters:(NSString *)letters andLanguage:(int)related_language_id
{
    //get the letters for this language from database
    //calculate key for the letters passed into this method
    NSDictionary* letterValues = [[VerbosityRepository context] getLettersForLanguage:related_language_id];
    
    long key = 1;
    for (int i=0; i < [letters length]; i++) {
       Letter* currentLetter = [letterValues objectForKey:[NSString stringWithFormat:@"%c", [letters characterAtIndex:i]]];
        CCLOG(@"Found letter %@ with value %ld", currentLetter.Value, currentLetter.Key);
        key *= currentLetter.Key;
    }
    return key;
}
@end

