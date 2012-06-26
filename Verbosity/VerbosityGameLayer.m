//
//  VerbosityGameLayer.m
//  Verbosity
//
//  Created by Mustafa Shabib on 4/5/12.
//  Copyright 2012 We Are Mammoth. All rights reserved.
//

#import "VerbosityGameLayer.h"
#import "Letter.h"


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
        
        CGSize winSize = [CCDirector sharedDirector].winSize;
        _time = 120.0f;
        _timeLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%f", _time] fontName:@"ArialRoundedMTBold" fontSize:20];
        _timeLabel.position = CGPointMake(winSize.width/2, winSize.height);
        _timeLabel.anchorPoint = CGPointMake(.5f, 1.0f);
        
        [self addChild:_timeLabel z:-1];
        [self initWords];
        [self initLettersNew];
        [self scheduleUpdate];
    }
    return self;
    
}

-(void) update:(ccTime)delta{
    _time -= delta;
    [_timeLabel setString:[NSString stringWithFormat:@"%f", _time]];
}
-(void) initLettersNew
{ 
    char alphabet[26] = "abcdefghijklmnopqrstuvwxyz";
    srandom(time(NULL));
    BOOL useSpacing = NO;
    CGSize winSize = [CCDirector sharedDirector].winSize;
    
    float widthSpacing = (winSize.width/kLettersInLevel+1.0f)/(kLettersInLevel+1.0f);
    for(int i = 0; i < kLettersInLevel; i++){
        if(i>0){
            useSpacing = YES;
        }
        char letterGenerated = alphabet[arc4random()%26];
        
        CCLOG(@"letter generated is %c", letterGenerated);
        Letter* letter = [Letter letterWithLetter:letterGenerated];
        CGSize letterSize = [letter getSize];
        if(useSpacing){
            letter.position =  ccp((i*letterSize.width + letterSize.width *.5f)+widthSpacing*i, winSize.height/2);
        }else{
            letter.position = ccp(i*letterSize.width + letterSize.width *.5f, winSize.height/2);   
        }
        
        [self addChild:letter];
    }
}

-(void) initLetters{
    srandom(time(NULL));
    _letters = @"";
    CGSize winSize = [CCDirector sharedDirector].winSize;
    float widthSpacing = (winSize.width/6+1.0f)/(6+1.0f);
    BOOL useSpacing = NO;
    CGSize letterSize = CGSizeMake(winSize.width/(6+1), winSize.height/5.0f);
    for(int i = 0; i< 6; i++){
        if(i >0){
            useSpacing = YES;
        }
        int asciiCode = (int)(CCRANDOM_0_1()*26) + 65;        
        NSString* currentLetterString = [NSString stringWithFormat:@"%c", asciiCode]; // letter A-Z;
        Letter* letter = [[Letter alloc] initWithLetter:asciiCode];
        if(useSpacing){
            letter.position = ccp((i*letterSize.width + letterSize.width *.5f)+widthSpacing*i, winSize.height/2);
        }else{
            letter.position = ccp(i*letterSize.width + letterSize.width *.5f, winSize.height/2);   
        }
        
       
        [self addChild:letter];
        NSString* tempString = [NSString stringWithFormat:@"%s%s", _letters, currentLetterString];
        _letters = [NSString stringWithString:tempString];
    }
}

-(void) initWords{
    _words = [[CCArray alloc] initWithCapacity:10];
    for(int i =0; i < 10; i++){
        [_words addObject:[NSString stringWithFormat:@"word%d", i]];
    }
}
@end
