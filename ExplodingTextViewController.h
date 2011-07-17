//
//  ExplodingTextViewController.h
//  SongGong
//
//  Created by Arshad Tayyeb on 7/17/11.
//  Copyright 2011 doubleTwist Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExplodingTextViewController : UIViewController {
    UILabel *textLabel;
    CGRect origRect;
}
+ (id)explodeText:(NSString *)text;
- (void)explodeText:(NSString *)text;

@property (nonatomic, retain) IBOutlet UILabel *textLabel;

@end
