//
//  NSMutableArray+Queue.m
//  Verbosity
//
//  Created by Mustafa Shabib on 7/6/12.
//  Copyright (c) 2012 We Are Mammoth. All rights reserved.
//

#import "NSMutableArray+Queue.h"
#import <Foundation/Foundation.h>


@implementation NSMutableArray (Stack)


-(void) push:(id) item {
    [self addObject:item];
}

-(id) pop {
    id r = [self lastObject];
    [self removeLastObject];
    return r;
}

-(id) peek{
    return [self lastObject];
}

@end