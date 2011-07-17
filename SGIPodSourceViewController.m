//
//  SGIPodSourceViewController.m
//  SongGong
//
//  Created by Daniel DeCovnick on 7/16/11.
//  Copyright 2011 doubleTwist Corporation. All rights reserved.
//

#import "SGIPodSourceViewController.h"
#import "SGGenericPlayerView.h"
#import "SGIPodSource.h"
#import "SGCarouselProtocols.h"
#import "ExplodingTextViewController.h"
#import "SongGongAppDelegate.h"

@interface SGIPodSourceViewController ()
- (void)updateUIForItem:(id<SGMediaItem>)item;
- (void)animatePlaylistView:(BOOL)upYesDownNo newName:(NSString *)name;
- (void)animatePlaylistViewPart2:(NSString *)animationId finished:(BOOL)finished context:(id)context;
- (void)hideGenericPlayer:(NSString *)animationID finished:(BOOL)finished context:(id)context;
@end


@implementation SGIPodSourceViewController
@synthesize topView;
@synthesize colorSplash;
@synthesize source = iPodSource;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        iPodSource = [[SGIPodSource alloc] init];
        iPodSource.delegate = self;
        // Custom initialization
        playerViewController = [[SGGenericPlayerView alloc] initWithNibName:@"SGGenericPlayerView" bundle:nil];
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
    //[[self view] setBounds:CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width*.75, self.view.bounds.size.height)];
    [self updateUIForItem:iPodSource.currentItem];
    
    [(NSObject *)self.source addObserver:self forKeyPath:@"currentItem" options:0 context:nil]; 
    
    origPlaylistNameLabelFrame = playlistNameLabel.frame;
    
    topView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"gray_bar_gradient"]];
    colorSplash.backgroundColor = self.source.splashColor;
    
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
    [self setTopView:nil];
    [self setColorSplash:nil];
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
    if (!item)
    {
        [self popGenericPlayer];
    } else {
        artworkOrIcon.image = item.thumbnail;
        titleLabel.text = item.title;
        artistLabel.text = item.artist;
        playlistNameLabel.text = iPodSource.currentPlaylist.title;
        [self.view setNeedsDisplay];
        //myPlaylistsLabel.text = iPodSource;
    }
    [playerViewController setPlayItem:item];
    
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

-(void)carouselDidBringViewToFront
{
    if (iPodSource.currentItem != nil)
        [self performSelector:@selector(pushGenericPlayer) withObject:nil afterDelay:3.0];
    topView.hidden = NO;
    colorSplash.hidden = NO;
    titleLabel.hidden = NO;
    artistLabel.hidden = NO;
    artworkOrIcon.image = self.source.currentItem.thumbnail;
}

-(void)carouselDidSendViewToBack
{
    artworkOrIcon.image = [UIImage imageNamed:@"mainicons_r_2"];
    topView.hidden = YES;
    colorSplash.hidden = YES;
    titleLabel.hidden = YES;
    artistLabel.hidden = YES;
    [self.view setNeedsDisplay];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(pushGenericPlayer) object:nil];
}

- (void)pushGenericPlayer
{
     [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(pushGenericPlayer) object:nil];
    
    if (iPodSource.currentItem == nil)
        return;
    
    if (!playerViewController)
    {
        playerViewController = [[SGGenericPlayerView alloc] initWithNibName:@"SGGenericPlayerView" bundle:nil];
    }
    
    playerViewController.source = self.source;
    playerViewController.view.bounds = [SongGongAppDelegate mainView].bounds;
    playerViewController.view.alpha = 0.0f;
    [self.view.superview.superview addSubview:playerViewController.view];
    playerViewController.playItem = self.source.currentPlaylist.currentItem;
    [UIView beginAnimations:@"pushGenericPlayer" context:nil];
    
    [UIView setAnimationDidStopSelector:@selector(hideGenericPlayer:finished:context:)]; 
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut]; 
    [UIView setAnimationDuration:.45];
    playerViewController.view.alpha = 1.0f;
    [UIView commitAnimations];    
}
- (void)popGenericPlayer
{
    if (!playerViewController || playerViewController.view.alpha != 1.0)
    {
        return;
    }
        
    [UIView beginAnimations:@"popGenericPlayer" context:playerViewController];
    
    [UIView setAnimationDidStopSelector:@selector(hideGenericPlayer:finished:context:)]; 
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn]; 
    [UIView setAnimationDuration:.15];
    playerViewController.view.alpha = 0.0f;
    [UIView commitAnimations];
}

- (void)hideGenericPlayer:(NSString *)animationID finished:(BOOL)finished context:(id)context
{
//    SGGenericPlayerView *pvc = (SGGenericPlayerView *)context;
    if ([animationID isEqualToString:@"popGenericPlayer"])
    {
//        [pvc.view removeFromSuperview];
//        [pvc release];
//        pvc = nil;
    }
}

- (void)dealloc {
    [artworkOrIcon release];
    [playlistNameLabel release];
    [titleLabel release];
    [artistLabel release];
    [myPlaylistsLabel release];
    [iPodSource release];
    [topView release];
    [colorSplash release];
    [super dealloc];
}

#pragma mark delegate methods
//0 = up, 1 = down
- (void)playlistWillChange:(NSString *)newPlaylistName direction:(int)direction
{
    if (!newPlaylistName)
        newPlaylistName = @"Library";
    [ExplodingTextViewController explodeText:newPlaylistName];
  //  [self animatePlaylistView:(direction == 0) newName:newPlaylistName];
}

- (void)mediaDidChange:(id <SGMediaItem>)media
{
    [self performSelector:@selector(pushGenericPlayer) withObject:nil afterDelay:3.0];
    
    [self updateUIForItem:media];
    if (media)
    {
    
    } else {

    }
}

#pragma mark animations
- (void)animatePlaylistView:(BOOL)upYesDownNo newName:(NSString *)name
{
	[UIView beginAnimations:NSStringFromSelector(_cmd) context:name];

	[UIView setAnimationDidStopSelector:@selector(animatePlaylistViewPart2:finished:context:)]; 
	[UIView setAnimationCurve:UIViewAnimationCurveLinear]; 
	[UIView setAnimationDuration:.25]; 
	[UIView setAnimationDelegate:self];
	playlistNameLabel.frame = CGRectMake(origPlaylistNameLabelFrame.origin.x, -(origPlaylistNameLabelFrame.size.height + 10), origPlaylistNameLabelFrame.size.width, origPlaylistNameLabelFrame.size.height);
	[UIView commitAnimations];
}

- (void)animatePlaylistViewPart2:(NSString *)animationId finished:(BOOL)finished context:(id)context
{
    playlistNameLabel.text = (NSString *)context;
    
    playlistNameLabel.frame = CGRectMake(origPlaylistNameLabelFrame.origin.x, self.view.frame.size.height + 10, origPlaylistNameLabelFrame.size.width, origPlaylistNameLabelFrame.size.height);

     [UIView beginAnimations:NSStringFromSelector(_cmd) context:context];
     
     [UIView setAnimationDidStopSelector:@selector(animatePlaylistViewPart2:finished:context:)]; 
     [UIView setAnimationCurve:UIViewAnimationCurveEaseOut]; 
     [UIView setAnimationDuration:.75]; 
     [UIView setAnimationDelegate:self];
     playlistNameLabel.frame = CGRectMake(origPlaylistNameLabelFrame.origin.x, origPlaylistNameLabelFrame.size.height, origPlaylistNameLabelFrame.size.width, origPlaylistNameLabelFrame.size.height);
     [UIView commitAnimations];
}

@end
