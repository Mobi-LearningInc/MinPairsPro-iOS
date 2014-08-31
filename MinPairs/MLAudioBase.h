//
//  MLAudioBase.h
//  MinPairs
//
//  Created by Brandon on 2014-04-24.
//  Copyright (c) 2014 MobiLearning. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MLBaseAudioPlayerDelegate.h"

/**
 *  A protocol for which all audio player classes must conform to.
 *  Contains the minimum function declarations for an audio player.
 */
@protocol MLAudioBase <NSObject>

/**
 *  Determines whether or not the audio player is playing.
 *  @return True if the audio player is playing a sound. False otherwise.
 */
-(bool) isPlaying;

/**
 *  Determines whether or not the audio player is paused.
 *  @return True if the audio player is paused. False otherwise.
 */
-(bool) isPaused;

/** 
 *  Plays the audio file set by @see setAudioFile.
 */
-(void) play;


/** 
 *  Stops playing audio.
 */
-(void) stop;


/** 
 *  Pauses the current audio player. 
 */
-(void) pause;


/** 
 *  Sets the volume level of the audio player.
 *  @param volumeLevel An integer ranging from 0 to 100. Determines how loud the sound will be.
 */
-(void) setVolume: (NSUInteger) volumeLevel;


/**
 *  Prepares the audio player for playback by preloading its buffers.
 *  Calling this method preloads buffers and acquires the audio hardware needed
 *  for playback, which minimizes the lag between calling the play method and the start of sound output.
 *  Calling the stop method, or allowing a sound to finish playing, undoes this setup.
 *  @note An audio player may not be able to prepare buffers to playing. Such audio players may return false.
 *  @return True if successful. False otherwise.
 */
-(bool) prepareToPlay;


/**
 *  Loads a sound file from the application resources.
 *  @param fileName Name of the file to be loaded.
 *  @param extension File extension of the file to be loaded.
 *  @return True if the file is found in the resources. False otherwise.
 */
-(bool) loadFileFromResource:(NSString*)fileName withExtension:(NSString*)extension;


/**
 *  Calls implemented delegate methods when an event occurs.
 */
@property (nonatomic, weak) id <MLBaseAudioPlayerDelegate> delegate;

@end
