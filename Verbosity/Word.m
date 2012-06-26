//
//  Word.m
//  Verbosity
//
//  Created by Mustafa Shabib on 6/24/12.
//  Copyright (c) 2012 We Are Mammoth. All rights reserved.
//

#import "Word.h"

@implementation Word
@synthesize Value;
@synthesize Key;
@synthesize Popularity;
@synthesize RelatedLanguage;

-(id) initWithValue:(NSString*)value andKey:(long)key andPopularity:(int)popularity andLanguage:(Language)related_language
{
    if (self = [super init])
    {
        // Initialization code here
        self.Value = value;
        self.Key = key;
        self.Popularity = popularity;
        self.RelatedLanguage = related_language;
    }
    return self;
}

@end


