//
//  SGGestureController.m
//  SongGong
//
//  Created by Arshad Tayyeb on 7/16/11.
//  Copyright 2011 doubleTwist Corporation. All rights reserved.
//

#import "SGGestureController.h"

@interface SGGestureController (Private)
- (void)handleTapFrom:(UITapGestureRecognizer *)recognizer;

- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer;

- (void)handleSwipeLeftFrom:(UISwipeGestureRecognizer *)recognizer;
- (void)handleSwipeRightFrom:(UISwipeGestureRecognizer *)recognizer;
- (void)handleSwipeUpFrom:(UISwipeGestureRecognizer *)recognizer;
- (void)handleSwipeDownFrom:(UISwipeGestureRecognizer *)recognizer;

@end

@implementation SGGestureController
@synthesize gestureRecognizers;
@synthesize delegate;

- (id)initWithDelegate:(id <SGGestureControllerDelegate>)inDelegate
{
    self = [super init];
    if (self) {
        self.delegate = inDelegate;
        gestureRecognizers = [[NSMutableArray alloc] initWithCapacity:10];

        //Single tap
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapFrom:)];

        tapRecognizer.delegate = self;
        [self.delegate.view addGestureRecognizer:tapRecognizer];
        [gestureRecognizers addObject:tapRecognizer];
        [tapRecognizer release];

        //2 Finger single tap
        tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapFrom:)];
        tapRecognizer.numberOfTouchesRequired = 2;
        tapRecognizer.delegate = self;
        [self.delegate.view addGestureRecognizer:tapRecognizer];
        [gestureRecognizers addObject:tapRecognizer];
        [tapRecognizer release];

        //1 finger swipe left
        UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeLeftFrom:)];
        swipeRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
        swipeRecognizer.delegate = self;
        [self.delegate.view addGestureRecognizer:swipeRecognizer];
        [gestureRecognizers addObject:swipeRecognizer];
        [swipeRecognizer release];
        
        //2 finger swipe left
        swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeLeftFrom:)];
        swipeRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
        swipeRecognizer.numberOfTouchesRequired = 2;
        swipeRecognizer.delegate = self;
        [self.delegate.view addGestureRecognizer:swipeRecognizer];
        [gestureRecognizers addObject:swipeRecognizer];
        [swipeRecognizer release];
        
        //1 finger swipe right
        swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeRightFrom:)];
        swipeRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
        swipeRecognizer.numberOfTouchesRequired = 1;
        swipeRecognizer.delegate = self;
        [self.delegate.view addGestureRecognizer:swipeRecognizer];
        [gestureRecognizers addObject:swipeRecognizer];
        [swipeRecognizer release];
        
        //2 finger swipe right
        swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeRightFrom:)];
        swipeRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
        swipeRecognizer.numberOfTouchesRequired = 2;
        swipeRecognizer.delegate = self;
        [self.delegate.view addGestureRecognizer:swipeRecognizer];
        [gestureRecognizers addObject:swipeRecognizer];
        [swipeRecognizer release];

        //1 finger swipe up
        swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeUpFrom:)];
        swipeRecognizer.direction = UISwipeGestureRecognizerDirectionUp;
        swipeRecognizer.numberOfTouchesRequired = 1;
        swipeRecognizer.delegate = self;
        [self.delegate.view addGestureRecognizer:swipeRecognizer];
        [gestureRecognizers addObject:swipeRecognizer];
        [swipeRecognizer release];
        
        //2 finger swipe up
        swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeUpFrom:)];
        swipeRecognizer.direction = UISwipeGestureRecognizerDirectionUp;
        swipeRecognizer.numberOfTouchesRequired = 2;
        swipeRecognizer.delegate = self;
        [self.delegate.view addGestureRecognizer:swipeRecognizer];
        [gestureRecognizers addObject:swipeRecognizer];
        [swipeRecognizer release];
        
        //1 finger swipe down
        swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeDownFrom:)];
        swipeRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
        swipeRecognizer.numberOfTouchesRequired = 1;
        swipeRecognizer.delegate = self;
        [self.delegate.view addGestureRecognizer:swipeRecognizer];
        [gestureRecognizers addObject:swipeRecognizer];
        [swipeRecognizer release];
        
        //2 finger swipe down
        swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeDownFrom:)];
        swipeRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
        swipeRecognizer.numberOfTouchesRequired = 2;
        swipeRecognizer.delegate = self;
        [self.delegate.view addGestureRecognizer:swipeRecognizer];
        [gestureRecognizers addObject:swipeRecognizer];
        [swipeRecognizer release];
        
    }
    
    return self;
}


- (void)dealloc
{
    [gestureRecognizers release];
    [super dealloc];
}


#pragma mark -
- (void)handleTapFrom:(UITapGestureRecognizer *)recognizer
{
    if (recognizer.numberOfTapsRequired == 1)
    {
        switch (recognizer.numberOfTouchesRequired) {
            case 1:
                //1 finger tap
                [delegate playPauseToggle:self];
                break;
            case 2:
                //2 finger tap
                [delegate showNavigator:self];
                break;
                
            default:
                break;
        }
    } else {
        //no double or triple tap gestures yet
    }
}

- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer
{
    switch (recognizer.direction) {
        case UISwipeGestureRecognizerDirectionUp:
            [self handleSwipeUpFrom:recognizer];
            break;
        case UISwipeGestureRecognizerDirectionDown:
            [self handleSwipeDownFrom:recognizer];
            break;
        case UISwipeGestureRecognizerDirectionLeft:
            [self handleSwipeLeftFrom:recognizer];
            break;
        case UISwipeGestureRecognizerDirectionRight:
            [self handleSwipeRightFrom:recognizer];
            break;
            
        default:
            break;
    }
}


- (void)handleSwipeLeftFrom:(UISwipeGestureRecognizer *)recognizer
{
    LOG_CALL;
    switch (recognizer.numberOfTouches)
    {
        case 1:
            [delegate prevItem:self];
            break;
        case 2:
            [delegate prevSource:self];
            break;
        default:
            break;
    }
}

- (void)handleSwipeRightFrom:(UISwipeGestureRecognizer *)recognizer
{
    LOG_CALL;
    switch (recognizer.numberOfTouches)
    {
        case 1:
            [delegate nextItem:self];
            break;
        case 2:
            [delegate nextSource:self];
            break;
        default:
            break;
    }   
}

- (void)handleSwipeUpFrom:(UISwipeGestureRecognizer *)recognizer
{
    LOG_CALL;
    switch (recognizer.numberOfTouches)
    {
        case 1:
            //Nothing for 1 finger swipe up yet
            break;
        case 2:
            [delegate prevPlaylist:self];
            break;
        default:
            break;
    }    
}

- (void)handleSwipeDownFrom:(UISwipeGestureRecognizer *)recognizer
{
    LOG_CALL;
    switch (recognizer.numberOfTouches)
    {
        case 1:
            //Nothing for 1 finger swipe down yet
            break;
        case 2:
            [delegate nextPlaylist:self];
            break;
        default:
            break;
    }   
}

@end
