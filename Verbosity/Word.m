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


