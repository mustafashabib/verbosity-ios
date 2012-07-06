//
//  LetterSlot.h
//  Verbosity
//
//  Created by Mustafa Shabib on 7/6/12.
//  Copyright (c) 2012 We Are Mammoth. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "cocos2d.h"

static int kLetterSlotID = 20000;
const int static kLetterSlotStartID = 20000;

@interface LetterSlot : CCNode {   
    int _slotID;
}

@property(nonatomic) int SlotID;
@end
