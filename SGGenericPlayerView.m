//
//  SGGenericPlayerView.m
//  SongGong
//
//  Created by Daniel DeCovnick on 7/16/11.
//  Copyright 2011 doubleTwist Corporation. All rights reserved.
//

#import "SGGenericPlayerView.h"
#import "OHAttributedLabel.h"
#import "SGCarouselProtocols.h"
#import "NSAttributedString+Attributes.h"

@implementation SGGenericPlayerView
@synthesize songProgress;
@synthesize topView;
@synthesize listeningToLabel;
@synthesize colorSplashView;
@synthesize artworkView;
@synthesize attributedLabel;
@synthesize playItem;
@synthesize source;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)setPlayItem:(NSObject<SGMediaItem> *)aPlayItem
{

    if (playItem != aPlayItem)
    {
        [aPlayItem retain];
        [(NSObject<SGCarouselItem>*)playItem release];
        playItem = aPlayItem;
    }
    NSString *title = playItem.title;
    NSString *artist = playItem.artist;
    NSString *album = playItem.album;
    if (!(title && artist && album))
        return;
    NSMutableAttributedString *mas = [[NSMutableAttributedString alloc] initWithString:[title stringByAppendingFormat:@"\n%@\n%@", artist, album]];
    [mas setTextColor:[UIColor colorWithRed:140.0/255.0 green:198.0/255.0 blue:63.0/255.0 alpha:1.0] range:NSMakeRange(0, title.length)];
    [mas setFontFamily:@"Helvetica" size:20.0 bold:YES italic:NO range:NSMakeRange(0, title.length)];
    [mas setTextColor:[UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1.0] range:NSMakeRange(title.length+1, artist.length)];
    [mas setFontFamily:@"Helvetica" size:17.0 bold:YES italic:NO range:NSMakeRange(title.length+1, artist.length)];
    [mas setTextColor:[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0] range:NSMakeRange(title.length+2+artist.length, album.length)];
    [mas setFontFamily:@"Helvetica" size:17.0 bold:YES italic:NO range:NSMakeRange(title.length+2+artist.length, album.length)];
    attributedLabel.attributedText = mas;
    songProgress.progress = playItem.progress;
    artworkView.image = playItem.thumbnail ? playItem.thumbnail : [UIImage imageNamed:@"BlankAudio"];
    [self.view setNeedsDisplay];
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
    [topView setBackgroundColor:[[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"gray_bar_gradient"]] autorelease]];
    listeningToLabel.text = self.source.sourceName;
    colorSplashView.backgroundColor = self.source.splashColor;
    
    
//    NSString *title = playItem.title;
//    NSString *artist = playItem.artist;
//    NSString *album = playItem.album;
//    if (!(title && artist && album))
//        return;
//    NSMutableAttributedString *mas = [[NSMutableAttributedString alloc] initWithString:[title stringByAppendingFormat:@"\n%@\n%@", artist, album]];
//    [mas setTextColor:[UIColor colorWithRed:140.0/255.0 green:198.0/255.0 blue:63.0/255.0 alpha:1.0] range:NSMakeRange(0, title.length)];
//    [mas setFontFamily:@"Helvetica" size:20.0 bold:YES italic:NO range:NSMakeRange(0, title.length)];
//    [mas setTextColor:[UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1.0] range:NSMakeRange(title.length+1, artist.length)];
//    [mas setFontFamily:@"Helvetica" size:17.0 bold:YES italic:NO range:NSMakeRange(title.length+1, artist.length)];
//    [mas setTextColor:[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0] range:NSMakeRange(title.length+2+artist.length, album.length)];
//    [mas setFontFamily:@"Helvetica" size:17.0 bold:YES italic:NO range:NSMakeRange(title.length+2+artist.length, album.length)];
//    attributedLabel.attributedText = mas;
//    songProgress.progress = playItem.progress;
//    artworkView.image = playItem.thumbnail;

    

}

- (void)viewDidUnload
{
    [self setArtworkView:nil];
    [self setAttributedLabel:nil];
    [self setSongProgress:nil];
    [self setTopView:nil];
    [self setListeningToLabel:nil];
    [self setColorSplashView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight || interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}

- (void)dealloc {
    [artworkView release];
    [attributedLabel release];
    [songProgress release];
    [topView release];
    [listeningToLabel release];
    [colorSplashView release];
    [super dealloc];
}
@end
