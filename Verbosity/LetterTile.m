//
//  LetterTile.m
//  Verbosity
//
//  Created by Mustafa Shabib on 6/23/12.
//  Copyright 2012 Betel Nut Games. All rights reserved.
//

#import "LetterTile.h"
#import "VerbosityGameState.h"
#import "LetterSlot.h"
#import "VerbosityGameConstants.h"
#import "NSMutableArray+Stack.h"
#import "VerbosityGameLayer.h"

static int letterID = 0;
@implementation LetterTile

@synthesize LetterTag = _letterID;

-(NSString*) Letter{
    return _letter;
}

-(LetterState) State{
    return _state;
}
-(id) initWithLetter:(NSString*)letter{
    if((self = [super init]) == nil) return nil;
    _letter = letter;
    
    CCSprite* sprite = [CCSprite spriteWithFile:@"tilewhite.png"];
    CCLabelTTF *currentLetter = [CCLabelTTF labelWithString:letter dimensions:sprite.contentSize hAlignment:kCCTextAlignmentCenter fontName:[VerbosityGameState sharedState].Stats.CurrentLanguage.Font fontSize:40];
   // CCLabelTTF *currentLetter = [CCLabelTTF labelWithString:letter dimensions:sprite.contentSize hAlignment:kCCTextAlignmentRight fontName:@"ArialMT" fontSize:40];
    
    currentLetter.color = ccc3(0, 0, 0);
    
      currentLetter.position = ccp(sprite.position.x+.5*sprite.contentSize.width, sprite.position.y+.5*sprite.contentSize.height);
 //  currentLetter.position = ccp(sprite.position.x+.5*sprite.contentSize.width, sprite.position.y+.25*sprite.contentSize.height);
    
    _letterID = letterID++;
    [sprite addChild:currentLetter];
    [self addChild:sprite z:0 tag:_letterID];
    _state = kLetterStateUntouched;
    
    return self;

}

-(void)savePosition{
    _old_position = position_;
}

-(CGSize) getSize
{
    CCSprite* sprite = (CCSprite*)[self getChildByTag:_letterID];
    NSAssert([sprite isKindOfClass:[CCSprite class]], @"Letter - child with tag %d is not sprite", _letterID);
    return sprite.boundingBox.size;
}

+(id) letterWithLetter:(NSString*)letter
{
    return [[self alloc] initWithLetter:letter];    
}

-(void)onEnter{
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
    [super onEnter];
}

-(void)instantResetState:(BOOL)should_disable{
    
    [self stopAllActions];
    _state = kLetterStateUntouched;
    CCSprite* sprite = (CCSprite*)[self getChildByTag:_letterID];
    [sprite setColor:ccc3(255, 255, 255)];
    [sprite setScale:1.0];
    
    [self setPosition:_old_position];
    if(should_disable){
        _state = kLetterStateDisabled;
    }
    [VerbosityGameState sharedState].CurrentWordAttempt = @"";    
    
    
}
-(void)resetState{
    if(_state == kLetterStateUntouched){
        return;
    }
    
    [self stopAllActions];
    _state = kLetterStateUntouched;
    
    CCSprite* sprite = (CCSprite*)[self getChildByTag:_letterID];
    [sprite setColor:ccc3(255, 255, 255)];
    [sprite setScale:1.0];
    
    CCMoveTo *moveToOriginalSlotAction = [[CCMoveTo alloc] initWithDuration:.125 position:_old_position];
    [self runAction:moveToOriginalSlotAction];
    
}

-(BOOL)containsTouchLocation:(UITouch*)touch{
    CCSprite* sprite = (CCSprite*)[self getChildByTag:_letterID];
    NSAssert([sprite isKindOfClass:[CCSprite class]], @"Letter - child with tag %d is not sprite", _letterID);
    return CGRectContainsPoint([sprite boundingBox], [self convertTouchToNodeSpace:touch]);
}
- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (_state != kLetterStateUntouched && _state != kLetterStateUsed) return NO;
    if ( ![self containsTouchLocation:touch] ) return NO;
    
    
    if(_state != kLetterStateUsed){
        NSLog(@"touch began for %@.", _letter);
        id scaleUpAction =  [CCScaleTo actionWithDuration:.35 scaleX:1.25 scaleY:1.25];
        id scaleDownAction = [CCScaleTo actionWithDuration:0.35 scaleX:1.0 scaleY:1.0];
        id seq = [CCSequence actions:scaleUpAction,scaleDownAction, nil];
        id myAction = [CCRepeatForever actionWithAction:seq];
        [self runAction:myAction];
        _state = kLetterStateTouched;
        
    }
   
    return YES;
}


- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    
    NSLog(@"touch moved.");
    // If it weren't for the TouchDispatcher, you would need to keep a reference
    // to the touch from touchBegan and check that the current touch is the same
    // as that one.
    // Actually, it would be even more complicated since in the Cocos dispatcher
    // you get NSSets instead of 1 UITouch, so you'd need to loop through the set
    // in each touchXXX method.
    
    return;    
    
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    
    
    NSAssert(_state == kLetterStateTouched || _state == kLetterStateUsed, @"Letter - Unexpected state!");  
    CCSprite* sprite = (CCSprite*)[self getChildByTag:_letterID];
    NSAssert([sprite isKindOfClass:[CCSprite class]], @"Letter -child with tag %d is not sprite", _letterID);
    
    [self stopAllActions];
    id resetScale = [CCEaseIn actionWithAction:[CCScaleTo actionWithDuration:0.25 scale:1.0]];
    [self runAction:resetScale];
    if ( ![self containsTouchLocation:touch] ) {
        _state = kLetterStateUntouched;
        [sprite setColor:ccc3(255, 255, 255)];
        [sprite setScale:1.0];
        
    }else if(_state != kLetterStateUsed){
        _old_position = self.position;
        _state = kLetterStateUsed;
        //[sprite setColor:ccc3(128, 128, 128)];   
        [sprite setScale:1.0];
        
        [[VerbosityGameState sharedState] updateWordAttempt:_letter withData:self];//modify word attempt
        int position = [[VerbosityGameState sharedState].CurrentWordAttempt length] -1;
        
        LetterSlot* slot = (LetterSlot*)[[self parent] getChildByTag:kLetterSlotID + position];
        CCMoveTo *moveToSlotAction = [[CCMoveTo alloc] initWithDuration:.125 position:slot.position];
        CCRotateTo *rotateToZero = [[CCRotateTo alloc] initWithDuration:.125 angle:0];
        [self runAction:rotateToZero];
        [self runAction:moveToSlotAction];
    }else if(_state == kLetterStateUsed){
        LetterTile* last_letter = [[VerbosityGameState sharedState].SelectedLetters peek];
        if(self == last_letter)
            {
                CCLOG(@"Touched last letter %@", _letter);
                [self resetState];
                [[VerbosityGameState sharedState] removeLastLetterFromWordAttempt];
            }else{
                CCLOG(@"Touched non-last letter %@", _letter);
            }
    }
}
@end
