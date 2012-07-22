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
                // Default font size will be 22 points.
        [CCMenuItemFont setFontSize:22];
        
        // Reset Button
        CCMenuItemLabel *start = [CCMenuItemFont itemWithString:@"Start" block:^(id sender){
            [[CCDirector sharedDirector] replaceScene: [VerbosityGameLayer scene]];
        }];
        CCMenuItemLabel *stats =  [CCMenuItemFont itemWithString:@"Lifetime Stats" block:^(id sender){
            [[CCDirector sharedDirector] replaceScene: [GameStatsLayer scene]];
        }];

        CCMenu *menu = [CCMenu menuWithItems: start,stats, nil];
        
        [menu alignItemsVertically];
        
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        [menu setPosition:ccp( size.width/2, size.height/2)];
        
        
        [self addChild: menu];	
        
    }
    return self;
}
@end
