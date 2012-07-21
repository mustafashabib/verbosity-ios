//
//  Word.m
//  Verbosity
//
//  Created by Mustafa Shabib on 6/24/12.
//  Copyright (c) 2012 Betel Nut Games. All rights reserved.
//

#import "Word.h"

@implementation Word

@synthesize ID;
@synthesize Value;
@synthesize Key;
@synthesize Popularity;//the lower this #, the rarer the word is, with 1 being the minimum - this is actually a count of how often this word was found in our corpus
@synthesize RelatedLanguageID;

- (id)initWithUniqueId:(int)uniqueID value:(NSString *)value key:(long)key 
            popularity:(int)popularity language:(int)language
{   
    if (self = [super init])
    {
        // Initialization code here
        self.ID = uniqueID;
        self.Value = value;
        self.Key = key;
        self.Popularity = popularity;
        self.RelatedLanguageID = language;
    }
    return self;
}



@end


