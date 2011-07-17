//
//  SGIPodSourceViewController.h
//  SongGong
//
//  Created by Daniel DeCovnick on 7/16/11.
//  Copyright 2011 doubleTwist Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SGCarouselProtocols.h"

@class SGIPodSource, SGGenericPlayerView;

@interface SGIPodSourceViewController : UIViewController <SGCarouselItemViewController>
{
    SGIPodSource *iPodSource;
    IBOutlet UIImageView *artworkOrIcon;
    IBOutlet UILabel *playlistNameLabel;
    IBOutlet UILabel *titleLabel;
    IBOutlet UILabel *artistLabel;
    IBOutlet UILabel *myPlaylistsLabel;
    BOOL iconMode;
    NSTimer *switchToPlayerViewTimer;
    SGGenericPlayerView *playerViewController;
}

@end
