//
//  VerbosityPreLoadLayer.m
//  Verbosity
//
//  Created by Mustafa Shabib on 8/5/12.
//  Copyright (c) 2012 Betel Nut Games. All rights reserved.
//

#import "VerbosityPreLoadLayer.h"
#import "VerbosityTitle.h"
#import "SimpleAudioEngine.h"
#import "VerbosityGameConstants.h"

@implementation VerbosityPreLoadLayer
+(CCScene *) scene
{
    
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
  	// 'layer' is an autorelease object.
	VerbosityPreLoadLayer *layer = [VerbosityPreLoadLayer node];
    CCSprite* bg = [CCSprite spriteWithFile:@"bg.png"];
    bg.anchorPoint = ccp(0,0);
    [layer addChild:bg];
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    CCLabelTTF* loading_label = [CCLabelTTF labelWithString:@"Loading..." fontName:@"YellowSubmarine" fontSize:VERBOSITYFONTSIZE(28)];
    loading_label.color = ccGRAY;
    loading_label.position = ccp(winSize.width,0);
    loading_label.anchorPoint = ccp(1,0);
    
    /*preload images*/
    CCCallBlock *preload = [CCCallBlock actionWithBlock:^{
    CCLOG(@"Preloading images");
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"textures.plist"];
        /*
    [[CCTextureCache sharedTextureCache] addImage: @"DarkGrayBackground.jpg"];
    [[CCTextureCache sharedTextureCache] addImage: @"GrayWave1.png"];
    [[CCTextureCache sharedTextureCache] addImage:  @"GrayWave2.png"];
    [[CCTextureCache sharedTextureCache] addImage:  @"GrayWave1.png"];
    [[CCTextureCache sharedTextureCache] addImage:  @"Graywave2.png"];
    [[CCTextureCache sharedTextureCache] addImage:  @"Graywave3.png"];
    [[CCTextureCache sharedTextureCache] addImage:  @"Graywave4.png"];
    [[CCTextureCache sharedTextureCache] addImage:  @"graywave5.png"];
    [[CCTextureCache sharedTextureCache] addImage:  @"Graywave6.png"];
    [[CCTextureCache sharedTextureCache] addImage:  @"lightGrayBackground.jpg"];
    [[CCTextureCache sharedTextureCache] addImage:  @"tileblack.png"];
    [[CCTextureCache sharedTextureCache] addImage:  @"tilewhite.png"];
    [[CCTextureCache sharedTextureCache] addImage:  @"verbosityTitle.png"];
    [[CCTextureCache sharedTextureCache] addImage:  @"menu_corner.png"];*/

        

    
    CCLOG(@"Done Preloading images");
    
    /*preload sounds*/
    CCLOG(@"Preloading sounds");
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"already_got_word.wav"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"failed_word.wav"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"fast_hands_2.wav"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"Great_Score_1.wav"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"Letter_click.wav"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"swipe_erase.wav"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"Word_accept-2.wav"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"Word_accept.wav"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"icebeak.wav"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"hotstreak_end.wav"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"ding.wav"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"seven_letter.wav"];
    
    CCLOG(@"Done Preloading sounds");
        
        //todo: check for new languages, new messages from server, etc
        //todo: update any active games/invites
    }];
    
    CCCallBlock* mainmenu_scene = [CCCallBlock actionWithBlock:^{
        CCLOG(@"Showing main menu");
        [[CCDirector sharedDirector] replaceScene:[VerbosityTitle scene]];
    }];
    
    CCSequence *funcsec =[CCSequence actions:preload,mainmenu_scene, nil];
    
    [layer addChild:loading_label];
    [scene addChild:layer];
    [scene runAction:funcsec];
	// return the scene
	return scene;
}
@end
