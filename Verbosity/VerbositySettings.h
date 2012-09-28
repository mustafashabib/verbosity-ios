//
//  VerbositySettings.h
//  Verbosity
//
//  Created by Mustafa Shabib on 9/27/12.
//  Copyright (c) 2012 Betel Nut Games. All rights reserved.
//

#import <Foundation/Foundation.h>

// global settings for the game
// accessing them via their properties gets from nsuserdefaults
// and setting them via their properties sets them 
@interface VerbositySettings : NSObject{
    float _fxVolume;
    BOOL _showCapitalLetters;
}

+ (VerbositySettings *)sharedSettings;

@property(nonatomic) float FXVolume;
@property(nonatomic) BOOL ShowCapitalLetters;

@end
