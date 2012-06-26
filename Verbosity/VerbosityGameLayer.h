//
//  VerbosityGameLayer.h
//  Verbosity
//
//  Created by Mustafa Shabib on 4/5/12.
//  Copyright 2012 We Are Mammoth. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface VerbosityGameLayer : CCLayer {
    CCArray* _words; /*all words for this level*/
    float _time; /*time in the level*/
    CCLabelTTF *_yourScore;
    CCLabelTTF *_timeLabel;
    CCArray *_otherScores;
    NSString *_letters;
    
}
// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

-(void) initWords;
-(void) initLetters;
@end
