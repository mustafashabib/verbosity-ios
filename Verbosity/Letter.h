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
    Language* RelatedLanguage;
}

@property(nonatomic) int ID;
@property(nonatomic) char Value;
@property(nonatomic) int Key;
@property(nonatomic,strong) Language* RelatedLanguage;

-(id) initWithID:(int)uniqueID andValue:(char)value andKey:(int)key andLanguage:(Language*)related_language;
@end
