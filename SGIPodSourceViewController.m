//
//  SGIPodSourceViewController.m
//  SongGong
//
//  Created by Daniel DeCovnick on 7/16/11.
//  Copyright 2011 doubleTwist Corporation. All rights reserved.
//

#import "SGIPodSourceViewController.h"
#import "SGIPodSource.h"

@interface SGIPodSourceViewController ()
- (void)updateUIForItem:(id<SGMediaItem>)item;
@end


@implementation SGIPodSourceViewController
@synthesize source = iPodSource;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        iPodSource = [[SGIPodSource alloc] init];
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

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self updateUIForItem:iPodSource.currentItem];
    
    [(NSObject *)self.source addObserver:self forKeyPath:@"currentItem" options:0 context:nil]; 
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [(NSObject *)self.source removeObserver:self forKeyPath:@"currentItem"];
    [artworkOrIcon release];
    artworkOrIcon = nil;
    [playlistNameLabel release];
    playlistNameLabel = nil;
    [titleLabel release];
    titleLabel = nil;
    [artistLabel release];
    artistLabel = nil;
    [myPlaylistsLabel release];
    myPlaylistsLabel = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight || interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - 

- (void)updateUIForItem:(id<SGMediaItem>)item
{
    artworkOrIcon.image = item.thumbnail;
    titleLabel.text = item.title;
    artistLabel.text = item.artist;
    playlistNameLabel.text = iPodSource.currentPlaylist.title;
    //myPlaylistsLabel.text = iPodSource;
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"currentItem"])
    {
        [self updateUIForItem:iPodSource.currentItem];
    }
}

#pragma mark SGCarouselViewController Protocol


- (UIView *)carouselDisplayView
{
    return self.view;
}

-(void)carouselWillBringViewToFront
{
    artworkOrIcon.image = iPodSource.currentItem.thumbnail;
    [self.view setNeedsDisplayInRect:artworkOrIcon.bounds];
}

-(void)carouselWillSendViewToBack
{
    artworkOrIcon.image = [UIImage imageNamed:@"ipod-icon"];
    [self.view setNeedsDisplayInRect:artworkOrIcon.bounds];
}

- (void)dealloc {
    [artworkOrIcon release];
    [playlistNameLabel release];
    [titleLabel release];
    [artistLabel release];
    [myPlaylistsLabel release];
    [iPodSource release];
    [super dealloc];
}

@end
