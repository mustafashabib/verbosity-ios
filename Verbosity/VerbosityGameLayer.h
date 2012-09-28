//
//  VerbosityGameLayer.h
//  Verbosity
//
//  Created by Mustafa Shabib on 4/5/12.
//  Copyright 2012 Betel Nut Games. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "cocos2d.h"

@interface VerbosityGameLayer : CCLayer<UIGestureRecognizerDelegate> {
    CCLabelTTF *_yourScore;
    CCLabelTTF *_timeLabel;
    CCLabelTTF *_yourStreak;
    CCArray *_otherScores;
    BOOL _shake_once;
    BOOL _start_game;
    CCArray* _letter_positions;
    float _letter_slot_y_position;
    BOOL _gesture_active;
    
}
// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;
@end
