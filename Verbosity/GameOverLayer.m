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
#import "social/Social.h"
#import "accounts/Accounts.h"
#import "FlurryAnalytics.h"

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
        [FlurryAnalytics logEvent:@"game completed"];
        _viewController = [[UIViewController alloc] init];
        
        CCSprite* bg = [CCSprite spriteWithFile:@"DarkGrayBackground.jpg"];
        [bg setAnchorPoint:ccp(0,0)];
        [self addChild:bg z:0];

        self.isTouchEnabled=YES;
        VerbosityGameState* currentState = [VerbosityGameState sharedState];
        VerbosityRepository* repository = [VerbosityRepository context];
        BOOL set_high_score = [repository saveStats:currentState.Stats];
        CGSize winSize = [CCDirector sharedDirector].winSize;
        /*UITextView* textView = [[UITextView alloc] initWithFrame:CGRectMake(0,0,winSize.width,winSize.height)];
        
        [textView setEditable:NO];
        textView.showsVerticalScrollIndicator = NO;
        textView.showsHorizontalScrollIndicator = NO;
        textView.alwaysBounceVertical = YES;
        */
        // Set the font size for the label text
        float fontSize = VERBOSITYFONTSIZE(25);
        float labelSize = VERBOSITYPOINTS(30);
        
        // Set the font type for the label text
        NSString *fontType = @"AmerTypewriterITCbyBT-Medium";
        //score
        //poss words
        //found word
        //attempted words
        //longest hot streak
        //longest cold streak
        //add 12 labels
        CCLabelTTF* score = [CCLabelTTF labelWithString:@"Score" fontName:fontType fontSize:fontSize];
        
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setNumberStyle: NSNumberFormatterDecimalStyle];
        NSString *formattedScore = [numberFormatter stringFromNumber:[NSNumber numberWithLong:currentState.Stats.Score]];

        CCLabelTTF* scoreV = [CCLabelTTF labelWithString:formattedScore fontName:fontType fontSize:fontSize];
        [score setAnchorPoint:ccp(0,1)];
        [score setPosition:ccp(5,winSize.height-VERBOSITYPOINTS(30))];
        [scoreV setAnchorPoint:ccp(1,1)];
        [scoreV setPosition:ccp(winSize.width-5,winSize.height-VERBOSITYPOINTS(30))];
        [scoreV setColor:ccGREEN];
        if(set_high_score){
            [score setString:@"New High Score"];
            CCTintTo *tintToWhiteAction = [CCTintTo actionWithDuration:.25 red:255 green:255 blue:255];
            CCTintTo *tintToGreenAction = [CCTintTo actionWithDuration:.25 red:0 green:255 blue:0];
            [score runAction:[CCRepeatForever actionWithAction:[CCSequence actionOne:tintToWhiteAction two:tintToGreenAction]]];
            [scoreV runAction:[CCRepeatForever actionWithAction:[CCSequence actionOne:[tintToWhiteAction copy] two:[tintToGreenAction copy]]]];
            
        }
        
        CCLabelTTF* possWords = [CCLabelTTF labelWithString:@"Possible Words" fontName:fontType fontSize:fontSize];
        CCLabelTTF* possWordsV = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d", currentState.CurrentWordsAndLetters.Words.count] fontName:fontType fontSize:fontSize];
        [possWords setAnchorPoint:ccp(0,1)];
        [possWords setPosition:ccp(5,score.position.y - labelSize)];
        [possWordsV setAnchorPoint:ccp(1,1)];
        [possWordsV setPosition:ccp(winSize.width-5,scoreV.position.y - labelSize)];
        [possWordsV setColor:ccGREEN];
        
        CCLabelTTF* foundWords = [CCLabelTTF labelWithString:@"Found Words" fontName:fontType fontSize:fontSize];
        float percentTotalCorrect = currentState.FoundWords.count*100.0f/currentState.CurrentWordsAndLetters.Words.count; 
        CCLabelTTF* foundWordsV = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d (%.0f%% of total)", currentState.FoundWords.count, percentTotalCorrect] fontName:fontType fontSize:fontSize];
        [foundWords setAnchorPoint:ccp(0,1)];
        [foundWords setPosition:ccp(5,possWords.position.y - labelSize)];
        [foundWordsV setAnchorPoint:ccp(1,1)];
        [foundWordsV setPosition:ccp(winSize.width-5,possWordsV.position.y - labelSize)];
        [foundWordsV setColor:ccGREEN];
        if(percentTotalCorrect > 50){
            [foundWordsV setColor:ccGREEN];
        }else if( percentTotalCorrect > 25){
            [foundWordsV setColor:ccYELLOW];
        }else{
            [foundWordsV setColor:ccRED];
        }
        
        
        CCLabelTTF* attemptedWords = [CCLabelTTF labelWithString:@"Attempted Words" fontName:fontType fontSize:fontSize];
        float percentCorrect = 0;
        if(currentState.Stats.AttemptedWords > 0){
            percentCorrect = currentState.FoundWords.count*100.0f/currentState.Stats.AttemptedWords;
        }
        CCLabelTTF* attemptedWordsV = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d (%.0f%% correct)", currentState.Stats.AttemptedWords, percentCorrect] fontName:fontType fontSize:fontSize];
        [attemptedWords setAnchorPoint:ccp(0,1)];
        [attemptedWords setPosition:ccp(5,foundWords.position.y - labelSize)];
        [attemptedWordsV setAnchorPoint:ccp(1,1)];
        [attemptedWordsV setPosition:ccp(winSize.width-5,foundWordsV.position.y - labelSize)];
        if(percentCorrect > 50){
            [attemptedWordsV setColor:ccGREEN];
        }else if( percentCorrect > 25){
            [attemptedWordsV setColor:ccYELLOW];
        }else{
            [attemptedWordsV setColor:ccRED];
        }
        
        CCLabelTTF* hotStreak = [CCLabelTTF labelWithString:@"Best Hot Streak" fontName:fontType fontSize:fontSize];
          CCLabelTTF* hotStreakV = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d", currentState.Stats.LongestStreak] fontName:fontType fontSize:fontSize];
        [hotStreak setAnchorPoint:ccp(0,1)];
        [hotStreak setPosition:ccp(5,attemptedWords.position.y - labelSize)];
        [hotStreakV setAnchorPoint:ccp(1,1)];
        [hotStreakV setPosition:ccp(winSize.width-5,attemptedWordsV.position.y - labelSize)];
        [hotStreakV setColor:ccc3(255,215,0)];
        
        CCLabelTTF* coldStreak = [CCLabelTTF labelWithString:@"Worst Cold Streak" fontName:fontType fontSize:fontSize];
       CCLabelTTF* coldStreakV = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d", currentState.Stats.LongestColdStreak] fontName:fontType fontSize:fontSize];
        [coldStreak setAnchorPoint:ccp(0,1)];
        [coldStreak setPosition:ccp(5,hotStreak.position.y - labelSize)];
        [coldStreakV setAnchorPoint:ccp(1,1)];
        [coldStreakV setPosition:ccp(winSize.width-5,hotStreakV.position.y - labelSize)];
        [coldStreakV setColor:ccc3(135, 206, 250)];
        
        
        
        CCLabelTTF* rareWords = [CCLabelTTF labelWithString:@"Rare Words Found" fontName:fontType fontSize:fontSize];
        CCLabelTTF* rareWordsV = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d", currentState.Stats.RareWordsFound] fontName:fontType fontSize:fontSize];
        [rareWords setAnchorPoint:ccp(0,1)];
        [rareWords setPosition:ccp(5,coldStreak.position.y - labelSize)];
        [rareWordsV setAnchorPoint:ccp(1,1)];
        [rareWordsV setPosition:ccp(winSize.width-5,coldStreakV.position.y - labelSize)];
        [rareWordsV setColor:ccGREEN];
        
       
        CCLayer* statsPage = [CCLayer node];
        [statsPage setContentSize:CGSizeMake(winSize.width-5, winSize.height-30)];
        CGPoint next_label_pos = ccp(5,rareWords.position.y - labelSize);
        if(NSClassFromString(@"SLComposeViewController") != nil) {
        if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]){
            CCLabelButton* sharefb = [[CCLabelButton alloc] initWithString:@"Share on Facebook" andFontName:fontType andFontSize:fontSize andTouchesEndBlock:^{
                //todo share on fb logic
                SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
                SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result){
                    if (result == SLComposeViewControllerResultCancelled)
                    {
                        
                        CCLOG(@"Cancelled");
                        [FlurryAnalytics logEvent:@"Cacnelled Share on FB"];
                    }
                    else
                    {
                        CCLOG(@"Done");
                         [FlurryAnalytics logEvent:@"Shared on FB"];
                    }
                     [_viewController dismissViewControllerAnimated:YES completion:nil];
                };
                controller.completionHandler =myBlock;
                NSString* message_text = @"Prove you're an erudite wordsmith prodigy and play Verbosity on your iPhone, iPad, or iPod Touch!";
                if(currentState.Stats.TotalWordsFound > 0){
                    message_text = [NSString stringWithFormat:@"Did you know that %@ was a word? Prove you're an erudite wordsmith prodigy, too, and beat my score of %@ on Verbosity!", currentState.RarestWordFound, formattedScore];
                }
                [controller setInitialText:message_text];
                [controller addURL:[NSURL URLWithString:@"http://itunes.com/app/Verbosity"]];
                
                               
                [[[CCDirector sharedDirector] view] addSubview:_viewController.view];
                
                [_viewController presentViewController:controller animated:YES completion:nil];;
            }];
            [sharefb setAnchorPoint:ccp(0,1)];
            [sharefb setPosition:next_label_pos];
            next_label_pos = ccp(5,sharefb.position.y - labelSize);
            [statsPage addChild:sharefb];
        }
        if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]){
            
            CCLabelButton* sharetwit = [[CCLabelButton alloc] initWithString:@"Share on Twitter" andFontName:fontType andFontSize:fontSize andTouchesEndBlock:^{
                //todo share on tiwtter logic
                SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
                SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result){
                    if (result == SLComposeViewControllerResultCancelled)
                    {
                        
                        CCLOG(@"Cancelled");
                        
                        [FlurryAnalytics logEvent:@"Cancelled share on Twitter"];
                    }
                    else
                    {
                        CCLOG(@"Done");
                        
                        [FlurryAnalytics logEvent:@"Shared on Twitter"];
                    }
                    [_viewController dismissViewControllerAnimated:YES completion:nil];
                };
                controller.completionHandler =myBlock;
                NSString* message_text = @"Prove you're an erudite wordsmith prodigy and play Verbosity on your iPhone, iPad, or iPod Touch!";
                if(currentState.Stats.TotalWordsFound > 0){
                    message_text = [NSString stringWithFormat:@"Prove you're an erudite wordsmith prodigy and beat my score of %@ on Verbosity! http://bit.ly/OsSnzF", formattedScore];
                }
                [controller setInitialText:message_text];
                [controller addURL:[NSURL URLWithString:@"http://itunes.com/app/Verbosity"]];
                
                
                [[[CCDirector sharedDirector] view] addSubview:_viewController.view];
                
                [_viewController presentViewController:controller animated:YES completion:nil];;

            }];
            [sharetwit setAnchorPoint:ccp(0,1)];
            [sharetwit setPosition:next_label_pos];
            [statsPage addChild:sharetwit];
        }
        }
        
        [statsPage addChild:score];
        [statsPage addChild:scoreV];
        
        [statsPage addChild:possWords];
        [statsPage addChild:possWordsV];
        
        [statsPage addChild:foundWords];
        [statsPage addChild:foundWordsV];
        
        [statsPage addChild:attemptedWords];
        [statsPage addChild:attemptedWordsV];
        
        [statsPage addChild:hotStreak];
        [statsPage addChild:hotStreakV];
        
        [statsPage addChild:coldStreak];
        [statsPage addChild:coldStreakV];
        
        [statsPage addChild:rareWords];
        [statsPage addChild:rareWordsV];
        
        [self addChild:statsPage];
        
        
        //words page
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
        
        
        CCLabelTTF* fake_label = [CCLabelTTF labelWithString:@"W" fontName:@"AmerTypewriterITCbyBT-Medium" fontSize:VERBOSITYFONTSIZE(22)];
        
        int max_word_width =fake_label.contentSize.width*currentState.Stats.CurrentLanguage.MaximumWordLength;
       
        int num_columns = 3;
        int num_padding = num_columns+1;
        
        int h_padding = (winSize.width- (num_columns*max_word_width))/num_padding;
        int v_padding = VERBOSITYPOINTS(8);
        
        float half_max_word_width = max_word_width*.5f;
        
        int total_words_per_column = (winSize.height-30)/(fake_label.contentSize.height+v_padding);
        int total_words_per_layer = total_words_per_column*num_columns;
        int layers_required =ceil((double)count/total_words_per_layer);//ceiling to get the last bit
        NSMutableArray* layers_array = [[NSMutableArray alloc] init];
        for(int i = 0; i < layers_required; i++){
            [layers_array addObject:[CCLayer node]];
        }
        int word_labels_made_count = 0;
        for(int current_layer_idx = 0; current_layer_idx < layers_required; current_layer_idx++){
            CCLayer* current_layer = [layers_array objectAtIndex:current_layer_idx];
           
            int start_y_position = winSize.height - VERBOSITYPOINTS(30);//first position under menu
            int start_x_position = h_padding;
            
            for(int current_column = 0; current_column < num_columns; current_column++){
                for(int current_word_in_col =0; current_word_in_col < total_words_per_column; current_word_in_col++){
                    if(word_labels_made_count >= count){
                        break;
                    }
                    
                    int current_label_x_position = start_x_position + half_max_word_width + (current_column*max_word_width);
                    int current_label_y_position = start_y_position - (current_word_in_col * (VERBOSITYPOINTS(22)+v_padding));
                    Word* word = (Word*)[[VerbosityGameState sharedState].CurrentWordsAndLetters.Words objectForKey:[sortedWords objectAtIndex:word_labels_made_count]];
                    CCLabelTTF* current_word_label = [CCLabelTTF labelWithString:word.Value fontName:fontType fontSize:fontSize];
                   /* CCLabelButton* current_word_label = [[CCLabelButton alloc] initWithString:word.Value andFontName:@"AmerTypewriterITCbyBT-Medium" andFontSize:fontSize andTouchesEndBlock:^{
                           // http://www.merriam-webster.com/dictionary/cupule
                            NSURL *url = [[ NSURL alloc ] initWithString: [NSString stringWithFormat:@"http://www.merriam-webster.com/dictionary/%@", word.Value ]];
                            [[UIApplication sharedApplication] openURL:url];
                                            }];
                    */

                    if(![[VerbosityGameState sharedState].FoundWords containsObject:word.Value]){
                        [current_word_label setColor:ccc3(65, 65, 65)];
                    }else{
                        [current_word_label setColor:ccWHITE];
                    }
                    
                    [current_word_label setAnchorPoint:ccp(0,1)];
                    [current_word_label setPosition:ccp(current_label_x_position, current_label_y_position)];
                    [current_layer addChild:current_word_label];
                    word_labels_made_count++;

                }
            }
        }
        
                   
        /*
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
               CCLabelTTF* current_word_label = [CCLabelTTF labelWithString:word.Value fontName:@"AmerTypewriterITCbyBT-Medium" fontSize:VERBOSITYFONTSIZE(22)];
//            CCLabelButton* current_word_label = [[CCLabelButton alloc] initWithString:word.Value andFontName:@"AmerTypewriterITCbyBT-Medium" andFontSize:fontSize andTouchesEndBlock:^{
//                    
//                [[LookupWordManager sharedLookupWordManager] lookupDefinitionOfWord:word.Value andFoundDefinitionBlock:^(NSString *definition) {
//                    CCLOG(@"definition of %@: %@", word.Value, definition);
//                    if(definition != nil){
//                        [[CCDirector sharedDirector] pushScene:[DefineWordLayer sceneWithWord:word andDefinition:definition]];
//                    }else{
//                        [[CCDirector sharedDirector] pushScene:[DefineWordLayer sceneWithWord:word andDefinition:@"N/A"]];
//                    }
//                }];
//                if(NSClassFromString(@"UIReferenceLibraryViewController")) {
//                                
//                    if ([UIReferenceLibraryViewController dictionaryHasDefinitionForTerm:word.Value] == YES)
//                    {
//                        [UIReferenceLibraryViewController attemptRotationToDeviceOrientation];
//                        
//                         UIReferenceLibraryViewController *reference =
//                        [[UIReferenceLibraryViewController alloc] initWithTerm:word.Value];
//                        reference.view.center = CGPointMake(winSize.width/2, winSize.height/2);
//                        reference.view.transform = CGAffineTransformMakeRotation(CC_DEGREES_TO_RADIANS(90.0f));
//                        AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
//                        
//                        [app.navController presentModalViewController: reference animated:YES];
//                    }
//                }
//                 
//           }];
            
            if(![[VerbosityGameState sharedState].FoundWords containsObject:word.Value]){
                [current_word_label setColor:ccc3(65, 65, 65)];
            }else{
                [current_word_label setColor:ccWHITE];
            }
               [current_word_label setAnchorPoint:ccp(0,1)];
                  [current_word_label setPosition:ccp(current_label_x_position, current_label_y_position)];
                  [current_layer addChild:current_word_label];
           
           }
       }*/
        
        CCScrollLayer* scroll_layer = [[CCScrollLayer alloc] initWithLayers:layers_array widthOffset:0];
        [scroll_layer setVisible:NO];
        [self addChild:scroll_layer];
        
        // Default font size will be 22 points.
        [CCMenuItemFont setFontSize:VERBOSITYFONTSIZE(22)];
        [CCMenuItemFont setFontName:@"AmerTypewriterITCbyBT-Medium"];
        
        CCMenuItemLabel *show_stats = [CCMenuItemFont itemWithString:@"Stats" block:^(id sender){
            [FlurryAnalytics logEvent:@"showing stats"];
            [[SimpleAudioEngine sharedEngine] playEffect:@"Letter_click.wav"];
            [scroll_layer setVisible:NO];
            [statsPage setVisible:YES];
            
        }];
        CCMenuItemLabel *show_words = [CCMenuItemFont itemWithString:@"Words" block:^(id sender){
            [FlurryAnalytics logEvent:@"showing words"];
            [[SimpleAudioEngine sharedEngine] playEffect:@"Letter_click.wav"];
            [scroll_layer setVisible:YES];
            [statsPage setVisible:NO];
        }];
        // Reset Button
        CCMenuItemLabel *reset = [CCMenuItemFont itemWithString:@"Play Again" block:^(id sender){
            [FlurryAnalytics logEvent:@"play again"];
            [[SimpleAudioEngine sharedEngine] playEffect:@"Great_Score_1.wav"];
            [[CCDirector sharedDirector] replaceScene: [VerbosityGameLayer scene]];
        }];
        CCMenuItemLabel *main_menu = [CCMenuItemFont itemWithString:@"Main Menu" block:^(id sender){
            [FlurryAnalytics logEvent:@"go back to main menu from game over"];
            [[SimpleAudioEngine sharedEngine] playEffect:@"swipe_erase.wav"];
            
            [[CCDirector sharedDirector] replaceScene: [MainMenu scene]];
        }];
        
        
        CCMenu *menu = [CCMenu menuWithItems: show_stats, show_words, reset, main_menu, nil];
        [menu setAnchorPoint:ccp(.5,1)];
        [menu setPosition:ccp(winSize.width/2,winSize.height-VERBOSITYPOINTS(10))];
        [menu alignItemsHorizontallyWithPadding:VERBOSITYPOINTS(30)];
        
        CCLayerColor* bg_layer = [CCLayerColor layerWithColor:ccc4(64,64,64, 128)];
        bg_layer.contentSize = CGSizeMake(menu.contentSize.width, VERBOSITYPOINTS(24));
        bg_layer.position = ccp(winSize.width/2, winSize.height);
        bg_layer.anchorPoint = ccp(.5,1);
        bg_layer.ignoreAnchorPointForPosition = NO;
        [self removeChildByTag:987356 cleanup:YES];
        [self addChild:bg_layer z:0 tag:987356];

        [self addChild: menu];
        
      
    }
    return self;
}
@end
