//
//  VerbosityPreLoadLayer.m
//  Verbosity
//
//  Created by Mustafa Shabib on 8/5/12.
//  Copyright (c) 2012 Betel Nut Games. All rights reserved.
//

#import "VerbosityHowToPlayLayer.h"
#import "MainMenu.h"
#import "SimpleAudioEngine.h"
#import "VerbosityGameConstants.h"

@implementation VerbosityHowToPlayLayer


+(CCScene *) scene
{
    
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
  	// 'layer' is an autorelease object.
	VerbosityHowToPlayLayer *layer = [VerbosityHowToPlayLayer node];
    
    
    [scene addChild:layer];
    
    
	// return the scene
	return scene;
}

-(id)init{
    self = [super init];
    if(self){
        CGSize winSize = [[CCDirector sharedDirector] winSize];
       
                
        CCSprite* bg = [CCSprite spriteWithFile:@"DarkGrayBackground.jpg"];
        [bg setAnchorPoint:ccp(0,0)];
        [self addChild:bg z:0];

         
        // Set the font size for the label text
        float fontSize = VERBOSITYFONTSIZE(16);
        
        // Set the font type for the label text
        NSString *fontType = @"AmerTypewriterITCbyBT-Medium";
        
        // Create the text
        NSString *text = @"Make as many words as you can before time runs out by touching the letters.\n\nSubmit your word attempt by touching the screen with two fingers at the same time.\n\nSwipe to the left or right to cancel your attempt.\n\nShake your device or swipe downwards to shuffle your letters.\n\nBuild up your score by getting on hot streaks and by finding rare words!";
        
        
        
         CGSize actualSize = [text sizeWithFont:[UIFont fontWithName:fontType size:fontSize]
                              constrainedToSize:winSize
                                  lineBreakMode:UILineBreakModeWordWrap];
        
        // Use the actual width and height needed for our text to create a container
        CGSize containerSize = {actualSize.width, actualSize.height};
        
        // Create the label with our text (text1) and the container we created
        CCLabelTTF *instructions = [CCLabelTTF labelWithString: text
                                              dimensions:containerSize
                                               alignment:UITextAlignmentLeft
                                                fontName: fontType
                                                fontSize:fontSize];
        
        [instructions setAnchorPoint:ccp(0,1)];
        [instructions setPosition:ccp(5,winSize.height-5)];
        [self addChild:instructions];
        [CCMenuItemFont setFontSize:VERBOSITYFONTSIZE(18)];
        
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
