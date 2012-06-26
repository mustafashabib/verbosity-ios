//
//  Letter.h
//  Verbosity
//
//  Created by Mustafa Shabib on 4/18/12.
//  Copyright 2012 We Are Mammoth. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#define kLettersInLevel 6

typedef enum {
    kLetterStateTouched,
    kLetterStateUntouched,
    kLetterStateUsed
} LetterState;

@interface Letter : CCNode <CCTargetedTouchDelegate>{
@private 
    LetterState _state;
    char _letter;
    int _letterID;
}
-(CGSize) getSize;

+(id)letterWithLetter:(char)letter;
-(id)initWithLetter:(char)letter;

@end
