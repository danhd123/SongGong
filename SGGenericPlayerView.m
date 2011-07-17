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
@synthesize artworkView;
@synthesize attributedLabel;
@synthesize playItem;

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
    NSMutableAttributedString *mas = [[NSMutableAttributedString alloc] initWithString:[title stringByAppendingFormat:@"\n%@\n%@", artist, album]];
    [mas setTextColor:[UIColor colorWithRed:140.0/255.0 green:198.0/255.0 blue:63.0/255.0 alpha:1.0] range:NSMakeRange(0, title.length)];
    [mas setTextColor:[UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1.0] range:NSMakeRange(title.length+1, artist.length)];
    [mas setTextColor:[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0] range:NSMakeRange(title.length+2+artist.length, album.length)];
    attributedLabel.attributedText = mas;
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
    [self setArtworkView:nil];
    [self setAttributedLabel:nil];
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
    [super dealloc];
}
@end
