//
//  VerbsosityAlertManager.h
//  Verbosity
//
//  Created by Mustafa Shabib on 7/6/12.
//  Copyright (c) 2012 We Are Mammoth. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "VerbosityAlert.h"
@interface VerbosityAlertManager : NSObject
{
    
    NSMutableArray* _alert_queue;
    NSMutableSet* _seen_alerts;
}


+ (VerbosityAlertManager *)sharedAlertManager;
-(void) addAlert:(VerbosityAlert*)alert;
-(VerbosityAlert*) getNextAlert;
-(NSArray*) getAll;
@end
