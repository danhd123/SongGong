//
//  SongGongAppDelegate.h
//  SongGong
//
//  Created by Arshad Tayyeb on 7/15/11.
//  Copyright 2011 doubleTwist Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SGCarouselViewController;

@interface SongGongAppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>
{
    IBOutlet SGCarouselViewController *mCarouselViewController;
}
+ (UIView *)mainView;
@property (nonatomic, retain) UIWindow *window;

@property (nonatomic, retain) UITabBarController *tabBarController;


@end
