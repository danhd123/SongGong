/*

===== IMPORTANT =====

This is sample code demonstrating API, technology or techniques in development.
Although this sample code has been reviewed for technical accuracy, it is not
final. Apple is supplying this information to help you plan for the adoption of
the technologies and programming interfaces described herein. This information
is subject to change, and software implemented based on this sample code should
be tested with final operating system software and final documentation. Newer
versions of this sample code may be provided with future seeds of the API or
technology. For information about updates to this and other developer
documentation, view the New & Updated sidebars in subsequent documentation
seeds.

=====================

File: AudioPlayer.m
Abstract: The playback class for SpeakHere, which in turn employs 
a playback audio queue object from Audio Queue Services.

Version: 1.0

Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple Inc.
("Apple") in consideration of your agreement to the following terms, and your
use, installation, modification or redistribution of this Apple software
constitutes acceptance of these terms.  If you do not agree with these terms,
please do not use, install, modify or redistribute this Apple software.

In consideration of your agreement to abide by the following terms, and subject
to these terms, Apple grants you a personal, non-exclusive license, under
Apple's copyrights in this original Apple software (the "Apple Software"), to
use, reproduce, modify and redistribute the Apple Software, with or without
modifications, in source and/or binary forms; provided that if you redistribute
the Apple Software in its entirety and without modifications, you must retain
this notice and the following text and disclaimers in all such redistributions
of the Apple Software.
Neither the name, trademarks, service marks or logos of Apple Inc. may be used
to endorse or promote products derived from the Apple Software without specific
prior written permission from Apple.  Except as expressly stated in this notice,
no other rights or licenses, express or implied, are granted by Apple herein,
including but not limited to any patent rights that may be infringed by your
derivative works or by other works in which the Apple Software may be
incorporated.

The Apple Software is provided by Apple on an "AS IS" basis.  APPLE MAKES NO
WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION THE IMPLIED
WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A PARTICULAR
PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND OPERATION ALONE OR IN
COMBINATION WITH YOUR PRODUCTS.

IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL OR
CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION, MODIFICATION AND/OR
DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED AND WHETHER UNDER THEORY OF
CONTRACT, TORT (INCLUDING NEGLIGENCE), STRICT LIABILITY OR OTHERWISE, EVEN IF
APPLE HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

Copyright (C) 2008 Apple Inc. All Rights Reserved.

*/


#include <AudioToolbox/AudioToolbox.h>
#import "OPAAudioQueueObject.h"
#import "OPAAudioPlayer.h"


static void playbackCallback (
	void					*inUserData,
	AudioQueueRef			inAudioQueue,
	AudioQueueBufferRef		bufferReference
) {
	// This callback, being outside the implementation block, needs a reference to the AudioPlayer object
	OPAAudioPlayer *player = (OPAAudioPlayer *) inUserData;
	if ([player donePlayingFile])
	{
//		NSLog(@"Player done!");
	}
		
	UInt32 numBytes;
	UInt32 numPackets = [player numPacketsToRead];

	// This callback is called when the playback audio queue object has an audio queue buffer
	// available for filling with more data from the file being played
	AudioFileReadPackets (
		[player audioFileID],
		NO,
		&numBytes,
		[player packetDescriptions],
		[player startingPacketNumber],
		&numPackets, 
		bufferReference->mAudioData
	);
		
	if (numPackets > 0) {

		bufferReference->mAudioDataByteSize = numBytes;		

		AudioQueueEnqueueBuffer (
			inAudioQueue,
			bufferReference,
			([player packetDescriptions] ? numPackets : 0),
			[player packetDescriptions]
		);
		
		[player incrementStartingPacketNumberBy: (UInt32) numPackets];
		
	} else {

		if (player.bLooping)
		{
			player.startingPacketNumber = 0;
			playbackCallback(inUserData, inAudioQueue, bufferReference);		
		} else {
		
				[player setDonePlayingFile: YES];		// 'donePlayingFile' used by playbackCallback and setupAudioQueueBuffers

			// if playback is stopping because file is finished, then call AudioQueueStop here
			// if user clicked Stop, then the AudioViewController calls AudioQueueStop
			if (player.audioPlayerShouldStopImmediately == NO) {
				[player stop];
			}
		}
	}
}

