//
//  LetterTile.h
//  Verbosity
//
//  Created by Mustafa Shabib on 4/18/12.
//  Copyright 2012 We Are Mammoth. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"


typedef enum {
    kLetterStateTouched,
    kLetterStateUntouched,
    kLetterStateUsed
} LetterState;

@interface LetterTile : CCNode <CCTargetedTouchDelegate>{
    int _letterID;
    LetterState _state;
@private 
    NSString* _letter;
    CGPoint _old_position;
    float _old_rotation;
}
-(CGSize) getSize;
@property(nonatomic) int LetterTag;

-(void)resetState;
-(void)instantResetState;
-(NSString*) Letter;
-(LetterState) State;
-(id)initWithLetter:(NSString*)letter;

@end
