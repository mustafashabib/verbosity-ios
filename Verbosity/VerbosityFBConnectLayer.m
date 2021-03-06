//
//  VerbosityPreLoadLayer.m
//  Verbosity
//
//  Created by Mustafa Shabib on 8/5/12.
//  Copyright (c) 2012 Betel Nut Games. All rights reserved.
//

#import "VerbosityFBConnectLayer.h"
#import "MainMenu.h"
#import "SimpleAudioEngine.h"
#import "VerbosityGameConstants.h"

@implementation VerbosityFBConnectLayer


+(CCScene *) scene
{
    
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
  	// 'layer' is an autorelease object.
	VerbosityFBConnectLayer *layer = [VerbosityFBConnectLayer node];
    
    
    [scene addChild:layer];
    
    
	// return the scene
	return scene;
}

-(id)init{
    self = [super init];
    if(self){
        [CCMenuItemFont setFontSize:VERBOSITYFONTSIZE(18)];
        
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        [CCMenuItemFont setFontSize:VERBOSITYFONTSIZE(18)];
        
        
        CCSprite* bg = [CCSprite spriteWithFile:@"DarkGrayBackground.jpg"];
        [bg setAnchorPoint:ccp(0,0)];
        [self addChild:bg z:0];
        CCMenuItem *go_back = [CCMenuItemFont itemWithString:@"Go Back" block:^(id sender){
            [[SimpleAudioEngine sharedEngine] playEffect:@"swipe_erase.wav"];
            [[CCDirector sharedDirector] replaceScene: [MainMenu scene]];
        }];
        
        CCMenu *menu = [CCMenu menuWithItems: go_back, nil];
        [menu alignItemsHorizontally];
        [menu setPosition:ccp(winSize.width/2,20)];
        [self addChild:menu];

    }
    return self;
}
@end
