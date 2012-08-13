//
//  VerbosityPreLoadLayer.m
//  Verbosity
//
//  Created by Mustafa Shabib on 8/5/12.
//  Copyright (c) 2012 Betel Nut Games. All rights reserved.
//

#import "VerbositySettingsLayer.h"
#import "VerbosityGameConstants.h"
#import "MainMenu.h"
#import "SimpleAudioEngine.h"

@implementation VerbositySettingsLayer


+(CCScene *) scene
{
    
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
  	// 'layer' is an autorelease object.
	VerbositySettingsLayer *layer = [VerbositySettingsLayer node];
    
    
    [scene addChild:layer];
    
    
	// return the scene
	return scene;
}

-(id) init{
    self = [super init];
    if(self){
        [CCMenuItemFont setFontSize:18];
        
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        float fxVolumeSaved = 1.0f;
        if([[NSUserDefaults standardUserDefaults] objectForKey:kFXVolumeKey] != nil){
            fxVolumeSaved = [(NSNumber*)[[NSUserDefaults standardUserDefaults] objectForKey:kFXVolumeKey] floatValue];
        }
        CCSlider* fxVolume  =
		[CCSlider sliderWithBackgroundFile: @"sliderBG.png"
							     thumbFile: @"sliderThumb.png"];
		
        fxVolume.value = fxVolumeSaved;
		fxVolume.tag = kSFXSliderTag;
        [fxVolume addObserver:self forKeyPath:@"value" options: NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld  context: nil];
        [fxVolume setPosition:ccp(winSize.width/2 + (.15*winSize.width), winSize.height/2)];
        
        CCLabelTTF* fx_volume_label = [CCLabelTTF labelWithString:@"Volume" fontName:@"AmerTypewriterITCbyBT-Medium" fontSize:36];
        [fx_volume_label setAnchorPoint:ccp(1,.5)];
        [fx_volume_label setPosition:ccp(winSize.width/2,winSize.height/2)];
        
        CCMenuItem *go_back = [CCMenuItemFont itemWithString:@"Go Back" block:^(id sender){
             [[SimpleAudioEngine sharedEngine] playEffect:@"swipe_erase.wav"];
            [[CCDirector sharedDirector] replaceScene: [MainMenu scene]];
        }];
        CCMenu *menu = [CCMenu menuWithItems: go_back, nil];
        [menu alignItemsHorizontally];
        [menu setPosition:ccp(winSize.width/2,20)];
        
        CCSprite* bg = [CCSprite spriteWithFile:@"DarkGrayBackground.jpg"];
        [bg setAnchorPoint:ccp(0,0)];
        [self addChild:bg z:0];
        
        [self addChild:menu];
        [self addChild:fx_volume_label];
		[self addChild:fxVolume];
        
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([object isKindOfClass: [CCSlider class] ] && [keyPath isEqualToString: @"value"])
    {
        NSNumber *valueObject = [change objectForKey: NSKeyValueChangeNewKey];
        float value = [valueObject floatValue];
        
        NSNumber *prevValueObject = [change objectForKey: NSKeyValueChangeOldKey];
        float prevValue = [prevValueObject floatValue];
        
        CCLOG(@"Setting sfx volume to %f from %f", value, prevValue);
        [[SimpleAudioEngine sharedEngine] setEffectsVolume:value];
        [[NSUserDefaults standardUserDefaults] setFloat:value forKey:kFXVolumeKey];
        [[SimpleAudioEngine sharedEngine] playEffect:@"Letter_click.wav"];
    }
}

@end
