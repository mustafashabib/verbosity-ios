//
//  VerbsosityAlertManager.m
//  Verbosity
//
//  Created by Mustafa Shabib on 7/6/12.
//  Copyright (c) 2012 We Are Mammoth. All rights reserved.
//

#import "VerbosityAlertManager.h"
#import "NSMutableArray+Queue.h"

static VerbosityAlertManager *sharedInstance = nil;

@implementation VerbosityAlertManager
- (VerbosityAlertManager*) init{
     if(self = [super init]){
         _alert_queue = [[NSMutableArray alloc] init];
     }
    return self;
}

- (NSArray *)getAll{
    NSArray* return_value = [NSArray arrayWithArray:_alert_queue];
    [_alert_queue removeAllObjects];
    return return_value;
}

- (VerbosityAlert *)getNextAlert{
    VerbosityAlert* alert = (VerbosityAlert*)[_alert_queue getNextInLine];
    return alert;
}

- (void)addAlert:(VerbosityAlert *)alert{
    [_alert_queue addObject:alert];
}

+ (VerbosityAlertManager*)sharedAlertManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[VerbosityAlertManager alloc] init];
    });
    return sharedInstance;
}
@end
