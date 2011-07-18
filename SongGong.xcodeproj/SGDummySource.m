//
//  DummySource.m
//  SongGong
//
//  Created by Arshad Tayyeb on 7/17/11.
//  Copyright 2011 doubleTwist Corporation. All rights reserved.
//

#import "SGDummySource.h"

@implementation SGDummySource
@synthesize playlists, sourceName, currentPlaylist, currentItem, splashColor, delegate;
- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)play:(id)sender
{
    
}

- (void)togglePlay:(id)sender
{
    
}


- (void)stop:(id)sender
{
    
}



- (id <SGMediaPlaylist>)previousPlaylist
{
    return nil;
}


- (id <SGMediaPlaylist>)nextPlaylist
{
    return nil;    
}



@end



