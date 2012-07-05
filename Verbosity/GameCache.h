//
//  GameCache.h
//  Verbosity
//
//  Created by Mustafa Shabib on 7/4/12.
//  Copyright (c) 2012 We Are Mammoth. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameCache : NSCache
{}
+ (GameCache *)sharedCache;
@end
