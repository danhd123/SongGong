//
//  DummySource.h
//  SongGong
//
//  Created by Arshad Tayyeb on 7/17/11.
//  Copyright 2011 doubleTwist Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SGCarouselProtocols.h"
#import "SGIPodSource.h"

@interface SGDummySource : NSObject <SGCarouselItem>

- (void)play:(id)sender;
- (void)togglePlay:(id)sender;
- (void)stop:(id)sender;

- (id <SGMediaPlaylist>)previousPlaylist;
- (id <SGMediaPlaylist>)nextPlaylist;
@property (readwrite, retain) id <SGMediaItem> currentItem;
@property (readwrite, retain) NSString *sourceName;
@property (nonatomic, readwrite, retain) id <SGMediaPlaylist> currentPlaylist;
@property (readwrite, retain) NSArray *playlists;
@property (readwrite, assign) id<SGSourceDelegate> delegate;
@property (readwrite, retain) UIColor *splashColor;
@end


@interface SGRdioItem : SGIPodItem <SGMediaItem>
- (void)togglePlay:(id)sender;
@property (readonly) UIImage *thumbnail;
@property (readwrite, retain) NSString *title;
@property (readwrite, retain) NSString *album;
@property (readwrite, retain) NSString *artist;
@property (readwrite, retain) NSString *persistentId;
@end

@interface SGRdioPlaylist : SGIPodPlaylist <SGMediaPlaylist>
- (id <SGMediaItem>)previousItem;
- (id <SGMediaItem>)nextItem;
- (void)playItem:(id <SGMediaItem>)item;
@property (readwrite, retain) NSString *title;
@property (readwrite, retain) id <SGMediaItem> currentItem;
@property (readwrite, retain) NSArray *itemIds;
@property (readwrite, retain) NSString *persistentId;

@end
