//
//  SGRdioSource.m
//  SongGong
//
//  Created by Daniel DeCovnick on 7/17/11.
//  Copyright 2011 doubleTwist Corporation. All rights reserved.
//

#import "SGRdioSource.h"

@implementation SGRdioSource
@synthesize playlists, sourceName, currentPlaylist, currentItem, splashColor, delegate;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        self.sourceName = @"Rdio";
        self.splashColor = [UIColor colorWithRed:26.0/255.0 green:58.0/255.0 blue:102.0/255.0 alpha:1.0];
        NSMutableArray *thePlaylists = [NSMutableArray arrayWithCapacity:10];
        self.playlists = [NSArray arrayWithArray:thePlaylists];
    }
    
    return self;
}
- (void)dealloc
{    
    [self.playlists release];
    [super dealloc];
}

#pragma mark -

- (void)play:(id)sender
{
    if (self.currentPlaylist == nil)
    {
        if (self.playlists.count > 0)
        {
            self.currentPlaylist = [self.playlists objectAtIndex:0];
        }
    }
    
}

- (void)stop:(id)sender
{

}

- (void)setCurrentPlaylist:(id<SGMediaPlaylist>)playlist
{
    if (playlist != nil)
    {

    }
}

- (void)togglePlay:(id)sender
{
    if (self.currentItem == nil)
    {
        [self play:nil];
    } else {
        
    }
    
    //TODO: set current playlist
    //    [[MPMusicPlayerController applicationMusicPlayer] ];
    
}

#pragma mark -


- (void)playNextPlaylist
{
    id <SGMediaPlaylist>next = [self nextPlaylist];
    if (!next)
        return;
    
    
    
}

- (void)playPreviousPlaylist
{
    id <SGMediaPlaylist>prev = [self nextPlaylist];
    if (!prev)
    {
        //Go back to "Library"
        
    }
    
    return;
}

- (id <SGMediaPlaylist>)previousPlaylist
{
    if (self.currentPlaylist)
    {
        int ind = [self.playlists indexOfObject:self.currentPlaylist];
        if (ind > 0)
        {
            return [self.playlists objectAtIndex:ind-1];
        } else {
            return nil;
        }
    }
    return nil;
}

- (id <SGMediaPlaylist>)nextPlaylist
{
    if (self.currentPlaylist)
    {
        int ind = [self.playlists indexOfObject:self.currentPlaylist];
        if (ind < (self.playlists.count-1))
        {
            return [self.playlists objectAtIndex:ind+1];
        } else {
            return [self.playlists objectAtIndex:ind];
        }
    }
    
    //default - first playlist in the list
    return self.playlists.count > 0 ? [self.playlists objectAtIndex:0] : nil;
}

#pragma mark - 

- (void)playPreviousItem
{
    
    return;
}

- (void)playNextItem
{
    return;
}




- (void) playbackStateChanged:(id)notification 
{
    
}

@end

@implementation SGRdioPlaylist
@synthesize title, currentItem, itemIds, persistentId;




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


@implementation SGRdioItem
@synthesize title,album,artist,thumbnail, persistentId;



- (UIImage *)thumbnail
{
    return nil;
}

- (void)togglePlay:(id)sender
{
    
}
- (float)progress
{
    return 0.0;
}
@end