// property callback function, invoked when a property changes. 
static void propertyListenerCallback (
	void					*inUserData,
	AudioQueueRef			queueObject,
	AudioQueuePropertyID	propertyID
) {
	// This callback, being outside the implementation block, needs a reference to the AudioPlayer object
	OPAAudioPlayer *player = (OPAAudioPlayer *) inUserData;
	
	if (player.notificationDelegate && [player.notificationDelegate respondsToSelector:@selector(audioQueueStateChangeCallback:)])
		[player.notificationDelegate audioQueueStateChangeCallback:player];
}


@implementation OPAAudioPlayer

@synthesize packetDescriptions;
@synthesize bufferByteSize;
@synthesize gain;
@synthesize numPacketsToRead;
@synthesize donePlayingFile;
@synthesize audioPlayerShouldStopImmediately;
@synthesize bLooping;


- (id) initWithCFURL: (CFURLRef) soundFile {

	bLooping = YES;
	
	self = [super init];

	if (self != nil) {

		[self setAudioFileURL: soundFile];
		OSStatus status = [self openPlaybackFile: [self audioFileURL]];
		if (status == noErr)
		{
			[self setupPlaybackAudioQueueObject];
			[self setDonePlayingFile: NO];
			[self setAudioPlayerShouldStopImmediately: NO];
		} else {
			return nil;
		}
	}

	return self;
} 

// magic cookies are not used by linear PCM audio. this method is included here
//	so this app still works if you change the recording format to one that uses
//	magic cookies.
- (void) copyMagicCookieToQueue: (AudioQueueRef) queue fromFile: (AudioFileID) file {

	UInt32 propertySize = sizeof (UInt32);
	
	OSStatus result = AudioFileGetPropertyInfo (
							file,
							kAudioFilePropertyMagicCookieData,
							&propertySize,
							NULL
						);

	if (!result && propertySize) {
	
		char *cookie = (char *) malloc (propertySize);		
		
		AudioFileGetProperty (
			file,
			kAudioFilePropertyMagicCookieData,
			&propertySize,
			cookie
		);
			
		AudioQueueSetProperty (
			queue,
			kAudioQueueProperty_MagicCookie,
			cookie,
			propertySize
		);
			
		free (cookie);
	}
}

- (OSStatus) openPlaybackFile: (CFURLRef) soundFile {

	AudioFileTypeID audioFileTypeId = kAudioFileCAFType; //wav
	NSURL *url = (NSURL *)self.audioFileURL;
	NSString *urlStr = [url absoluteString];
	
	if ([[urlStr pathExtension] isEqualToString:@"wav"])
	{
		audioFileTypeId = kAudioFileCAFType;
	} else 	if ([[urlStr pathExtension] isEqualToString:@"mp3"]) {
		audioFileTypeId = kAudioFileMP3Type;	
	} else 	if ([[urlStr pathExtension] isEqualToString:@"m4a"]) {
		audioFileTypeId = kAudioFileM4AType;
	} else 	if ([[urlStr pathExtension] isEqualToString:@"mp4"]) {
		audioFileTypeId = kAudioFileMPEG4Type;
	} else 	if ([[urlStr pathExtension] isEqualToString:@"aiff"]) {
		audioFileTypeId = kAudioFileAIFFType;
	} else 	if ([[urlStr pathExtension] isEqualToString:@"3gp"]) {
		audioFileTypeId = kAudioFile3GPType;
	} else 	if ([[urlStr pathExtension] isEqualToString:@"amr"]) {
		audioFileTypeId = kAudioFileAMRType;
	}

	OSStatus status = AudioFileOpenURL (	
		(CFURLRef) self.audioFileURL,
		0x01, //fsRdPerm,						// read only
		audioFileTypeId,
		&audioFileID
	);

	if (status == noErr)
	{
		UInt32 sizeOfPlaybackFormatASBDStruct = sizeof ([self audioFormat]);
		
		// get the AudioStreamBasicDescription format for the playback file
		status = AudioFileGetProperty (
			[self audioFileID], 
			kAudioFilePropertyDataFormat,
			&sizeOfPlaybackFormatASBDStruct,
			&audioFormat
		);		
	} 
	
	if (status != noErr) {
		NSLog(@"AudioFileOpenURL returned %d when opening %@ with type: %4c", status, urlStr, audioFileTypeId);
	}
	return status;
}

