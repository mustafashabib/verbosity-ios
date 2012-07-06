//
//  WordsAndLetters.h
//  Verbosity
//
//  Created by Mustafa Shabib on 7/5/12.
//  Copyright (c) 2012 We Are Mammoth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Word.h"

@interface WordsAndLetters : NSObject{
NSDictionary* Words;
NSArray* Letters;
}
@property(nonatomic) NSDictionary* Words;
@property(nonatomic) NSArray* Letters;

-(WordsAndLetters*) initWithWords:(NSDictionary*)words andLetters:(NSArray*)letters;
-(Word*) getWord:(NSString *)word;
@end
