//
//  ExplodingTextViewController.m
//  SongGong
//
//  Created by Arshad Tayyeb on 7/17/11.
//  Copyright 2011 doubleTwist Corporation. All rights reserved.
//

#import "ExplodingTextViewController.h"
#import "SongGongAppDelegate.h"

@interface ExplodingTextViewController ()
- (void)explodingDone:(NSString *)animationId finished:(BOOL)finished context:(id)context;
@end

@implementation ExplodingTextViewController
@synthesize textLabel;

#define EXPLOSIONSIZE 10.0

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
        
        self.view.center = CGPointMake(self.view.frame.size.width/2,self.view.frame.size.height/2);
        //self.view.center = [SongGongAppDelegate mainView].center;
    }
    
    [self retain];
    [self.view setHidden:YES];
    self.view.frame = origRect;
    self.textLabel.text = text;
    [self.view setHidden:NO];

    [UIView animateWithDuration:0.2 animations:^{
        self.view.alpha = 1.0;
        self.view.alpha = 0.5;
        CGAffineTransform transform = CGAffineTransformMakeScale(2.0,2.0);    
        self.view.center = [self.view superview].center;
        self.view.transform = transform;
    }
                     completion:^ (BOOL finished) {
                         self.view.alpha = 0.5;
                         [UIView animateWithDuration:0.3 animations:^{
                             self.view.alpha = 0.0;
                             CGAffineTransform transform = CGAffineTransformMakeScale(EXPLOSIONSIZE,EXPLOSIONSIZE);    
                             self.view.transform = transform;
                             self.view.center = [self.view superview].center;
                         } completion:^(BOOL finished) {
                             [self.view removeFromSuperview];
                             [self release];
                         }];
      
                     }];


//    [UIView beginAnimations:@"1" context:nil];
//
//    self.view.alpha = 1.0;
//    [UIView setAnimationDidStopSelector:@selector(explodingDone:finished:context:)]; 
//    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn]; 
//    self.view.alpha = 0.5;
//    [UIView setAnimationDuration:.20];
//    [UIView setAnimationDelegate:self];
//    CGAffineTransform transform = CGAffineTransformMakeScale(2.0,2.0);    
//    self.view.center = [self.view superview].center;
//    self.view.transform = transform;
//    [UIView commitAnimations];
}

- (void)explodingDone:(NSString *)animationId finished:(BOOL)finished context:(id)context
{
    if ([animationId isEqualToString:@"2"])
    {
        [self.view removeFromSuperview];
        [self release];
    } else {
        [UIView beginAnimations:@"2" context:nil];
        
        self.view.alpha = 0.5;
        [UIView setAnimationDidStopSelector:@selector(explodingDone:finished:context:)]; 
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn]; 
        self.view.alpha = 0.0;
        [UIView setAnimationDelegate:self];
        CGAffineTransform transform = CGAffineTransformMakeScale(EXPLOSIONSIZE,EXPLOSIONSIZE);    
        self.view.transform = transform;
        self.view.center = [self.view superview].center;
        [UIView commitAnimations];
    }
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
