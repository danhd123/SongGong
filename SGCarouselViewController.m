//
//  SGCarouselViewController.m
//  SongGong
//
//  Created by Arshad Tayyeb on 7/16/11.
//  Copyright 2011 doubleTwist Corporation. All rights reserved.
//

#import "SGCarouselViewController.h"
#import "SGCarouselProtocols.h"
#import "SGGestureController.h"

@implementation SGCarouselViewController
@synthesize gestureController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSLog(@"%@ %@", [self class], NSStringFromSelector(_cmd));
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)dealloc
{
    [self.gestureController release];
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"%@ %@", [self class], NSStringFromSelector(_cmd));
    NSLog(@"%@", [self.view window]);
    
    self.gestureController = [[SGGestureController alloc] init];
    self.gestureController.delegate = self;
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark SGBlindGestureViewControllerDelegate
- (void)nextItem:(id)sender
{
    NSLog(@"Next Item");
}

- (void)prevItem:(id)sender
{
    NSLog(@"Previous Item");
}

- (void)nextPlaylist:(id)sender
{
    NSLog(@"Next Playlist");
   
}

- (void)prevPlaylist:(id)sender
{
    NSLog(@"Previous Playlist");

}


- (void)nextSource:(id)sender
{
    NSLog(@"Previous Source");

}

- (void)prevSource:(id)sender
{
    NSLog(@"Previous Source");

}


- (void)playPauseToggle:(id)sender
{
    NSLog(@"play pause");
    [currentCarouselSource.currentPlaylist.currentItem togglePlay:self];

}


- (void)showNavigator:(id)sender
{
    NSLog(@"show Navigator");

}

- (void)showDetail:(id)sender
{
    NSLog(@"showDetail");

}


- (void)showSpecialAction:(id)sender
{
    NSLog(@"show special action");

}


@end
