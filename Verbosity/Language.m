//
//  Language.m
//  Verbosity
//
//  Created by Mustafa Shabib on 6/27/12.
//  Copyright (c) 2012 We Are Mammoth. All rights reserved.
//

#import "Language.h"

@implementation Language
@synthesize ID;
@synthesize Font;
@synthesize Name;
@synthesize MaximumWordLength;

-(id) initWithUniqueID:(int)uniqueID andName:(NSString *)name andFont:(NSString *)font andMaximumWordLength:(int)maxLength{
    if(self = [super init]){
        self.ID = uniqueID;
        self.Name = name;
        self.Font = font;
        self.MaximumWordLength = maxLength;
    }
    return self;
}
@end
