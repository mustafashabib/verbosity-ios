//
//  LetterTile.m
//  Verbosity
//
//  Created by Mustafa Shabib on 6/23/12.
//  Copyright 2012 Betel Nut Games. All rights reserved.
//

#import "LetterTile.h"
#import "VerbosityGameState.h"


static int letterID = 0;
@implementation LetterTile

-(id) initWithLetter:(Letter*)letter{
if((self = [super init]) == nil) return nil;
srandom(time(NULL));
_letter = letter;
    CCSprite* sprite = [CCSprite spriteWithFile:@"tile.png"];
    CCLabelTTF *currentLetter = [CCLabelTTF labelWithString:[letter Value] dimensions:sprite.contentSize hAlignment:kCCTextAlignmentRight fontName:[VerbosityGameState sharedState].CurrentLanguage.Font fontSize:40];
    currentLetter.color = ccc3(0, 0, 0);
    currentLetter.anchorPoint = ccp(.3,.3);
    currentLetter.position = ccp(sprite.position.x, sprite.position.y);
    _letterID = letterID++;
[sprite addChild:currentLetter];
[self addChild:sprite z:0 tag:_letterID];
_state = kLetterStateUntouched;
return self;

}
-(CGSize) getSize
{
    CCSprite* sprite = (CCSprite*)[self getChildByTag:_letterID];
    NSAssert([sprite isKindOfClass:[CCSprite class]], @"Letter - child with tag %d is not sprite", _letterID);
    return sprite.boundingBox.size;
}

+(id) letterWithLetter:(Letter*)letter
{
    return [[self alloc] initWithLetter:letter];    
}

-(void)onEnter{
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
    [super onEnter];
}

-(BOOL)containsTouchLocation:(UITouch*)touch{
    NSLog(@"containsTouch entered.");
    CCSprite* sprite = (CCSprite*)[self getChildByTag:_letterID];
    NSAssert([sprite isKindOfClass:[CCSprite class]], @"Letter - child with tag %d is not sprite", _letterID);
    return CGRectContainsPoint([sprite boundingBox], [self convertTouchToNodeSpace:touch]);
}
- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (_state != kLetterStateUntouched) return NO;
    if ( ![self containsTouchLocation:touch] ) return NO;
    
    _state = kLetterStateTouched;
    
    
    NSLog(@"touch began for %@.", _letter.Value);
    id scaleUpAction =  [CCScaleTo actionWithDuration:.35 scaleX:1.25 scaleY:1.25];
    id scaleDownAction = [CCScaleTo actionWithDuration:0.35 scaleX:1.0 scaleY:1.0];
    id seq = [CCSequence actions:scaleUpAction,scaleDownAction, nil];
    id myAction = [CCRepeatForever actionWithAction:seq];
    [self runAction:myAction];
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
    
    NSLog(@"touch ends.");
    
    NSAssert(_state == kLetterStateTouched, @"Letter - Unexpected state!");  
    CCSprite* sprite = (CCSprite*)[self getChildByTag:_letterID];
    NSAssert([sprite isKindOfClass:[CCSprite class]], @"Letter -child with tag %d is not sprite", _letterID);
    
    [self stopAllActions];
    id resetScale = [CCEaseIn actionWithAction:[CCScaleTo actionWithDuration:0.25 scale:1.0]];
    [self runAction:resetScale];
    if ( ![self containsTouchLocation:touch] ) {
        _state = kLetterStateUntouched;
        [sprite setColor:ccc3(255, 255, 255)];
        [sprite setScale:1.0];
        
    }else{
        _state = kLetterStateUsed;
        [sprite setColor:ccc3(128, 128, 128)];   
        [sprite setScale:1.0];
        
    }
    
}
@end
