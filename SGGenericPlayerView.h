//
//  SGGenericPlayerView.h
//  SongGong
//
//  Created by Daniel DeCovnick on 7/16/11.
//  Copyright 2011 doubleTwist Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OHAttributedLabel;
@protocol SGMediaItem, SGCarouselItem;

@interface SGGenericPlayerView : UIViewController {
    UIImageView *artworkView;
    OHAttributedLabel *attributedLabel;
    UIProgressView *songProgress;
    UIView *topView;
    UILabel *listeningToLabel;
}
@property (nonatomic, retain) IBOutlet UIProgressView *songProgress;
@property (nonatomic, retain) IBOutlet UIView *topView;
@property (nonatomic, retain) IBOutlet UILabel *listeningToLabel;

@property (nonatomic, retain) IBOutlet UIImageView *artworkView;
@property (nonatomic, retain) IBOutlet OHAttributedLabel *attributedLabel;
@property (readwrite, nonatomic, retain) id <SGMediaItem> playItem;
@property (readwrite, retain) id <SGCarouselItem> source;
@end
