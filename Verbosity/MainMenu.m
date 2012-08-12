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
        
        /*CGSize label = CGSizeMake(160., 45.);
         CCLabelTTF *label1 = [CCLabelTTF labelWithString:@"Option1 for example"
         dimensions:size
         alignment:UITextAlignmentLeft
         fontName:@"pickYourOwnFont" fontSize:16.];
         
         CCLabelTTF *label2 = [CCLabelTTF labelWithString:@"Option2 below option 1"
         dimensions:size
         alignment:UITextAlignmentLeft
         fontName:@"pickYourOwnFont" fontSize:16.];
         CCMenuItem * item1 = [CCMenuItemLabel itemWithLabel:label1];
         CCMenuItem * item2 = [CCMenuItemLabel itemWithLabel:label2];
         CCMenu * leftAlignedMenu=[CCMenu menuWithItems:item1,item2,nil];*/
         
        CGSize size = [[CCDirector sharedDirector] winSize];
#define kNumberMainMenuOptions 5
        
       
        [CCMenuItemFont setFontSize:36];

        // Reset Button
        CCMenuItem *start = [CCMenuItemFont itemWithString:@"Start" block:^(id sender){
            [[CCDirector sharedDirector] replaceScene: [VerbosityGameLayer scene]];
        }];
        CCMenuItem *stats =   [CCMenuItemFont itemWithString:@"Lifetime Stats" block:^(id sender){
            [[CCDirector sharedDirector] replaceScene: [GameStatsLayer scene]];
        }];

        CCMenuItem *settings =   [CCMenuItemFont itemWithString:@"Settings" block:^(id sender){
            [[CCDirector sharedDirector] replaceScene: [VerbositySettingsLayer scene]];
        }];
        
        CCMenuItem *how_to_play = [CCMenuItemFont itemWithString:@"How To Play" block:^(id sender){
            [[CCDirector sharedDirector] replaceScene: [VerbosityHowToPlayLayer scene]];
        }];
        
        CCMenuItem *fb = [CCMenuItemFont itemWithString:@"Facebook Connect" block:^(id sender){
            [[CCDirector sharedDirector] replaceScene: [VerbosityFBConnectLayer scene]];
        }];
      
        
        start.anchorPoint = ccp(0,.5);
        stats.anchorPoint = ccp(0,.5);
        settings.anchorPoint = ccp(0,.5);
        fb.anchorPoint = ccp(0,.5);
        how_to_play.anchorPoint = ccp(0,.5);
        CCMenu *menu = [CCMenu menuWithItems: start,settings,stats,how_to_play,fb, nil];
        
        float padding = (size.height/[menu children].count)*.1;
        [menu alignItemsVerticallyWithPadding:padding];
       
        [menu setPosition:ccp(0, size.height/2)];
        
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
        
        //blue,green,purple,roy,orange,yellow
        
        
    }
    return self;
}
@end
