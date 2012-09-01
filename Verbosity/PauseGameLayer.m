//
//  PauseGameLayer.m
//  Verbosity
//
//  Created by Mustafa Shabib on 8/12/12.
//  Copyright (c) 2012 Betel Nut Games. All rights reserved.
//

#import "PauseGameLayer.h"
#import "SimpleAudioEngine.h"
#import "MainMenu.h"
#import "VerbosityGameState.h"
#import "VerbosityGameConstants.h"

@implementation PauseGameLayer
+(CCScene *) scene
{
    // 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
  	// 'layer' is an autorelease object.
	PauseGameLayer *layer = [PauseGameLayer node];
    
    [scene addChild:layer];
	// return the scene
	return scene;
}

-(id)init{
    self = [super init];
    if(self){
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        CCSprite* bg = [CCSprite spriteWithFile:@"DarkGrayBackground.jpg"];
        [bg setAnchorPoint:ccp(0,0)];
        [self addChild:bg z:0];
        
        CCLabelTTF* pause = [CCLabelTTF labelWithString:@"Paused" fontName:@"AmerTypewriterITCbyBT-Medium" fontSize:VERBOSITYFONTSIZE(36)];
        [pause setPosition:ccp(size.width/2,size.height/2)];
        [self addChild:pause];
        
        [CCMenuItemFont setFontSize:VERBOSITYFONTSIZE(18)];
        
        // Reset Button
        CCMenuItemLabel *back = [CCMenuItemFont itemWithString:@"Go Back" block:^(id sender){
            [[SimpleAudioEngine sharedEngine] playEffect:@"swipe_erase.wav"];
            
            [VerbosityGameState sharedState].CurrentGameState = kGameStateReady;
            [[CCDirector sharedDirector] popScene];
        }];
        
        CCMenuItemLabel *mainmenu = [CCMenuItemFont itemWithString:@"Quit" block:^(id sender){
            [[SimpleAudioEngine sharedEngine] playEffect:@"swipe_erase.wav"];
            
            [VerbosityGameState sharedState].CurrentGameState = kGameStatePaused;
            [[CCDirector sharedDirector] replaceScene:[MainMenu scene]];
        }];

        CCMenu *menu = [CCMenu menuWithItems: back, mainmenu,nil];
        
        float padding = size.width - (back.contentSize.width + mainmenu.contentSize.width);
        [menu alignItemsHorizontallyWithPadding:padding];
        
        
        [menu setPosition:ccp( size.width/2, 20)];
        [self addChild:menu];

    }
    return self;
}
@end
