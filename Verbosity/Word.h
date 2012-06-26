//
//  Word.h
//  Verbosity
//
//  Created by Mustafa Shabib on 6/24/12.
//  Copyright (c) 2012 We Are Mammoth. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum
{
    kEnglish
} Language;

@interface Word : NSObject
{
    NSString*   Value; //the actual word string
    long        Key; //the prime number value of this word
    int         Popularity; //how popular this word is in its language
    Language    RelatedLanguage;
}

@property(nonatomic,strong) NSString* Value;
@property(nonatomic) long Key;
@property(nonatomic) int Popularity;
@property(nonatomic) Language RelatedLanguage;
@end
