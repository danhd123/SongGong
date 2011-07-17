//
//  SGIPodSource.m
//  SongGong
//
//  Created by Arshad Tayyeb on 7/16/11.
//  Copyright 2011 doubleTwist Corporation. All rights reserved.
//

#import "SGIPodSource.h"

@implementation SGIPodSource
@synthesize playlists, sourceName, currentPlaylist;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (id <SGMediaPlaylist>)previousPlaylist
{
    return nil;
}

- (id <SGMediaPlaylist>)nextPlaylist
{
    return nil;
}
- (UIView *)carouselDisplayView
{
    UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ipod-icon"]];
    return [iv autorelease];
}
@end

@implementation SGIPodPlaylist
@synthesize title, currentItem;

- (id <SGMediaItem>)previousItem
{
    return nil;
}

- (id <SGMediaItem>)nextItem
{
    return nil;
}

- (void)playItem:(id <SGMediaItem>)item
{
    return;    
}
@end

@implementation SGIPodItem
@synthesize title,album,artist,thumbnail;

- (void)togglePlay:(id)sender
{
    
}

@end
