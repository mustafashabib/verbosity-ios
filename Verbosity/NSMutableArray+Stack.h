//
//  NSMutableArray+Queue.h
//  Verbosity
//
//  Created by Mustafa Shabib on 7/6/12.
//  Copyright (c) 2012 We Are Mammoth. All rights reserved.
//

#import <UIKit/UIKit.h>


/** This category enhances NSMutableArray by providing methods to act like a stack
 */
@interface NSMutableArray (Stack)
- (void)push:(id)item;
- (id)pop;
- (id)peek;
@end