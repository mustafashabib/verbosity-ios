//
//  VerbosityAlert.m
//  Verbosity
//
//  Created by Mustafa Shabib on 7/6/12.
//  Copyright (c) 2012 We Are Mammoth. All rights reserved.
//

#import "VerbosityAlert.h"

@implementation VerbosityAlert
@synthesize AlertType = _type;
@synthesize Data = _data;

-(VerbosityAlert*)initWithType:(VerbosityAlertTypes)type andData:(id)data{
    
    if((self = [super init]) == nil) return nil;
    
    _type = type;
    _data = data;
    return self;
}

-(BOOL)isOneTimeAlert{
    switch (_type) {
        case kTimeRunningOut://<10sec
        case kTimeNearlyDone://<5 sec
        case kTimeOver:
            return YES;
            break;
            
        default:
            return NO;
            break;
    }
}
@end
