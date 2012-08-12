//
//  VerbosityPreLoadLayer.m
//  Verbosity
//
//  Created by Mustafa Shabib on 8/5/12.
//  Copyright (c) 2012 Betel Nut Games. All rights reserved.
//

#import "VerbosityTitle.h"
#import "MainMenu.h"

@implementation VerbosityTitle


+(CCScene *) scene
{
    
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
  	// 'layer' is an autorelease object.
	VerbosityTitle *layer = [VerbosityTitle node];
    
    
    [scene addChild:layer];
    
    
	// return the scene
	return scene;
}

-(id)init{
    self = [super init];
    if(self){
        
        
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        CCSprite* wave1 = [CCSprite spriteWithFile: @"GrayWave1.png"];
        CCSprite* wave4 = [CCSprite spriteWithFile:@"Graywave2.png"];
        CCSprite* wave3 = [CCSprite spriteWithFile:@"Graywave3.png"];
        CCSprite* wave2 = [CCSprite spriteWithFile:@"Graywave4.png"];
        CCSprite* wave5 = [CCSprite spriteWithFile:@"graywave5.png"];
        CCSprite* wave6 = [CCSprite spriteWithFile:@"Graywave6.png"];
        CCSprite* title = [CCSprite spriteWithFile:@"verbosityTitle.png"];
        
        title.opacity = 0; //start invisible
        title.position = ccp(winSize.width/2, winSize.height/2);
        title.zOrder = 100;
        
        wave1.anchorPoint = ccp(0,0);
        wave2.anchorPoint = ccp(0,0);
        wave3.anchorPoint = ccp(0,0);
        wave4.anchorPoint = ccp(0,0);
        wave5.anchorPoint = ccp(0,0);
        wave6.anchorPoint = ccp(0,0);
        
        wave1.position = ccp(0,-wave1.contentSize.height);//offscreen at bottom
        wave3.position = ccp(0,-wave3.contentSize.height);
        wave5.position = ccp(0,-wave5.contentSize.height);
        wave2.position = ccp(0,winSize.height + wave2.contentSize.height);//offscreen at top
        wave4.position = ccp(0,winSize.height + wave4.contentSize.height);
        wave6.position = ccp(0,winSize.height + wave6.contentSize.height);
        wave1.color = ccc3(255, 0, 0);
         wave3.color = ccc3(255, 164, 0);
         wave5.color = ccc3(255, 255, 0);
         wave2.color = ccc3(0, 255, 0);
         wave4.color = ccc3(0, 0, 255);
         wave6.color = ccc3(238, 130, 238);
        
        wave1.zOrder = 0;
        wave3.zOrder = 1;
        wave5.zOrder = 2;
        wave2.zOrder = 2;
        wave4.zOrder = 1;
        wave6.zOrder = 0;
        
        const int slow_down_factor = 5;
        const float move_in_duration =slow_down_factor* .5;
        //bottoms moving into place to top
        CCMoveTo* moveInBottom1 = [CCMoveTo actionWithDuration:move_in_duration position:ccp(0, winSize.height - (.5*wave1.contentSize.height))];
        CCMoveTo* moveInBottom2 = [CCMoveTo actionWithDuration:move_in_duration position:ccp(0, winSize.height - (.5*wave1.contentSize.height) - (.5*wave3.contentSize.height))];
        CCMoveTo* moveInBottom3 = [CCMoveTo actionWithDuration:move_in_duration position:ccp(0, winSize.height - (.5*wave1.contentSize.height) - (.5*wave3.contentSize.height) - (.5*wave5.contentSize.height))];
        CCMoveTo* moveInTop1 = [CCMoveTo actionWithDuration:move_in_duration position:ccp(0,-.4*wave2.contentSize.height)];
        CCMoveTo* moveInTop2 = [CCMoveTo actionWithDuration:move_in_duration position:ccp(0,0)];
        CCMoveTo* moveInTop3 = [CCMoveTo actionWithDuration:move_in_duration position:ccp(0,.5*wave4.contentSize.height)];
        CCCallBlock *moveFromBottomAnimations = [CCCallBlock actionWithBlock:^{
            [wave1 runAction:moveInBottom1];
            [wave3 runAction:moveInBottom2];
            [wave5 runAction:moveInBottom3];
            [wave2 runAction:moveInTop1];
            [wave4 runAction:moveInTop2];
            [wave6 runAction:moveInTop3];
        }];
                  
             
        CCFadeIn *fadeIn = [CCFadeIn actionWithDuration:move_in_duration];
        CCCallBlock *fadeInTitle = [CCCallBlock actionWithBlock:^{
            [title runAction:fadeIn];
        }];
        
        CCDelayTime *delay = [CCDelayTime actionWithDuration:6];
        CCCallBlock* mainmenu_scene = [CCCallBlock actionWithBlock:^{
            CCLOG(@"Showing main menu");
            [[CCDirector sharedDirector] replaceScene:[MainMenu scene]];
        }];
        
        CCSequence *showtitle = [CCSequence actions:fadeInTitle,delay,mainmenu_scene,nil];
        [self addChild:wave1];
        [self addChild:wave2];
        [self addChild:wave3];
        [self addChild:wave4];
        [self addChild:wave5];
        [self addChild:wave6];
        [self addChild:title];
        
        //[self runAction:bottomToTop];
        //[self runAction:topToBottom];
        [self runAction:moveFromBottomAnimations];
        [title runAction:showtitle];
    }
    return self;
}
@end
