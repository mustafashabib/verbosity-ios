//
//  Word.h
//  Verbosity
//
//  Created by Mustafa Shabib on 6/24/12.
//  Copyright (c) 2012 We Are Mammoth. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Language.h"

@interface Word : NSObject
{
    int         ID;
    NSString*   Value; //the actual word string
    long        Key; //the prime number value of this word
    int         Popularity; //how popular this word is in its language
    Language*    RelatedLanguage;
}

@property(nonatomic) int ID;
@property(nonatomic,strong) NSString* Value;
@property(nonatomic) long Key;
@property(nonatomic) int Popularity;
@property(nonatomic, strong) Language* RelatedLanguage;


-(id) initWithUniqueId:(int)uniqueID value:(NSString *)value key:(long)key 
popularity:(int)popularity language:(Language*)language;
+(long) makeKeyForWord:(NSString*)word;

@end