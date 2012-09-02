//
//  DefineWordLayer.h
//  Verbosity
//
//  Created by Mustafa Shabib on 9/2/12.
//  Copyright (c) 2012 Betel Nut Games. All rights reserved.
//


#import "CCLayer.h"
#import "Word.h"
@interface DefineWordLayer : CCLayer{
}
+(CCScene *) sceneWithWord:(Word*)word andDefinition:(NSString*)definition;
@end
