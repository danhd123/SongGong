//
//  SpookSoundManager.h
//  Spook
//
//  Created by Arshad Tayyeb on 9/21/09.
//  Copyright 2009 Off Panel Productions Productions, Inc.. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OPAAudioPlayer.h"
#import "OPAAudioQueueObject.h"

@interface OPASpookSoundManager : NSObject <OPAAudioQueueObjectDelegate> {
	BOOL						ambientIsPlaying;
	OPAAudioPlayer					*audioPlayer;
	NSString					*ambientSoundFilename;
	SystemSoundID				ambientSoundID;
	NSMutableDictionary			*soundIDs;
	NSMutableDictionary			*savedSoundPlayers;
}

@property (nonatomic, retain)	OPAAudioPlayer				*audioPlayer;
@property (nonatomic, retain)	NSString				*ambientSoundFilename;

+ (void)playShortSound:(NSString *)soundFilename disposeWhenDone:(BOOL)bDispose;

- (void)playShortSoundID:(SystemSoundID)soundID;
- (void)playShortSound:(NSString *)soundFilename disposeWhenDone:(BOOL)bDispose;
- (void)startPlayingAmbientSound:(NSString *)filename;
- (void)stopAmbientSound;

@end
