//
//  Word.m
//  Verbosity
//
//  Created by Mustafa Shabib on 6/24/12.
//  Copyright (c) 2012 We Are Mammoth. All rights reserved.
//

#import "Word.h"

@implementation Word

@synthesize ID;
@synthesize Value;
@synthesize Key;
@synthesize Popularity;
@synthesize RelatedLanguage;

- (id)initWithUniqueId:(int)uniqueID value:(NSString *)value key:(long)key 
            popularity:(int)popularity language:(Language*)language
{   
    if (self = [super init])
    {
        // Initialization code here
        self.ID = uniqueID;
        self.Value = value;
        self.Key = key;
        self.Popularity = popularity;
        self.RelatedLanguage = language;
    }
    return self;
}

+ (long) makeKeyForWord:(NSString *)word{
    long key = 1;
    const int start = 97;//Convert.ToInt32('a');
    for (int i = 0; i < [word length]; i++) {
        char c = [word characterAtIndex:i];
        key *= primeNumbers[(c) - start];
    }
    return key;
}

@end


