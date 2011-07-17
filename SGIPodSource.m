//
//  SGIPodSource.m
//  SongGong
//
//  Created by Arshad Tayyeb on 7/16/11.
//  Copyright 2011 doubleTwist Corporation. All rights reserved.
//

#import "SGIPodSource.h"
#import <MediaPlayer/MediaPlayer.h>
#import <CoreGraphics/CoreGraphics.h>

#define PREFERRED_ARTWORK_SIZE 256.0

@interface SGIPodSource ()
- (void) iPodLibraryDidChange: (id) notification;
- (void) playbackStateChanged: (id) notification;
- (void) iPodItemChanged: (id) notification;
@end

@interface SGIPodPlaylist ()
- (id)initWithiPodMediaItem:(MPMediaItem *)playlistItem;
@end

@interface SGIPodItem ()
- (id)initWithiPodItem:(MPMediaItem *)item;
@end

@implementation SGIPodSource
@synthesize playlists, sourceName, currentPlaylist, currentItem, splashColor;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        self.sourceName = @"iPod";
        self.splashColor = [UIColor colorWithRed:26.0/255.0 green:102.0/255.0 blue:77.0/255.0 alpha:1.0];
        [[NSNotificationCenter defaultCenter] addObserver:self
                               selector:@selector(playbackStateChanged:)
                                   name:MPMediaLibraryDidChangeNotification
                                 object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(iPodLibraryDidChange:) name: MPMusicPlayerControllerPlaybackStateDidChangeNotification object:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(iPodItemChanged:) name: MPMusicPlayerControllerNowPlayingItemDidChangeNotification object:nil];
        [[MPMediaLibrary defaultMediaLibrary] beginGeneratingLibraryChangeNotifications];
        [[MPMusicPlayerController applicationMusicPlayer] beginGeneratingPlaybackNotifications];
        
        MPMediaQuery *query = [MPMediaQuery playlistsQuery];

        NSMutableArray *thePlaylists = [NSMutableArray arrayWithCapacity:10];
        for (MPMediaItem *playlistItem in [query collections])
        {
            SGIPodPlaylist *playlist = [[SGIPodPlaylist alloc] initWithiPodMediaItem:playlistItem];
            [thePlaylists addObject:playlist];
            [playlist release];
        }
        self.playlists = [NSArray arrayWithArray:thePlaylists];
    }
    
    return self;
}

- (void)dealloc
{
    [[MPMediaLibrary defaultMediaLibrary] endGeneratingLibraryChangeNotifications];
    [[MPMusicPlayerController applicationMusicPlayer] endGeneratingPlaybackNotifications];

    [self.playlists release];
    [super dealloc];
}

#pragma mark -

- (void)play:(id)sender
{
    [[MPMusicPlayerController applicationMusicPlayer] stop];
    if (self.currentPlaylist == nil)
    {
        if (self.playlists.count > 0)
        {
            self.currentPlaylist = [self.playlists objectAtIndex:0];
        }
    }
    
    [[MPMusicPlayerController applicationMusicPlayer] play];
}

- (void)stop:(id)sender
{
    [[MPMusicPlayerController applicationMusicPlayer] stop];
}

- (void)setCurrentPlaylist:(id<SGMediaPlaylist>)playlist
{
    if (playlist != nil)
    {
        NSString *pid = [(SGIPodPlaylist *)playlist persistentId];
        MPMediaQuery *query = [MPMediaQuery songsQuery];
        MPMediaPropertyPredicate *mpp = [MPMediaPropertyPredicate predicateWithValue:pid forProperty:MPMediaPlaylistPropertyPersistentID comparisonType:MPMediaPredicateComparisonEqualTo];
        [query addFilterPredicate:mpp];
        
        [[MPMusicPlayerController applicationMusicPlayer] setQueueWithQuery:query];
    }
}

