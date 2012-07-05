//
//  GameCache.m
//  Verbosity
//
//  Created by Mustafa Shabib on 7/4/12.
//  Copyright (c) 2012 We Are Mammoth. All rights reserved.
//

#import "GameCache.h"
static GameCache *sharedInstance = nil;

@implementation GameCache


+ (GameCache*)sharedCache{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[GameCache alloc] init];
    });
    return sharedInstance;
}
@end
