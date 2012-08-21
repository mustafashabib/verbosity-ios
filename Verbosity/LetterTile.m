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
    
    currentLetter.color = ccc3(0, 0, 0);
    
      currentLetter.position = ccp(sprite.position.x+.5*sprite.contentSize.width, sprite.position.y+.5*sprite.contentSize.height);
 //  currentLetter.position = ccp(sprite.position.x+.5*sprite.contentSize.width, sprite.position.y+.25*sprite.contentSize.height);
    _letterID = letterID++;
    [sprite addChild:currentLetter];
    [self addChild:sprite z:0 tag:_letterID];
    _state = kLetterStateUntouched;
    [self scheduleUpdate];
    return self;

}


-(void)setStartPosition:(CGPoint)position{
    _start_position = position;
}

-(CGSize) getSize
{
    CCSprite* sprite = (CCSprite*)[self getChildByTag:_letterID];
    NSAssert([sprite isKindOfClass:[CCSprite class]], @"Letter - child with tag %d is not sprite", _letterID);
    return sprite.contentSize;
}

+(id) letterWithLetter:(NSString*)letter
{
    return [[self alloc] initWithLetter:letter];    
}

-(void)onEnter{
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
    [super onEnter];
}
-(void)onExit{
    [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
	[super onExit];
}
-(void)instantResetState:(BOOL)should_disable{
    
    CCSprite* sprite = (CCSprite*)[self getChildByTag:_letterID];
    [sprite setColor:ccc3(255, 255, 255)];
    
    [self setPosition:_start_position];
    if(should_disable){
        _state = kLetterStateDisabled;
    }
    else{
        _state = kLetterStateUntouched;
    }
    [VerbosityGameState sharedState].CurrentWordAttempt = @"";
}

-(void)setState:(LetterState)state{
    _state = state;
}
-(void)resetState{
        
        CCMoveTo *moveToOriginalSlotAction = [[CCMoveTo alloc] initWithDuration:.125 position:_start_position];
        CCCallBlockN *reset_state =  [CCCallBlockN actionWithBlock:^(CCNode *node) {
            [((LetterTile*)node) setState:kLetterStateUntouched];
        }];
        CCSequence* seq = [CCSequence actions:moveToOriginalSlotAction,reset_state, nil];
        [self runAction:seq];
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
    
    
    //only listen to touches for "USED" and "Untouched"
    if(_state == kLetterStateUntouched){
        _startTouchState = _state;
        
        CCLOG(@"touch began for %@.", _letter);
        _state = kLetterStateTouched;
        
        return YES;
    }
    
    if(_state == kLetterStateUsed){
        _startTouchState = kLetterStateTouched;
        
        return YES;
    }
    return NO;
   
}


- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    
    CCLOG(@"touch moved for %@ with state %d", _letter, _state);
    // If it weren't for the TouchDispatcher, you would need to keep a reference
    // to the touch from touchBegan and check that the current touch is the same
    // as that one.
    // Actually, it would be even more complicated since in the Cocos dispatcher
    // you get NSSets instead of 1 UITouch, so you'd need to loop through the set
    // in each touchXXX method.
    
    return;    
    
}

-(void) update:(ccTime)delta{
    
    //get y position of a letterslot
    LetterSlot* slot = (LetterSlot*)[[self parent] getChildByTag:kLetterSlotID];
        
    if(position_.y == slot.position.y){
        _state = kLetterStateUsed;
    }
    
}
- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    
    CCLOG(@"touch ended for %@ with state %d", _letter, _state);
    
    NSAssert(_state == kLetterStateTouched || _state == kLetterStateUsed, @"Letter - Unexpected state!");  
    CCSprite* sprite = (CCSprite*)[self getChildByTag:_letterID];
    NSAssert([sprite isKindOfClass:[CCSprite class]], @"Letter -child with tag %d is not sprite", _letterID);

    if ( ![self containsTouchLocation:touch] ) {//they let go and finger not on letter
        _state = _startTouchState;//reset state back to what it was
        
    }else if(_startTouchState == kLetterStateUntouched){//about to move into a slot
        _start_position = position_;//save old position
        _state = kLetterStateUsed;//set state to used
        
        [[VerbosityGameState sharedState] updateWordAttempt:_letter withData:self];//modify word attempt
        int position = [[VerbosityGameState sharedState].CurrentWordAttempt length] -1;
        
        LetterSlot* slot = (LetterSlot*)[[self parent] getChildByTag:kLetterSlotID + position];
        CCMoveTo *moveToSlotAction = [[CCMoveTo alloc] initWithDuration:.125 position:slot.position];
        [self runAction:moveToSlotAction]; //move to slot
        
    }else if(_state == kLetterStateUsed){//about to put back into original position
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
