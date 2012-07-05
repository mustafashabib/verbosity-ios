//
//  LetterTile.h
//  Verbosity
//
//  Created by Mustafa Shabib on 4/18/12.
//  Copyright 2012 We Are Mammoth. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Letter.h"


typedef enum {
    kLetterStateTouched,
    kLetterStateUntouched,
    kLetterStateUsed
} LetterState;

@interface LetterTile : CCNode <CCTargetedTouchDelegate>{
@private 
    LetterState _state;
    Letter* _letter;
    int _letterID;
}
-(CGSize) getSize;

-(id)initWithLetter:(Letter*)letter;

@end
