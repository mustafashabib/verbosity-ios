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
}

@property(nonatomic) int ID;
@property(nonatomic) NSString* Name;

-(id) initWithUniqueID:(int)uniqueID name:(NSString*)name;
@end