- (void)togglePlay:(id)sender
{
    if (self.currentItem == nil)
    {
        [self play:nil];
    } else {
        if ([MPMusicPlayerController applicationMusicPlayer].playbackState == MPMusicPlaybackStatePlaying)
        {
            [[MPMusicPlayerController applicationMusicPlayer] pause];
        } else {
            [[MPMusicPlayerController applicationMusicPlayer] play];
        }
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
    
    if ([[MPMusicPlayerController applicationMusicPlayer] playbackState] != MPMusicPlaybackStateStopped && 
        [[MPMusicPlayerController applicationMusicPlayer] currentPlaybackTime] > 3.0)
    {
        [[MPMusicPlayerController applicationMusicPlayer] setCurrentPlaybackTime:0.0];
        if ([[MPMusicPlayerController applicationMusicPlayer] playbackState] != MPMusicPlaybackStatePlaying)
        {
            [[MPMusicPlayerController applicationMusicPlayer] play];
        }
        return;
    }
    [[MPMusicPlayerController applicationMusicPlayer] skipToPreviousItem];
    [[MPMusicPlayerController applicationMusicPlayer] play];
    return;
}

- (void)playNextItem
{
    [[MPMusicPlayerController applicationMusicPlayer] skipToNextItem];
    [[MPMusicPlayerController applicationMusicPlayer] play];
    return;
}

#pragma mark - 

- (UIView *)carouselDisplayView
{
    
    return nil;
}


#pragma mark -
- (void) iPodLibraryDidChange: (id) notification 
{
    
}

- (void) playbackStateChanged:(id)notification 
{
    
}

- (void)iPodItemChanged:(id)notification
{
    MPMusicPlayerController *mpc = (MPMusicPlayerController *)[notification object];
    SGIPodItem *item = [[SGIPodItem alloc] initWithiPodItem:[mpc nowPlayingItem]];
    [self.currentPlaylist setCurrentItem:item];
    self.currentItem = item;
}

@end

@implementation SGIPodPlaylist
@synthesize title, currentItem, itemIds, persistentId;

- (id)initWithiPodMediaItem:(MPMediaItem *)playlistItem
{
    self = [super init];
    
    if (self == nil)
        return nil;
    
    self.title = [playlistItem valueForProperty:MPMediaPlaylistPropertyName];
    self.persistentId = [playlistItem valueForProperty:MPMediaPlaylistPropertyPersistentID];
    
    
    
    return self;
    
}

- (NSArray *)itemInfos
{
    MPMediaQuery *query = [MPMediaQuery songsQuery];
    MPMediaPropertyPredicate *mpp = [MPMediaPropertyPredicate predicateWithValue:self.persistentId forProperty:MPMediaPlaylistPropertyPersistentID comparisonType:MPMediaPredicateComparisonEqualTo];
    [query addFilterPredicate:mpp];
    
    NSArray *items = [query items];
    
    for (MPMediaItem *item in items)
    {
        
    }
    return nil;
}


- (id <SGMediaItem>)previousItem
{
    if ([[MPMusicPlayerController applicationMusicPlayer] playbackState] != MPMusicPlaybackStateStopped && 
        [[MPMusicPlayerController applicationMusicPlayer] currentPlaybackTime] > 3.0)
    {
        [[MPMusicPlayerController applicationMusicPlayer] setCurrentPlaybackTime:0.0];
        if ([[MPMusicPlayerController applicationMusicPlayer] playbackState] != MPMusicPlaybackStatePlaying)
        {
            [[MPMusicPlayerController applicationMusicPlayer] play];
        }
        return nil;
    }
    [[MPMusicPlayerController applicationMusicPlayer] skipToPreviousItem];
    [[MPMusicPlayerController applicationMusicPlayer] play];
    return nil;
}

- (id <SGMediaItem>)nextItem
{
    [[MPMusicPlayerController applicationMusicPlayer] skipToNextItem];
    [[MPMusicPlayerController applicationMusicPlayer] play];
    return nil;
}

- (void)playItem:(id <SGMediaItem>)item
{
    return;    
}
@end

@interface SGIPodItem ()
- (MPMediaItem *)mpItem;
@end;

@implementation SGIPodItem
@synthesize title,album,artist,thumbnail, persistentId;

- (id)initWithiPodItem:(MPMediaItem *)item
{
    if (item == nil)
        return nil;
    
    self = [super init];
    
    if (self == nil)
        return nil;
    
    self.title = [item valueForProperty:MPMediaItemPropertyTitle];
    self.artist = [item valueForProperty:MPMediaItemPropertyArtist];
    self.album = [item valueForProperty:MPMediaItemPropertyAlbumTitle];
    self.persistentId = [item valueForProperty:MPMediaItemPropertyPersistentID];
    return self;
}

- (MPMediaItem *)mpItem
{
    MPMediaQuery *query = [MPMediaQuery songsQuery];
    MPMediaPropertyPredicate *mpp = [MPMediaPropertyPredicate predicateWithValue:self.persistentId forProperty:MPMediaItemPropertyPersistentID comparisonType:MPMediaPredicateComparisonEqualTo];
    [query addFilterPredicate:mpp];
    NSArray *items = [query items];
    if (items.count > 0)
        return [items objectAtIndex:0];
    return nil;
}

- (UIImage *)thumbnail
{
    MPMediaItemArtwork *art = [[self mpItem] valueForProperty: MPMediaItemPropertyArtwork];
    return [art imageWithSize:CGSizeMake(PREFERRED_ARTWORK_SIZE, PREFERRED_ARTWORK_SIZE)];
}

- (void)togglePlay:(id)sender
{
    [[MPMusicPlayerController applicationMusicPlayer] play];
}
- (float)progress
{
    return [[MPMusicPlayerController applicationMusicPlayer] currentPlaybackTime]/[[[self mpItem] valueForProperty:MPMediaItemPropertyPlaybackDuration]doubleValue];
}
@end
