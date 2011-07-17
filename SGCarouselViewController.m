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
#import "SGIPodSourceViewController.h"
#import "SGRdioSourceViewController.h"
#import "ExplodingTextViewController.h"

@interface SGCarouselViewController ()
- (void)playIfIdle:(id)obj;
@end

@implementation SGCarouselViewController
@synthesize gestureController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        LOG_CALL;
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
    [carouselSourceViewControllers release];
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
    carousel.type = iCarouselTypeRotary;
    carousel.perspective = -.002;
    carousel.viewpointOffset = CGSizeMake(0, -50);
    carousel.contentOffset = CGSizeMake(0, -50);
    carousel.decelerationRate = 0.02;
    wrap = YES;
    //Set up our sources
    carouselSourceViewControllers = [[NSArray alloc] initWithObjects: [[SGIPodSourceViewController alloc] initWithNibName:@"SGIPodSourceViewController" bundle:nil], [[SGRdioSourceViewController alloc] initWithNibName:@"SGIPodSourceViewController" bundle:nil], [[SGIPodSourceViewController alloc] initWithNibName:@"SGIPodSourceViewController" bundle:nil], [[SGIPodSourceViewController alloc] initWithNibName:@"SGIPodSourceViewController" bundle:nil],  [[SGIPodSourceViewController alloc] initWithNibName:@"SGIPodSourceViewController" bundle:nil], nil];
    for (id vc in carouselSourceViewControllers)
    {
        [vc carouselDidSendViewToBack];
    }
    currentCarouselSource = [[carouselSourceViewControllers objectAtIndex:0] source];
    [[carouselSourceViewControllers objectAtIndex:0] carouselDidBringViewToFront];
    
    [self performSelector:@selector(playIfIdle:) withObject:nil afterDelay:4.0];
}

- (void)playIfIdle:(id)obj
{
    LOG_CALL;
    if ([currentCarouselSource currentItem] == nil)
    {
        [currentCarouselSource togglePlay:self];
    }
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
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight || interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark SGBlindGestureViewControllerDelegate
- (void)nextItem:(id)sender
{
    LOG_CALL;    
    [OPASpookSoundManager playShortSound:@"nav-LeftRight.aiff" disposeWhenDone:NO];
    [currentCarouselSource playNextItem];
    
}

- (void)prevItem:(id)sender
{
    LOG_CALL;
    [OPASpookSoundManager playShortSound:@"nav-LeftRight.aiff" disposeWhenDone:NO];
    [currentCarouselSource playPreviousItem];
}

- (void)nextPlaylist:(id)sender
{
    LOG_CALL;
    [OPASpookSoundManager playShortSound:@"nav-UpDown.aiff" disposeWhenDone:NO]; 
    [currentCarouselSource playNextPlaylist];
}

- (void)prevPlaylist:(id)sender
{
    LOG_CALL;    
    [OPASpookSoundManager playShortSound:@"nav-UpDown.aiff" disposeWhenDone:NO];
    [currentCarouselSource playPreviousPlaylist];
}

//Not used - carousel does this with 2 fingers
- (void)nextSource:(id)sender
{
    LOG_CALL;
    [OPASpookSoundManager playShortSound:@"nav-LeftRight.aiff" disposeWhenDone:NO];

}

//Not used - carousel does this with 2 fingers
- (void)prevSource:(id)sender
{
    LOG_CALL;    
    [OPASpookSoundManager playShortSound:@"nav-LeftRight.aiff" disposeWhenDone:NO];
}


- (void)playPauseToggle:(id)sender
{
    LOG_CALL;    
    [currentCarouselSource togglePlay:self];
    [OPASpookSoundManager playShortSound:@"nav-LeftRight.aiff" disposeWhenDone:NO];

    [ExplodingTextViewController explodeText:@"♫"];
}


- (void)showNavigator:(id)sender
{
    LOG_CALL;    
    [OPASpookSoundManager playShortSound:@"nav-Wall.aiff" disposeWhenDone:NO];
    [[carouselSourceViewControllers objectAtIndex:currentCarouselItemIndex] popGenericPlayer];
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
#pragma mark iCarousel datasource

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return [carouselSourceViewControllers count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index
{
    return [[carouselSourceViewControllers objectAtIndex:index] carouselDisplayView];
}

#pragma mark iCarousel delegate
- (BOOL)carouselShouldWrap:(iCarousel *)aCarousel
{
    return wrap;
}
- (float)carouselItemWidth:(iCarousel *)aCarousel
{
    return [[[carouselSourceViewControllers objectAtIndex:aCarousel.currentItemIndex] carouselDisplayView] bounds].size.width*1.25; //because everything else is that big too
}

- (void)carouselCurrentItemIndexUpdated:(iCarousel *)incarousel
{
    LOG_CALL;
    if (incarousel.currentItemIndex != currentCarouselItemIndex)
    {
        [[carouselSourceViewControllers objectAtIndex:currentCarouselItemIndex] carouselDidSendViewToBack];
        currentCarouselItemIndex = incarousel.currentItemIndex;
        [currentCarouselSource stop:self];
        
        currentCarouselSource = [[carouselSourceViewControllers objectAtIndex:currentCarouselItemIndex] source];
        [NSObject cancelPreviousPerformRequestsWithTarget:currentCarouselSource];
        [(NSObject *)currentCarouselSource performSelector:@selector(play:) withObject:nil afterDelay:0.1];
        [[carouselSourceViewControllers objectAtIndex:currentCarouselItemIndex] carouselDidBringViewToFront];
    }
}

- (void)carouselWillBeginDragging:(iCarousel *)incarousel
{
    LOG_CALL;
    currentCarouselItemIndex = incarousel.currentItemIndex;
}


- (void)carouselDidEndDragging:(iCarousel *)carousel willDecelerate:(BOOL)decelerate
{
    LOG_CALL;

    [OPASpookSoundManager playShortSound:@"nav-LeftRight.aiff" disposeWhenDone:NO];
}

- (void)carouselDidScroll:(iCarousel *)carousel
{
 //   LOG_CALL;
}


@end
