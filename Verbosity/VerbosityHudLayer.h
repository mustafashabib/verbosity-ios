//
//  VerbosityHudLayer.h
//  Verbosity
//
//  Created by Mustafa Shabib on 7/6/12.
//  Copyright (c) 2012 Betel Nut Games. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "VerbosityAlert.h"

#define kMaxAlertsToShow 5

@interface VerbosityHudLayer : CCLayer {
    CCLabelTTF *_yourScore;
    CCLabelTTF *_timeLabel;
    CCSprite *_pauseButton;
    NSMutableArray *_current_labels;
}


-(void)showPauseMenu;
-(void)showRestartMenu;

@end
