//
//  WordsAndLetters.m
//  Verbosity
//
//  Created by Mustafa Shabib on 7/5/12.
//  Copyright (c) 2012 Betel Nut Games. All rights reserved.
//

#import "WordsAndLetters.h"

@implementation WordsAndLetters

@synthesize Words;
@synthesize Letters;

-(WordsAndLetters*) initWithWords:(NSDictionary *)words andLetters:(NSArray *)letters{
    if(self = [super init]){
        self.Words = words;
        self.Letters = letters;
    }
    return self;
}

//returns nil if doesn't exist
-(Word*) getWord:(NSString *)word
{
    return (Word*)[self.Words objectForKey:word];
}

@end
