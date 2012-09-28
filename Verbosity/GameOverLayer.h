//
//  GameOverLayer.h
//  Verbosity
//
//  Created by Mustafa Shabib on 7/10/12.
//  Copyright (c) 2012 Betel Nut Games. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"

@interface GameOverLayer : CCLayer
{
    UIViewController *_viewController;
}
// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;


@end
