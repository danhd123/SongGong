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
#import "OPASpookSoundManager.h"

@implementation SGCarouselViewController
@synthesize gestureController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        LOG_CALL;
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
    LOG_CALL;    

    self.gestureController = [[SGGestureController alloc] initWithDelegate:self];
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
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

#pragma mark SGBlindGestureViewControllerDelegate
- (void)nextItem:(id)sender
{
    LOG_CALL;    
    [OPASpookSoundManager playShortSound:@"nav-LeftRight.aiff" disposeWhenDone:NO];
}

- (void)prevItem:(id)sender
{
    LOG_CALL;
    [OPASpookSoundManager playShortSound:@"nav-LeftRight.aiff" disposeWhenDone:NO];
}

- (void)nextPlaylist:(id)sender
{
    LOG_CALL;    
    [OPASpookSoundManager playShortSound:@"nav-UpDown.aiff" disposeWhenDone:NO];
   
}

- (void)prevPlaylist:(id)sender
{
    LOG_CALL;    
    [OPASpookSoundManager playShortSound:@"nav-UpDown.aiff" disposeWhenDone:NO];

}


- (void)nextSource:(id)sender
{
    LOG_CALL;
    [OPASpookSoundManager playShortSound:@"nav-LeftRight.aiff" disposeWhenDone:NO];

}

- (void)prevSource:(id)sender
{
    LOG_CALL;    
    [OPASpookSoundManager playShortSound:@"nav-LeftRight.aiff" disposeWhenDone:NO];
}


- (void)playPauseToggle:(id)sender
{
    LOG_CALL;    
    [currentCarouselSource.currentPlaylist.currentItem togglePlay:self];
    [OPASpookSoundManager playShortSound:@"nav-LeftRight.aiff" disposeWhenDone:NO];

}


- (void)showNavigator:(id)sender
{
    LOG_CALL;    
    [OPASpookSoundManager playShortSound:@"nav-Wall.aiff" disposeWhenDone:NO];
}

- (void)showDetail:(id)sender
{
    LOG_CALL;    
    [OPASpookSoundManager playShortSound:@"nav-Wall.aiff" disposeWhenDone:NO];

}


- (void)showSpecialAction:(id)sender
{
    LOG_CALL;    
    [OPASpookSoundManager playShortSound:@"nav-Wall.aiff" disposeWhenDone:NO];

}


@end
