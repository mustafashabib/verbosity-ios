//
//  VerbosityGameLayer.h
//  Verbosity
//
//  Created by Mustafa Shabib on 4/5/12.
//  Copyright 2012 We Are Mammoth. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "cocos2d.h"

@interface VerbosityGameLayer : CCLayer<UIGestureRecognizerDelegate> {
    CCLabelTTF *_yourScore;
    CCLabelTTF *_timeLabel;
    CCLabelTTF *_yourStreak;
    CCArray *_otherScores;
    BOOL _shake_once;
    
}
// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;
@end
