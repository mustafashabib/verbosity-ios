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
@synthesize Name;

-(id) initWithUniqueID:(int)uniqueID name:(NSString *)name{
    if(self = [super init]){
        self.ID = uniqueID;
        self.Name = name;
    }
    return self;
}
@end
