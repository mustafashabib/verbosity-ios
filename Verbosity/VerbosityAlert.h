//
//  VerbosityAlert.h
//  Verbosity
//
//  Created by Mustafa Shabib on 7/6/12.
//  Copyright (c) 2012 Betel Nut Games. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    kFoundRareWord,
    kScoreIncreased,
    kWordAttemptUpdated,
    kHotStreakStarted,
    kHotStreakEnded,
    kTimeRunningOut,
    kTimeNearlyDone,
    kTimeOver,
    kGreatScore,
    kFastHands,
    kFailedWordAttempt,
    kRemovedLastLetter,
    kDuplicateWord,
    kClearedAttempt,
    kColdStreakStarted,
    kColdStreakEnded
} VerbosityAlertTypes;
@interface VerbosityAlert : NSObject
{
    VerbosityAlertTypes _type;
    id _data;
} 

@property(nonatomic) VerbosityAlertTypes AlertType;
@property(nonatomic) id Data;

-(BOOL)isOneTimeAlert;
-(VerbosityAlert*) initWithType:(VerbosityAlertTypes)type andData:(id)data;
@end
