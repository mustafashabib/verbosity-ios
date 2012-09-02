//
//  GameOverLayer.m
//  Verbosity
//
//  Created by Mustafa Shabib on 7/10/12.
//  Copyright (c) 2012 Betel Nut Games. All rights reserved.
//

#import "GameOverLayer.h"
#import "VerbosityGameLayer.h"
#import "VerbosityGameState.h"
#import "CCUIViewWrapper.h"
#import "VerbosityRepository.h"
#import "Word.h"
#import "MainMenu.h"
#import "SimpleAudioEngine.h"
#import "VerbosityGameConstants.h"
#import "CCLabelButton.h"
#import "CCScrollLayer.h"
#import "AppDelegate.h"
#import "DefineWordLayer.h"
#import "LookupWordManager.h"

@implementation GameOverLayer
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
  	// 'layer' is an autorelease object.
	GameOverLayer *layer = [GameOverLayer node];
    
    [scene addChild:layer];
	// return the scene
	return scene;
}

-(id)init{
    self = [super init];
    if(self){
        CCSprite* bg = [CCSprite spriteWithFile:@"DarkGrayBackground.jpg"];
        [bg setAnchorPoint:ccp(0,0)];
        [self addChild:bg z:0];

        self.isTouchEnabled=YES;
        VerbosityGameState* currentState = [VerbosityGameState sharedState];
        VerbosityRepository* repository = [VerbosityRepository context];
        [repository saveStats:currentState.Stats];
        CGSize winSize = [CCDirector sharedDirector].winSize;
        /*UITextView* textView = [[UITextView alloc] initWithFrame:CGRectMake(0,0,winSize.width,winSize.height)];
        
        [textView setEditable:NO];
        textView.showsVerticalScrollIndicator = NO;
        textView.showsHorizontalScrollIndicator = NO;
        textView.alwaysBounceVertical = YES;
        */
        // Set the font size for the label text
        float fontSize = VERBOSITYFONTSIZE(25);
        
        // Set the font type for the label text
        NSString *fontType = @"AmerTypewriterITCbyBT-Medium";
        
        NSString* stats = [NSString stringWithFormat:@"Score: %ld\nPossible Words: %d\nFound Word: %d\nAttempted Words: %d\n%0f%% Correct\n%0f%% Found\nWPM: %d\nLongest Streak: %d\n", 
                        currentState.Stats.Score,
                        currentState.CurrentWordsAndLetters.Words.count,
                        currentState.FoundWords.count,
                        currentState.Stats.AttemptedWords,
                        currentState.FoundWords.count*100.0f/currentState.Stats.AttemptedWords,
                        currentState.FoundWords.count*100.0f/currentState.CurrentWordsAndLetters.Words.count,
                        currentState.Stats.WordsPerMinute,
                        currentState.Stats.LongestStreak];
        CCLayer* statsPage = [CCLayer node];
        
        CGSize actualSize = [stats sizeWithFont:[UIFont fontWithName:fontType size:fontSize]
                             constrainedToSize:CGSizeMake(winSize.width-5, winSize.height-30)
                                 lineBreakMode:UILineBreakModeWordWrap];
        
        // Use the actual width and height needed for our text to create a container
        CGSize containerSize = {actualSize.width, actualSize.height};
        
        // Create the label with our text (text1) and the container we created
        CCLabelTTF *statsLabel = [CCLabelTTF labelWithString: stats
                                                    dimensions:containerSize
                                                     alignment:UITextAlignmentLeft
                                                      fontName: fontType
                                                      fontSize:fontSize];
        
        [statsPage setContentSize:CGSizeMake(winSize.width-5, winSize.height-30)];
         
        [statsLabel setAnchorPoint:ccp(0,1)];
        [statsLabel setPosition:ccp(5,winSize.height-30)];
        [statsPage addChild:statsLabel];
        [self addChild:statsPage];
        NSArray* keyArray = [[VerbosityGameState sharedState].CurrentWordsAndLetters.Words allKeys];
        NSArray* sortedWords = [keyArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NSString* word1 = (NSString*)obj1;
            NSString* word2 = (NSString*)obj2;
            NSNumber* len1 = [NSNumber numberWithUnsignedInt:[word1 length]];
            NSNumber* len2 = [NSNumber numberWithUnsignedInt:[word2 length]];
            
            return [len1 compare:len2];
        }];
        
        
        
        int count = [sortedWords count];
        //create as many layers as necessary to show all the words
        //we know that we can fit winSize.height/([labelSize height] + padding) words vertically on the screen at once.
        //so we need totalWords/wordsOnScreen layers
        int padding = 5;
        
        CCLabelTTF* fake_label = [CCLabelTTF labelWithString:@"W" fontName:@"AmerTypewriterITCbyBT-Medium" fontSize:VERBOSITYFONTSIZE(22)];
        int max_word_width =fake_label.contentSize.width*currentState.Stats.CurrentLanguage.MaximumWordLength;
        int num_columns = winSize.width/(max_word_width);
        
        int total_words_per_column = (winSize.height-30)/(fake_label.contentSize.height+padding);
        int total_words_per_layer = total_words_per_column*num_columns;
        int layers_required =ceil((double)count/total_words_per_layer);//ceiling to get the last bit
        NSMutableArray* layers_array = [[NSMutableArray alloc] init];
        for(int i = 0; i < layers_required; i++){
            [layers_array addObject:[CCLayer node]];
        }
        
       for(int current_layer_idx = 0; current_layer_idx < layers_required; current_layer_idx++){
           CCLayer* current_layer = [layers_array objectAtIndex:current_layer_idx];
           [current_layer setContentSize:winSize];
           
           int current_label_y_position = winSize.height - 30;
           int current_label_x_position = padding;
           int label_number_in_layer = 0;
           for(int i = current_layer_idx*total_words_per_layer; i < (current_layer_idx+1)*total_words_per_layer; i++){
               if(i >= count){
                   break;
               }
               int current_column_number = floor((double)label_number_in_layer/total_words_per_column);
               current_label_x_position = (current_column_number*max_word_width)+(current_column_number*padding);
               int label_in_column_number = label_number_in_layer - (current_column_number*total_words_per_column);//first index
               current_label_y_position = (winSize.height-30) - (label_in_column_number*fake_label.contentSize.height);
               if(label_in_column_number > 0){
                   current_label_y_position -= padding;
               }
               label_number_in_layer++;
            Word* word = (Word*)[[VerbosityGameState sharedState].CurrentWordsAndLetters.Words objectForKey:[sortedWords objectAtIndex:i]];
            CCLabelButton* current_word_label = [[CCLabelButton alloc] initWithString:word.Value andFontName:@"AmerTypewriterITCbyBT-Medium" andFontSize:VERBOSITYFONTSIZE(25) andTouchesEndBlock:^{
                    
                [[LookupWordManager sharedLookupWordManager] lookupDefinitionOfWord:word.Value andFoundDefinitionBlock:^(NSString *definition) {
                    CCLOG(@"definition of %@: %@", word.Value, definition);
                    if(definition != nil){
                        [[CCDirector sharedDirector] pushScene:[DefineWordLayer sceneWithWord:word andDefinition:definition]];
                    }else{
                        [[CCDirector sharedDirector] pushScene:[DefineWordLayer sceneWithWord:word andDefinition:@"N/A"]];
                    }
                }];
                /*if(NSClassFromString(@"UIReferenceLibraryViewController")) {
                                
                    if ([UIReferenceLibraryViewController dictionaryHasDefinitionForTerm:word.Value] == YES)
                    {
                         UIReferenceLibraryViewController *reference =
                        [[UIReferenceLibraryViewController alloc] initWithTerm:word.Value];
                        reference.view.center = CGPointMake(winSize.width/2, winSize.height/2);
                        reference.view.transform = CGAffineTransformMakeRotation(CC_DEGREES_TO_RADIANS(90.0f));
                        
                        [[[CCDirector sharedDirector] view] addSubview:reference.view];
                    }
                }*/
                 
            }];
            
            if(![[VerbosityGameState sharedState].FoundWords containsObject:word.Value]){
                [current_word_label setColor:ccc3(65, 65, 65)];
            }else{
                [current_word_label setColor:ccWHITE];
            }
               [current_word_label setAnchorPoint:ccp(0,1)];
                  [current_word_label setPosition:ccp(current_label_x_position, current_label_y_position)];
                  [current_layer addChild:current_word_label];
           
           }
       }
        CCScrollLayer* scroll_layer = [[CCScrollLayer alloc] initWithLayers:layers_array widthOffset:0];
        [scroll_layer setVisible:NO];
        [self addChild:scroll_layer];
        
        // Default font size will be 22 points.
        [CCMenuItemFont setFontSize:VERBOSITYFONTSIZE(22)];
        [CCMenuItemFont setFontName:@"AmerTypewriterITCbyBT-Medium"];
        
        CCMenuItemLabel *show_stats = [CCMenuItemFont itemWithString:@"Stats" block:^(id sender){
            [[SimpleAudioEngine sharedEngine] playEffect:@"Letter_click.wav"];
            [scroll_layer setVisible:NO];
            [statsPage setVisible:YES];
            
        }];
        CCMenuItemLabel *show_words = [CCMenuItemFont itemWithString:@"Words" block:^(id sender){
            [[SimpleAudioEngine sharedEngine] playEffect:@"Letter_click.wav"];
            [scroll_layer setVisible:YES];
            [statsPage setVisible:NO];
        }];
        // Reset Button
        CCMenuItemLabel *reset = [CCMenuItemFont itemWithString:@"Play Again" block:^(id sender){
            [[SimpleAudioEngine sharedEngine] playEffect:@"Great_Score_1.wav"];
            [[CCDirector sharedDirector] replaceScene: [VerbosityGameLayer scene]];
        }];
        CCMenuItemLabel *main_menu = [CCMenuItemFont itemWithString:@"Main Menu" block:^(id sender){
            [[SimpleAudioEngine sharedEngine] playEffect:@"swipe_erase.wav"];
            
            [[CCDirector sharedDirector] replaceScene: [MainMenu scene]];
        }];
        CCMenu *menu = [CCMenu menuWithItems: show_stats, show_words, reset, main_menu, nil];
        
        [menu setAnchorPoint:ccp(.5,1)];
        [menu setPosition:ccp(winSize.width/2,winSize.height-10)];
        [menu alignItemsHorizontallyWithPadding:30];
        
        [self addChild: menu];
        
      
    }
    return self;
}
@end
