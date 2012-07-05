//
//  VerbosityGameLayer.m
//  Verbosity
//
//  Created by Mustafa Shabib on 4/5/12.
//  Copyright 2012 We Are Mammoth. All rights reserved.
//

#import "VerbosityGameLayer.h"
#import "VerbosityGameState.h"
#import "LetterTile.h"


@implementation VerbosityGameLayer
// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
    CCLayerColor *bg = [CCLayerColor layerWithColor:ccc4(255,0,255,255)];
    
    [scene addChild:bg z:0];
	// 'layer' is an autorelease object.
	VerbosityGameLayer *layer = [VerbosityGameLayer node];
    
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}


-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init])) {
        VerbosityGameState* current_state = [VerbosityGameState sharedState];
        [current_state setupGame];
        CGSize winSize = [CCDirector sharedDirector].winSize;
        
        _timeLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%f", current_state.TimeLeft] fontName:@"ArialRoundedMTBold" fontSize:20];
        _timeLabel.position = CGPointMake(winSize.width/2, winSize.height);
        _timeLabel.anchorPoint = CGPointMake(.5f, 1.0f);
        
        [self addChild:_timeLabel z:-1];
        [self addLetters];
        [self scheduleUpdate];
    }
    return self;
    
}

-(void) addLetters
{
    VerbosityGameState* current_state = [VerbosityGameState sharedState];
    for(int i = 0; i < current_state.CurrentLanguage.MaximumWordLength; i++){
        Letter* current_letter = (Letter*)[current_state.CurrentWordsAndLetters.Letters objectAtIndex:i];
        LetterTile* lt = [[LetterTile alloc] initWithLetter:current_letter];
        [self addChild:lt];
    }
    
}

-(void) update:(ccTime)delta{
    [VerbosityGameState sharedState].TimeLeft -= delta;
    [_timeLabel setString:[NSString stringWithFormat:@"%f", [VerbosityGameState sharedState].TimeLeft]];
}

@end
