//
//  SpookSoundManager.m
//  Spook
//
//  Created by Arshad Tayyeb on 9/21/09.
//  Copyright 2009 Off Panel Productions Productions, Inc.. All rights reserved.
//

#import "OPASpookSoundManager.h"
#import <AVFoundation/AVAudioPlayer.h>

@implementation OPASpookSoundManager
@synthesize audioPlayer, ambientSoundFilename;

static void SoundPlayCompletionCallback (SystemSoundID  mySSID, void *userData);

static OPASpookSoundManager *g_sharedSoundManager = nil;

+ (void)playShortSound:(NSString *)soundFilename disposeWhenDone:(BOOL)bDispose
{
	if (!g_sharedSoundManager)
	{
		g_sharedSoundManager = [[OPASpookSoundManager alloc] init];
	}
	[g_sharedSoundManager playShortSound:soundFilename disposeWhenDone:bDispose];
}

- (id) init
{
	self = [super init];
	if (self)
	{
		soundIDs = [[NSMutableDictionary dictionaryWithCapacity:2] retain];
		savedSoundPlayers = [[NSMutableDictionary dictionaryWithCapacity:2] retain];
	}
	return self;
}

- (void)playShortSoundID:(SystemSoundID)soundID
{
	AudioServicesPlaySystemSound(soundID);
}

- (void)playShortSoundDeprecated:(NSString *)soundFilename disposeWhenDone:(BOOL)bDispose
{
	if (!soundFilename || ![soundFilename pathExtension])
		return;
		
    SystemSoundID soundID;

	soundID = (SystemSoundID)[[soundIDs valueForKey:soundFilename] doubleValue];
	OSStatus serr = 0;
	if (soundID == 0)
	{
		CFURLRef soundURL = (CFURLRef)[[[NSURL alloc] initFileURLWithPath:
			[[NSBundle mainBundle] pathForResource:[soundFilename stringByDeletingPathExtension] ofType:[soundFilename pathExtension]]] autorelease];
		serr = AudioServicesCreateSystemSoundID((CFURLRef)soundURL , &soundID);
		if (serr == noErr && soundID != 0 && !bDispose)
		{
			[soundIDs setObject:[NSString stringWithFormat:@"%d",soundID] forKey:soundFilename]; 
		}
		
		
	}
	
    // Register the sound completion callback.
	if (serr == noErr && bDispose)
	{
		AudioServicesAddSystemSoundCompletion (soundID, NULL, NULL, SoundPlayCompletionCallback, NULL);
	}
		
	if (serr == noErr)
	{
	    AudioServicesPlaySystemSound(soundID);
	} else {
		NSLog(@"Error playing sound %@ (%d)", soundFilename, serr);
	}
}

// A callback to be called when the sound is finished playing. Useful when you need to free memory after playing.
static void SoundPlayCompletionCallback (SystemSoundID  mySSID, void *userData)
{
    AudioServicesDisposeSystemSoundID (mySSID);
	AudioServicesRemoveSystemSoundCompletion(mySSID);
}


- (void)playShortSound:(NSString *)soundFilename disposeWhenDone:(BOOL)bDispose
{
	if (!soundFilename || ![soundFilename pathExtension])
		return;
	
	NSError *error = nil;
	AVAudioPlayer *player = [savedSoundPlayers objectForKey:soundFilename];
	if (player == nil)
	{
		NSURL *soundURL = [[[NSURL alloc] initFileURLWithPath:
										[[NSBundle mainBundle] pathForResource:[soundFilename stringByDeletingPathExtension] ofType:[soundFilename pathExtension]]] autorelease];
		player = [[AVAudioPlayer alloc] initWithContentsOfURL:soundURL error:&error];
		
		if (error == nil && player != nil)
		{
			[savedSoundPlayers setObject:player forKey:soundFilename]; 
		}
	}
		
	if (player)
	{
	    [player play];
	} else {
		NSLog(@"Error playing sound %@ (%d)", soundFilename, error);
	}
}


- (void)startPlayingAmbientSound:(NSString *)filename
{
	if (ambientIsPlaying && [ambientSoundFilename isEqualToString:filename])
	{
		return;
	}

	CFURLRef soundURL = (CFURLRef)[[[NSURL alloc] initFileURLWithPath:
		[[NSBundle mainBundle] pathForResource:[filename stringByDeletingPathExtension] ofType:[filename pathExtension]]] autorelease];
	
	if (soundURL)
	{
		OPAAudioPlayer *thePlayer = [[OPAAudioPlayer alloc] initWithCFURL:(CFURLRef)soundURL];
		self.audioPlayer = thePlayer;
		[thePlayer release];								// decrements the retain count for the thePlayer object
		
		[self.audioPlayer setNotificationDelegate: self];	// sets up the playback object to receive property change notifications from the playback audio queue object
		AudioSessionSetActive (true);
		[self.audioPlayer play];
		ambientIsPlaying = YES;
	} else {
		
	}
}

- (void)stopAmbientSound
{
	ambientIsPlaying = NO;
	self.audioPlayer = nil;
}

- (void)dealloc
{
	[savedSoundPlayers release];
	[soundIDs release];
	self.audioPlayer = nil;
	self.ambientSoundFilename = nil;
    [super dealloc];
}

#pragma mark OPAAudioQueueObjectDelegate
- (void) audioQueueStateChangeCallback:(OPAAudioQueueObject *) inQueue
{
	NSAutoreleasePool *uiUpdatePool = [[NSAutoreleasePool alloc] init];
	// the audio queue (playback or record) just started
	if ([inQueue isRunning]) {

	// the audio queue (playback or record) just stopped
	} else {
		[self.audioPlayer play];
//		AudioPlayer *thePlayer = (AudioPlayer *)inQueue;
//		if (self.audioPlayer == thePlayer)
//			self.audioPlayer = nil;
	}
	[uiUpdatePool drain];
}



@end
