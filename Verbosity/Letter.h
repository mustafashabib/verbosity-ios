//
//  Letter.h
//  Verbosity
//
//  Created by Mustafa Shabib on 6/27/12.
//  Copyright (c) 2012 We Are Mammoth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Language.h"

@interface Letter : NSObject{
int ID;
char Value;
int Key; //prime number value in this alphabet
    int RelatedLanguageID;
}

@property(nonatomic) int ID;
@property(nonatomic) char Value;
@property(nonatomic) int Key;
@property(nonatomic) int RelatedLanguageID;

-(id) initWithID:(int)uniqueID andValue:(char)value andKey:(int)key andLanguage:(int)related_language_id;
+(long) makeKeyForLetters:(NSString*)letters andLanguage:(int)related_language_id;

@end
