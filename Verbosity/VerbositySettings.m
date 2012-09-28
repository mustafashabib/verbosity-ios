//
//  VerbositySettings.m
//  Verbosity
//
//  Created by Mustafa Shabib on 9/27/12.
//  Copyright (c) 2012 Betel Nut Games. All rights reserved.
//

#import "VerbositySettings.h"
#import "VerbosityGameConstants.h"
#import "SimpleAudioEngine.h"

VerbositySettings *sharedInstance = nil;


@implementation VerbositySettings
@synthesize FXVolume = _fxVolume;
@synthesize ShowCapitalLetters = _showCapitalLetters;

+ (VerbositySettings*)sharedSettings{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[VerbositySettings alloc] init];
        
    });
    return sharedInstance;
}

-(float) FXVolume{
    float fxVolume = 1.0f;
    if([[NSUserDefaults standardUserDefaults] objectForKey:kFXVolumeKey] != nil){
        fxVolume = [(NSNumber*)[[NSUserDefaults standardUserDefaults] objectForKey:kFXVolumeKey] floatValue];
    }
    return fxVolume;
}

-(void)setFXVolume:(float)FXVolume{
    if(FXVolume < 0){
        FXVolume = 0;
    }
    else if(FXVolume > 1){
        FXVolume = 1;
    }
    [[SimpleAudioEngine sharedEngine] setEffectsVolume:FXVolume];
    [[NSUserDefaults standardUserDefaults] setFloat:FXVolume forKey:kFXVolumeKey];
}

-(BOOL) ShowCapitalLetters{
    BOOL showCaps = YES;
    if([[NSUserDefaults standardUserDefaults] objectForKey:kShowCapsKey] != nil){
        showCaps = [[NSUserDefaults standardUserDefaults] boolForKey:kShowCapsKey];
    }
    return showCaps;
}

-(void)setShowCapitalLetters:(BOOL)ShowCapitalLetters{
    [[NSUserDefaults standardUserDefaults] setBool:ShowCapitalLetters forKey:kShowCapsKey];
}



@end
