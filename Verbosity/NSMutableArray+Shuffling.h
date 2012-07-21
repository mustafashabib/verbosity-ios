//
//  NSMutableArray+Shuffling.h
//  Verbosity
//
//  Created by Mustafa Shabib on 7/5/12.
//  Copyright (c) 2012 Betel Nut Games. All rights reserved.
//

#import <UIKit/UIKit.h>

/** This category enhances NSMutableArray by providing methods to randomly
 * shuffle the elements using the Fisher-Yates algorithm.
 */
@interface NSMutableArray (Shuffling)
- (void)shuffle;
@end