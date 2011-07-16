//
//  SGGestureController.m
//  SongGong
//
//  Created by Arshad Tayyeb on 7/16/11.
//  Copyright 2011 doubleTwist Corporation. All rights reserved.
//

#import "SGGestureController.h"

@implementation SGGestureController
@synthesize gestureRecognizers = mGestureRecognizers;
@synthesize delegate;
- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}


- (void)dealloc
{
    [mGestureRecognizers release];
    [super dealloc];
}
@end
