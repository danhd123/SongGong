//
//  ExplodingTextViewController.m
//  SongGong
//
//  Created by Arshad Tayyeb on 7/17/11.
//  Copyright 2011 doubleTwist Corporation. All rights reserved.
//

#import "ExplodingTextViewController.h"
#import "SongGongAppDelegate.h"

@implementation ExplodingTextViewController
@synthesize textLabel;

+ (id)explodeText:(NSString *)text
{
    ExplodingTextViewController *vc = [[[ExplodingTextViewController alloc] init] autorelease];
    [vc explodeText:text];
    return vc;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
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
    // Do any additional setup after loading the view from its nib.
    origRect = self.view.frame;
    self.view.hidden = YES;
}

- (void)viewDidUnload
{
    [self setTextLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark -
- (void)explodeText:(NSString *)text
{
    if (!self.view.superview)
    {
        [[SongGongAppDelegate mainView] addSubview:self.view];
    }
    
    [self retain];
    [self.view setHidden:YES];
    self.view.frame = origRect;
    self.textLabel.text = text;
    [self.view setHidden:NO];

    [UIView beginAnimations:NSStringFromSelector(_cmd) context:nil];

    [UIView setAnimationDidStopSelector:@selector(animatePlaylistViewPart2:finished:context:)]; 
    [UIView setAnimationCurve:UIViewAnimationCurveLinear]; 
    [UIView setAnimationDuration:.25]; 
    [UIView setAnimationDelegate:self];
    CGAffineTransform transform = CGAffineTransformMakeScale(5.0,5.0);    
    self.view.transform = transform;
    [UIView commitAnimations];
}

- (void)explodingDone:(NSString *)animationId finished:(BOOL)finished context:(id)context
{
    [self.view removeFromSuperview];
    [self release];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [textLabel release];
    [super dealloc];
}
@end
