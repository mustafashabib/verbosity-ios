//
//  Language.h
//  Verbosity
//
//  Created by Mustafa Shabib on 6/27/12.
//  Copyright (c) 2012 We Are Mammoth. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Language : NSObject{
    int ID;
    NSString* Name;
    NSString* Font;
    int MaximumWordLength;
}

@property(nonatomic) int ID;
@property(nonatomic) NSString* Name;
@property(nonatomic) NSString* Font;
@property(nonatomic) int MaximumWordLength;

-(id) initWithUniqueID:(int)uniqueID andName:(NSString*)name andFont:(NSString*)font andMaximumWordLength:(int)maxLength;
@end