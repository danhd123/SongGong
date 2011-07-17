
//
//  main.m
//  SongGong
//
//  Created by Arshad Tayyeb on 7/15/11.
//  Copyright 2011 doubleTwist Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SongGongAppDelegate.h"

int main(int argc, char *argv[])
{
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    int retVal = UIApplicationMain(argc, argv, nil, NSStringFromClass([SongGongAppDelegate class]));
    [pool release];
    return retVal;
}
