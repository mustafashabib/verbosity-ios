//
//  VerbosityGameConstants.m
//  Verbosity
//
//  Created by Mustafa Shabib on 9/1/12.
//  Copyright (c) 2012 Betel Nut Games. All rights reserved.
//
#import "VerbosityGameConstants.h"

/// helper global c function
int VERBOSITYFONTSIZE(int num)
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return (num*2);
    }else{
        return (num);
    }
}

int VERBOSITYPOINTS(int num)
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return (num*2);
    }else{
        return (num);
    }
}
