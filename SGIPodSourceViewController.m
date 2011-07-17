//
//  SGIPodSourceViewController.m
//  SongGong
//
//  Created by Daniel DeCovnick on 7/16/11.
//  Copyright 2011 doubleTwist Corporation. All rights reserved.
//

#import "SGIPodSourceViewController.h"
#import "SGIPodSource.h"

@implementation SGIPodSourceViewController
@synthesize playlists, sourceName, currentPlaylist, source = iPodSource;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        iPodSource = [[SGIPodSource alloc] init];
        self.sourceName = @"iPod";
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [iPodSource release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
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
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight || interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark SGCarouselProtocol


- (void)stop:(id)sender
{
    
}

- (void)togglePlay:(id)sender
{
    
}

- (id <SGMediaPlaylist>)previousPlaylist
{
    return nil;
}

- (id <SGMediaPlaylist>)nextPlaylist
{
    return nil;
}
- (UIView *)carouselDisplayView
{
    
    return self.view;
}


@end
