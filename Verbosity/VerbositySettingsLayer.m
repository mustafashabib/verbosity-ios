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
#import "VerbositySettings.h"

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
        
        float labelSize = VERBOSITYPOINTS(30);
        
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        float fxVolumeSaved = [VerbositySettings sharedSettings].FXVolume;
        BOOL showCapitalLetters = [VerbositySettings sharedSettings].ShowCapitalLetters;
        
        CCSlider* fxVolume  =
		[CCSlider sliderWithBackgroundFile: @"sliderBG.png"
							     thumbFile: @"sliderThumb.png"];
        fxVolume.ignoreAnchorPointForPosition = NO;
        
        fxVolume.value = fxVolumeSaved;
		fxVolume.tag = kSFXSliderTag;
        [fxVolume addObserver:self forKeyPath:@"value" options: NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld  context: nil];
        [fxVolume setAnchorPoint:ccp(1,.5)];
        [fxVolume setPosition:ccp(winSize.width - 5,winSize.height-30)];
        
        CCLabelTTF* fx_volume_label = [CCLabelTTF labelWithString:@"Volume" fontName:@"AmerTypewriterITCbyBT-Medium" fontSize:VERBOSITYFONTSIZE(25)];
        [fx_volume_label setAnchorPoint:ccp(0,1)];
        [fx_volume_label setPosition:ccp(5,winSize.height - 30)];
        
        CCLabelTTF* capital_letters = [CCLabelTTF labelWithString:@"Capital Letters" fontName:@"AmerTypewriterITCbyBT-Medium" fontSize:VERBOSITYFONTSIZE(25)];
        [capital_letters setAnchorPoint:ccp(0,1)];
        [capital_letters setPosition:ccp(5,fx_volume_label.position.y-labelSize)];
        [CCMenuItemFont setFontSize:VERBOSITYFONTSIZE(25)];
        
        CCMenuItem *capital_letters_yes = [CCMenuItemFont itemWithString:@"Yes"];
        CCMenuItem *capital_letters_no = [CCMenuItemFont itemWithString:@"No"];
        
        CCMenuItemToggle *capital_letter_toggle = [CCMenuItemToggle itemWithTarget:self
                                                                           selector:@selector(capitalLettersTapped:)
                                                                              items:capital_letters_yes, capital_letters_no, nil];
        
        [capital_letter_toggle setAnchorPoint:ccp(1,1)];
        if(!showCapitalLetters){
            [capital_letter_toggle setSelectedIndex:1];
        }
        
        CCMenu* cap_menu = [CCMenu menuWithItems:capital_letter_toggle, nil ];
        [cap_menu setAnchorPoint:ccp(1,1)];
        [cap_menu setPosition:ccp(winSize.width - 5,fx_volume_label.position.y-labelSize)];
        [cap_menu alignItemsHorizontally];
        [CCMenuItemFont setFontSize:VERBOSITYFONTSIZE(18)];
        
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
        [self addChild:cap_menu];
        [self addChild:fx_volume_label];
		[self addChild:fxVolume];
        [self addChild:capital_letters];
        
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
       /* [[SimpleAudioEngine sharedEngine] setEffectsVolume:value];
        [[NSUserDefaults standardUserDefaults] setFloat:value forKey:kFXVolumeKey];
        */
        [VerbositySettings sharedSettings].FXVolume = value;
        [[SimpleAudioEngine sharedEngine] playEffect:@"Letter_click.wav"];
    }
}

-(void)capitalLettersTapped: (id) sender{
    BOOL oldValue = [VerbositySettings sharedSettings].ShowCapitalLetters;
    BOOL newValue = !oldValue;
    [VerbositySettings sharedSettings].ShowCapitalLetters = newValue;
    
    [[SimpleAudioEngine sharedEngine] playEffect:@"Letter_click.wav"];
    
    CCLOG(@"Setting cap letters option to %@", newValue ? @"YES" : @"NO");
}

@end
