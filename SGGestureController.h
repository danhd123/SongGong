//
//  SGGestureController.h
//  SongGong
//
//  Created by Arshad Tayyeb on 7/16/11.
//  Copyright 2011 doubleTwist Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SGGestureControllerDelegate;

@interface SGGestureController : NSObject
@property (nonatomic, retain) NSArray *gestureRecognizers;
@property (readwrite, assign) id <SGGestureControllerDelegate> delegate;
@end

@protocol SGGestureControllerDelegate <NSObject>

- (void)nextItem:(id)sender;   //swipe right
- (void)prevItem:(id)sender;   //swipe left

- (void)nextPlaylist:(id)sender;   //swipe down
- (void)prevPlaylist:(id)sender;   //swipe up

- (void)nextSource:(id)sender; //2 finger swipe right
- (void)prevSource:(id)sender; //2 finger swipe left

- (void)playPauseToggle:(id)sender;    //single tap

- (void)showNavigator:(id)sender;  //2 finger tap
- (void)showDetail:(id)sender;  //TBD

- (void)showSpecialAction:(id)sender; //3 finger double tap

@end