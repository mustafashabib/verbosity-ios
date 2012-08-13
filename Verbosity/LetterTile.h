//
//  LetterTile.h
//  Verbosity
//
//  Created by Mustafa Shabib on 4/18/12.
//  Copyright 2012 Betel Nut Games. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"


typedef enum {
    kLetterStateTouched,
    kLetterStateUntouched,
    kLetterStateUsed,
    kLetterStateDisabled
} LetterState;

@interface LetterTile : CCNode <CCTargetedTouchDelegate>{
    int _letterID;
    LetterState _startTouchState;
    LetterState _state;
@private 
    NSString* _letter;
    CGPoint _old_position;
    CGPoint _original_position;
}
-(CGSize) getSize;
@property(nonatomic) int LetterTag;

-(void)resetState;
-(void)instantResetState:(BOOL)should_disable;
-(NSString*) Letter;
-(LetterState) State;
-(id)initWithLetter:(NSString*)letter;
-(void)savePosition;
@end
