//
//  Letter.m
//  Verbosity
//
//  Created by Mustafa Shabib on 6/27/12.
//  Copyright (c) 2012 We Are Mammoth. All rights reserved.
//

#import "Letter.h"


@implementation Letter
@synthesize ID;
@synthesize Value;
@synthesize RelatedLanguage;


-(id) initWithID:(int)uniqueID andValue:(char)value andKey:(int)key andLanguage:(Language*)related_language{
    if(self = [super init]){
        self.ID = uniqueID;
        self.Value = value;
        self.Key = key;
        self.RelatedLanguage = related_language;
    }
    return self;
}
@end

