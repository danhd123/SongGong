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
#import "iCarousel.h"

@implementation SGCarouselViewController
@synthesize gestureController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        LOG_CALL;
        NSLog(@"%@ %@", [self class], NSStringFromSelector(_cmd));
        carouselSources = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:0], nil];
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
    [carouselSources release];
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    LOG_CALL;    

    self.gestureController = [[SGGestureController alloc] initWithDelegate:self];
    self.gestureController.delegate = self;
    carousel = (iCarousel *)self.view;
    carousel.type = iCarouselTypeCylinder;
    wrap = NO;
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    carousel = nil;
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
#pragma mark iCarousel delegate

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return [carouselSources count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index
{
    UIImage *image = [UIImage imageNamed:@"first@2x.png"];
    UIButton *button = [[[UIButton alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)] autorelease];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button setTitle:[[carouselSources objectAtIndex:index] stringValue] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.titleLabel.font = [button.titleLabel.font fontWithSize:50];
    //[button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = index;
    return button;

}


@end
