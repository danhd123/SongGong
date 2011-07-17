//
//  SGIPodSource.h
//  SongGong
//
//  Created by Arshad Tayyeb on 7/16/11.
//  Copyright 2011 doubleTwist Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SGCarouselProtocols.h"

@interface SGIPodSource : NSObject <SGCarouselItem>
- (id <SGMediaPlaylist>)previousPlaylist;
- (id <SGMediaPlaylist>)nextPlaylist;
@property (readwrite, retain) NSString *sourceName;
@property (readwrite, retain) id <SGMediaPlaylist> currentPlaylist;
@property (readwrite, retain) NSArray *playlists;
@end


@class SGIPodItem, SGIPodPlaylist;
@interface SGIPodItem : NSObject <SGMediaItem>
- (void)togglePlay:(id)sender;
@property (readwrite, retain) UIImage *thumbnail;
@property (readwrite, retain) NSString *title;
@property (readwrite, retain) NSString *album;
@property (readwrite, retain) NSString *artist;
@end

@interface SGIPodPlaylist : NSObject <SGMediaPlaylist>
- (id <SGMediaItem>)previousItem;
- (id <SGMediaItem>)nextItem;
- (void)playItem:(id <SGMediaItem>)item;
@property (readwrite, retain) NSString *title;
@property (readwrite, retain) id <SGMediaItem> currentItem;
@end



