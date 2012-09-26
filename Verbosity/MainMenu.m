//
//  MainMenu.m
//  Verbosity
//
//  Created by Mustafa Shabib on 7/22/12.
//  Copyright (c) 2012 Betel Nut Games. All rights reserved.
//

#import "MainMenu.h"
#import "VerbosityGameLayer.h"
#import "GameStatsLayer.h"
#import "VerbosityRepository.h"
#import "VerbosityFBConnectLayer.h"
#import "VerbosityHowToPlayLayer.h"
#import "VerbositySettingsLayer.h"
#import "SimpleAudioEngine.h"
#import "VerbosityGameConstants.h"

@implementation MainMenu
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
  	// 'layer' is an autorelease object.
	MainMenu *layer = [MainMenu node];
    
    [scene addChild:layer];
	// return the scene
	return scene;
}

-(id)init{
    self = [super init];
    if(self){
        self.isTouchEnabled=YES;
        
        
         
        CGSize size = [[CCDirector sharedDirector] winSize];
#define kNumberMainMenuOptions 4
        
        [CCMenuItemFont setFontName:@"AmerTypewriterITCbyBT-Medium"];
        [CCMenuItemFont setFontSize:VERBOSITYFONTSIZE(40)];

        // Reset Button
        CCMenuItem *start = [CCMenuItemFont itemWithString:@"Start" block:^(id sender){
            [[SimpleAudioEngine sharedEngine] playEffect:@"Letter_click.wav"];
            [[CCDirector sharedDirector] replaceScene: [VerbosityGameLayer scene]];
        }];
        CCMenuItem *stats =   [CCMenuItemFont itemWithString:@"Lifetime Stats" block:^(id sender){
            [[SimpleAudioEngine sharedEngine] playEffect:@"Letter_click.wav"];
            [[CCDirector sharedDirector] replaceScene: [GameStatsLayer scene]];
        }];

        CCMenuItem *settings =   [CCMenuItemFont itemWithString:@"Settings" block:^(id sender){
            [[SimpleAudioEngine sharedEngine] playEffect:@"Letter_click.wav"];
            [[CCDirector sharedDirector] replaceScene: [VerbositySettingsLayer scene]];
        }];
        
        CCMenuItem *how_to_play = [CCMenuItemFont itemWithString:@"How To Play" block:^(id sender){
            [[SimpleAudioEngine sharedEngine] playEffect:@"Letter_click.wav"];
            [[CCDirector sharedDirector] replaceScene: [VerbosityHowToPlayLayer scene]];
        }];
        
       /* CCMenuItem *fb = [CCMenuItemFont itemWithString:@"Multiplayer" block:^(id sender){
            [[SimpleAudioEngine sharedEngine] playEffect:@"Letter_click.wav"];
            [[CCDirector sharedDirector] replaceScene: [VerbosityFBConnectLayer scene]];
        }];
        */
      
        
        start.anchorPoint = ccp(0,.5);
        stats.anchorPoint = ccp(0,.5);
        settings.anchorPoint = ccp(0,.5);
     //   fb.anchorPoint = ccp(0,.5);
        how_to_play.anchorPoint = ccp(0,.5);
        CCMenu *menu = [CCMenu menuWithItems: start,settings,stats,how_to_play, nil];
        
        float padding = (size.height/[menu children].count)*.125;
        [menu alignItemsVerticallyWithPadding:padding];
       
        [menu setPosition:ccp(10, size.height/2)];
        
        CCSprite* menu_bg = [CCSprite spriteWithFile:@"menu_corner.png"];
        [menu_bg setAnchorPoint:ccp(0,0)];
        [menu_bg setPosition:ccp(0,0)];
        //randomly color the bg
        switch(arc4random()%6){
            case 0:
                menu_bg.color = ccc3(255, 0, 0);//red
                break;
            case 1:
                menu_bg.color = ccc3(255, 164, 0);//orange
                break;
            case 2:
                menu_bg.color = ccc3(255, 255, 0);//yellow
                break;
            case 3:
                menu_bg.color = ccc3(0, 255, 0);//green
                break;
            case 4:
                menu_bg.color = ccc3(0, 0, 255);//blue
                break;
            case 5:
                menu_bg.color = ccc3(238, 130, 238);//violet
                break;
        }
        CCSprite* bg_sprite = [CCSprite spriteWithFile:@"lightGrayBackground.jpg"];
         bg_sprite.anchorPoint = ccp(0,0);
        [self addChild:bg_sprite z:0];
        [self addChild:menu_bg z:1];
        [self addChild: menu z:2];
        
        //set font back to typewriter for everything else
        [CCMenuItemFont setFontName:@"AmerTypewriterITCbyBT-Medium"];
        
        
    }
    return self;
}
@end
