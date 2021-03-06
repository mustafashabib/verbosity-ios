//
//  LetterSlot.m
//  Verbosity
//
//  Created by Mustafa Shabib on 7/6/12.
//  Copyright (c) 2012 Betel Nut Games. All rights reserved.
//

#import "LetterSlot.h"

@implementation LetterSlot
@synthesize SlotID = _slotID;

-(LetterSlot*) init{
    if((self = [super init]) == nil) return nil;
    CCSprite* sprite = [CCSprite spriteWithFile:@"tileblack.png"];
    _slotID = kLetterSlotID++;
    [self addChild:sprite z:0 tag:_slotID];
    return self;
}
@end
