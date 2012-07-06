//
//  VerbosityAlert.h
//  Verbosity
//
//  Created by Mustafa Shabib on 7/6/12.
//  Copyright (c) 2012 We Are Mammoth. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    kFoundRareWord,
    kScoreIncreased,
    kWordAttemptUpdated,
    kHotStreakStarted,
    kHotStreakEnded,
    kTimeRunningOut,
    kGreatScore,
    kFastHands,
    kFailedWordAttempt,
    kDuplicateWord
} VerbosityAlertTypes;
@interface VerbosityAlert : NSObject
{
    VerbosityAlertTypes _type;
    id _data;
} 

@property(nonatomic) VerbosityAlertTypes AlertType;
@property(nonatomic) id Data;

-(VerbosityAlert*) initWithType:(VerbosityAlertTypes)type andData:(id)data;
@end
