//
//  DefineWordLayer.m
//  Verbosity
//
//  Created by Mustafa Shabib on 9/2/12.
//  Copyright (c) 2012 Betel Nut Games. All rights reserved.
//

#import "DefineWordLayer.h"
#import "SimpleAudioEngine.h"
#import "VerbosityGameConstants.h"

@implementation DefineWordLayer
+(CCScene *) sceneWithWord:(Word*)word andDefinition:(NSString*)definition
{
    // 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
  	// 'layer' is an autorelease object.
	DefineWordLayer *layer = [DefineWordLayer nodeWithWord:word andDefinition:definition];
    
    [scene addChild:layer];
	// return the scene
	return scene;
}

+(id)nodeWithWord:(Word*)word andDefinition:(NSString*)definition{
    return  [[self alloc] initWithWord:word andDefinition:definition];
}

-(id)initWithWord:(Word*)word andDefinition:(NSString*)definition{
    self = [super init];
    if(self){
        if(word == nil) return self;
        
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        CCSprite* bottomWave = [CCSprite spriteWithFile:@"DarkGrayBackground.jpg"];
        [bottomWave setAnchorPoint:ccp(0,0)];
        [bottomWave setPosition:ccp(0,0)];
        [self addChild:bottomWave z:0];
        
        CCLabelTTF* wLabel = [CCLabelTTF labelWithString:word.Value fontName:@"AmerTypewriterITCbyBT-Medium" fontSize:VERBOSITYFONTSIZE(36)];
        [wLabel setAnchorPoint:ccp(0,1)];
        [wLabel setPosition:ccp(5,size.height)];
        [self addChild:wLabel];
        
        //really popular words will end up being nearly 0
        //the rarest word will have a value of 100
        //everything else falls in between
        float popularity_multiplier = MAX(1,100/word.Popularity);
        if(popularity_multiplier >= 75){
            [wLabel setString:[NSString stringWithFormat:@"%@ (rare word)", word.Value]];
        }

        float fontSize = VERBOSITYFONTSIZE(25);
        
        // Set the font type for the label text
        NSString *fontType = @"AmerTypewriterITCbyBT-Medium";
        
        CGSize actualSize = [definition sizeWithFont:[UIFont fontWithName:fontType size:fontSize]
                              constrainedToSize:CGSizeMake(size.width-5, size.height-30)
                                  lineBreakMode:UILineBreakModeWordWrap];
        
        // Use the actual width and height needed for our text to create a container
        CGSize containerSize = {actualSize.width, actualSize.height};
        
        
        // Create the label with our text (text1) and the container we created
        CCLabelTTF *dLabel = [CCLabelTTF labelWithString: definition
                                                  dimensions:containerSize
                                                   alignment:UITextAlignmentLeft
                                                    fontName: fontType
                                                    fontSize:fontSize];
        
       
        [dLabel setAnchorPoint:ccp(0,1)];
        [dLabel setPosition:ccp(5,size.height - wLabel.contentSize.height - 10)];
        [self addChild:dLabel];
        
        [CCMenuItemFont setFontSize:VERBOSITYFONTSIZE(18)];
        
        // Reset Button
        CCMenuItemLabel *back = [CCMenuItemFont itemWithString:@"Go Back" block:^(id sender){
            [[SimpleAudioEngine sharedEngine] playEffect:@"swipe_erase.wav"];            
            [[CCDirector sharedDirector] popScene];
        }];
        
       
        
        CCMenu *menu = [CCMenu menuWithItems: back,nil];
        
        float padding = size.width - (back.contentSize.width);
        [menu alignItemsHorizontallyWithPadding:padding];
        
        [menu setPosition:ccp( size.width/2, 20)];
        [self addChild:menu];
        
    }
    return self;
}
@end