- (void) setupPlaybackAudioQueueObject {

	// create the playback audio queue object
	AudioQueueNewOutput (
		&audioFormat,
		playbackCallback,
		self, 
		CFRunLoopGetCurrent (),
		kCFRunLoopCommonModes,
		0,								// run loop flags
		&queueObject
	);
	
	// set the volume of the playback audio queue
	[self setGain: 1.0];
	
	AudioQueueSetParameter (
		queueObject,
		kAudioQueueParam_Volume,
		gain
	);
	
	[self enableLevelMetering];

	// add the property listener callback to the playback audio queue
	AudioQueueAddPropertyListener (
		[self queueObject],
		kAudioQueueProperty_IsRunning,
		propertyListenerCallback,
		self
	);

	// copy the audio file's magic cookie to the audio queue object to give it 
	// as much info as possible about the audio data to play
	[self copyMagicCookieToQueue: queueObject fromFile: audioFileID];
}

- (void) setupAudioQueueBuffers {

	// calcluate the size to use for each audio queue buffer, and calculate the
	// number of packets to read into each buffer
	[self calculateSizesFor: (Float64) kSecondsPerBuffer];

	// For VBR files, set up the packetDescriptions
	// Test for VBR format files which need extra initialization
	if(audioFormat.mBytesPerPacket == 0 || audioFormat.mFramesPerPacket == 0) {
		packetDescriptions = (AudioStreamPacketDescription *)malloc(numPacketsToRead * sizeof(AudioStreamPacketDescription));
	} else {
		packetDescriptions = NULL;
	}
	
	// prime the queue with some data before starting
	// allocate and enqueue buffers				
	int bufferIndex;
	
	for (bufferIndex = 0; bufferIndex < kNumberAudioDataBuffers; ++bufferIndex) {
	
		if (packetDescriptions != NULL)
		{
			AudioQueueAllocateBufferWithPacketDescriptions (
				[self queueObject],
				[self bufferByteSize],
				[self numPacketsToRead],
				&buffers[bufferIndex]
			);
		} else {
		
			AudioQueueAllocateBuffer (
				[self queueObject],
				[self bufferByteSize],
				&buffers[bufferIndex]
			);
		}
		playbackCallback ( 
			self,
			[self queueObject],
			buffers[bufferIndex]
		);
		
		if ([self donePlayingFile]) break;
	}
}


- (void) play {

	[self setupAudioQueueBuffers];

	AudioQueueStart (
		self.queueObject,
		NULL			// start time. NULL means ASAP.
	);
}

- (void) stop {

	AudioFileClose (self.audioFileID);

	AudioQueueStop (
		self.queueObject,
		self.audioPlayerShouldStopImmediately
	);
	
}


- (void) pause {

	AudioQueuePause (
		self.queueObject
	);
}


- (void) resume {

	AudioQueueStart (
		self.queueObject,
		NULL			// start time. NULL means ASAP
	);
}


- (void) calculateSizesFor: (Float64) seconds {

	UInt32 maxPacketSize;
	UInt32 propertySize = sizeof (maxPacketSize);
	
	AudioFileGetProperty (
		audioFileID, 
		kAudioFilePropertyPacketSizeUpperBound,
		&propertySize,
		&maxPacketSize
	);

	static const int maxBufferSize = 0x10000;	// limit maximum size to 64K
	static const int minBufferSize = 0x4000;	// limit minimum size to 16K

	if (audioFormat.mFramesPerPacket) {
		Float64 numPacketsForTime = audioFormat.mSampleRate / audioFormat.mFramesPerPacket * seconds;
		[self setBufferByteSize: numPacketsForTime * maxPacketSize];
	} else {
		// if frames per packet is zero, then the codec doesn't know the relationship between 
		// packets and time -- so we return a default buffer size
		[self setBufferByteSize: maxBufferSize > maxPacketSize ? maxBufferSize : maxPacketSize];
	}
	
		// we're going to limit our size to our default
	if (bufferByteSize > maxBufferSize && bufferByteSize > maxPacketSize) {
		[self setBufferByteSize: maxBufferSize];
	} else {
		// also make sure we're not too small - we don't want to go the disk for too small chunks
		if (bufferByteSize < minBufferSize) {
			[self setBufferByteSize: minBufferSize];
		}
	}
	
	[self setNumPacketsToRead: self.bufferByteSize / maxPacketSize];
}


- (void) dealloc {
	
	AudioQueueDispose (
		queueObject, 
		YES
	);

	if (packetDescriptions)
	{
		free(packetDescriptions);
		packetDescriptions = NULL;
	}
	
	[super dealloc];
}

@end
