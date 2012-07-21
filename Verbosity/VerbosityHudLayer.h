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

@interface VerbosityHudLayer : CCLayer {
    CCLabelTTF *_yourScore;
    CCLabelTTF *_timeLabel;
    CCSprite *_pauseButton;
}


-(void)showPauseMenu;
-(void)showRestartMenu;
-(void)showAlert:(VerbosityAlert*)alert;

@end
