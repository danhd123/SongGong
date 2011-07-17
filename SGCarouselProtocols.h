//
//  SGCarouselProtocols.h
//  SongGong
//
//  Created by Daniel DeCovnick on 7/16/11.
//  Copyright 2011 doubleTwist Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SGMediaItem, SGMediaPlaylist, SGCarouselItem;

@protocol SGCarouselItemViewController <NSObject>
@property (readwrite, retain) id <SGCarouselItem> source;
@property (readonly, retain) UIView *carouselDisplayView;
@optional
-(void)carouselWillBringViewToFront;
-(void)carouselWillSendViewToBack;
-(void)carouselDidSendViewToBack;
-(void)carouselDidBringViewToFront;
@end

@protocol SGCarouselItem <NSObject>
- (void)togglePlay:(id)sender;
- (void)stop:(id)sender;

- (void)playNextItem;
- (void)playPreviousItem;

- (id <SGMediaPlaylist>)previousPlaylist;
- (id <SGMediaPlaylist>)nextPlaylist;
@property (readwrite, retain) id <SGMediaItem> currentItem;
@property (readwrite, retain) NSString *sourceName;
@property (nonatomic, readwrite, retain) id <SGMediaPlaylist> currentPlaylist;
@property (readwrite, retain) NSArray *playlists;

@end

@protocol SGMediaItem <NSObject>

- (void)togglePlay:(id)sender;
@property (readonly) UIImage *thumbnail;
@property (readwrite, retain) NSString *title;
@property (readwrite, retain) NSString *album;
@property (readwrite, retain) NSString *artist;

@end

@protocol SGMediaPlaylist <NSObject>

- (id <SGMediaItem>)previousItem;
- (id <SGMediaItem>)nextItem;
- (void)playItem:(id <SGMediaItem>)item;
@property (readwrite, retain) NSString *title;
@property (readwrite, retain) id <SGMediaItem> currentItem;

@end