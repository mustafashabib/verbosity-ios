//
//  Word.h
//  Verbosity
//
//  Created by Mustafa Shabib on 6/24/12.
//  Copyright (c) 2012 Betel Nut Games. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Language.h"

@interface Word : NSObject
{
    int         ID;
    NSString*   Value; //the actual word string
    long        Key; //the prime number value of this word
    int         Popularity; //how popular this word is in its language
    int    RelatedLanguageID;
}

@property(nonatomic) int ID;
@property(nonatomic,strong) NSString* Value;
@property(nonatomic) long Key;
@property(nonatomic) int Popularity;
@property(nonatomic) int RelatedLanguageID;


-(id) initWithUniqueId:(int)uniqueID value:(NSString *)value key:(long)key 
popularity:(int)popularity language:(int)language;

@end