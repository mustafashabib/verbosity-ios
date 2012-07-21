//
//  NSMutableArray+Queue.m
//  Verbosity
//
//  Created by Mustafa Shabib on 7/6/12.
//  Copyright (c) 2012 Betel Nut Games. All rights reserved.
//

#import "NSMutableArray+Queue.h"
#import <Foundation/Foundation.h>


@implementation NSMutableArray (Queue)

- (id)getNextInLine
{
    id object = nil;
    if([self count]){
        object = [self objectAtIndex:0];
        [self removeObjectAtIndex:0];
    }
    return object;
}

@end