//
//  SGIPodSourceViewController.h
//  SongGong
//
//  Created by Daniel DeCovnick on 7/16/11.
//  Copyright 2011 doubleTwist Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SGCarouselProtocols.h"

@class SGIPodSource;

@interface SGIPodSourceViewController : UIViewController <SGCarouselItem>
{
    SGIPodSource *iPodSource;
}
- (id <SGMediaPlaylist>)previousPlaylist;
- (id <SGMediaPlaylist>)nextPlaylist;
@property (readwrite, retain) NSString *sourceName;
@property (nonatomic, readwrite, retain) id <SGMediaPlaylist> currentPlaylist;
@property (readwrite, retain) NSArray *playlists;

@end
