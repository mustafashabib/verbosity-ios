//
//  CCLabelButton.m
//  Verbosity
//
//  Created by Mustafa Shabib on 8/12/12.
//  Copyright (c) 2012 Betel Nut Games. All rights reserved.
//

#import "CCLabelButton.h"

@implementation CCLabelButton

-(id) initWithString:(NSString*)text andFontName:(NSString*)font andFontSize:(float)font_size andTouchesEndBlock:(TouchEndBlock_t)block
{
    self = [super initWithString:text fontName:font fontSize:font_size];
    if(self){
        if(block){
            _block = block;
        }else _block = nil;
    }
    return self;
}


-(void)onEnter{
    
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
	[super onEnter];
}
-(void)onExit{
    [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
	[super onExit];
}
- (CGRect)rect
{
    CGSize s = [self.texture contentSize];
    return CGRectMake(0, 0, s.width, s.height);
}
-(BOOL)containsTouchLocation:(UITouch*)touch{

    return CGRectContainsPoint([self rect], [self convertTouchToNodeSpace:touch]);
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    CCLOG(@"touch began for button with text %@", string_);
    BOOL containsTouch = [self containsTouchLocation:touch];
    if(containsTouch){
        CCLOG(@"Contains touch for text %@", string_);
    }
    return containsTouch;
}


- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    
    CCLOG(@"touch moved for %@", string_);
  
    return;
    
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    
    CCLOG(@"touch ended for button with text %@", string_);
    if(_block){
        CCLOG(@"Calling block");
        _block();
    }
          
}
@end
