//
//  SGGenericPlayerView.h
//  SongGong
//
//  Created by Daniel DeCovnick on 7/16/11.
//  Copyright 2011 doubleTwist Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OHAttributedLabel;
@protocol SGMediaItem;

@interface SGGenericPlayerView : UIViewController {
    UIImageView *artworkView;
    OHAttributedLabel *attributedLabel;
    UIProgressView *songProgress;
}
@property (nonatomic, retain) IBOutlet UIProgressView *songProgress;

@property (nonatomic, retain) IBOutlet UIImageView *artworkView;
@property (nonatomic, retain) IBOutlet OHAttributedLabel *attributedLabel;
@property (readwrite, nonatomic, retain) id <SGMediaItem> playItem;
@end
