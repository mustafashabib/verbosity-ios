//
//  CCLabelButton.h
//  Verbosity
//
//  Created by Mustafa Shabib on 8/12/12.
//  Copyright (c) 2012 Betel Nut Games. All rights reserved.
//

typedef void (^TouchEndBlock_t)();
@interface CCLabelButton : CCLabelTTF<CCTargetedTouchDelegate>{
    TouchEndBlock_t _block;
}
-(id) initWithString:(NSString*)text andFontName:(NSString*)font andFontSize:(float)font_size andTouchesEndBlock:(TouchEndBlock_t)block;
@end
