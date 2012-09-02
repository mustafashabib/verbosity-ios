//
//  LookupWord.h
//  Verbosity
//
//  Created by Mustafa Shabib on 9/2/12.
//  Copyright (c) 2012 Betel Nut Games. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^DoneLoadingWordBlock_t)(NSString* definition);
@interface LookupWordManager : NSObject

-(void) lookupDefinitionOfWord:(NSString*)word andFoundDefinitionBlock:(DoneLoadingWordBlock_t)block;

+ (LookupWordManager *)sharedLookupWordManager;
@end
