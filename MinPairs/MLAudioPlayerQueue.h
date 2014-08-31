//
//  MLAudioPlayerQueue.h
//  MinPairs
//
//  Created by Brandon on 2014-04-24.
//  Copyright (c) 2014 MobiLearning. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MLBasicAudioPlayer.h"
#import "MLAudioPlayerQueueDelegate.h"


/**
 *  A queue for synchronising playback of multiple audio files.
 *  Underlying audio player is MLBasicAudioPlayer.
 *  Each sound is played one after the other.
 *  Prevents the user from spamming audio playing.
 */
@interface MLAudioPlayerQueue : NSObject

/**
 *  Replays the last played audio file.
 *  If no file was played, this function does nothing.
 */
-(void) replay;


/**
 *  Plays an audio file.
 *  @param fileID Unique Identifier of the file to play.
 */
-(void) play:(NSUInteger)fileID;


/**
 *  Prepares the audio player for playback by preloading its buffers.
 *  Calling this method preloads buffers and acquires the audio hardware needed
 *  for playback, which minimizes the lag between calling the play method and the start of sound output.
 *  Calling the stop method, or allowing a sound to finish playing, undoes this setup.
 *
 *  @warning Avoid preparing TOO MANY files at the same time (32+).
 *  @return True if successful. False otherwise.
 */
-(void) prepareToPlay: (NSUInteger)fileID;


/**
 *  Adds a file to the Queue to be played from the application's resources.
 *  If the file already exists, this function does nothing.
 *
 *  @param fileID Unique Identifier of the file to be added. 
 *         This identifier will be used later to play the file.
 *
 *  @param fileName Name of the file to be added.
 *  @param extension Extension of the file being added.
 */
-(void) addFile:(NSUInteger)fileID withFileName:(NSString*)fileName withExtension:(NSString*)extension;


/**
 *  Initialises the queue with a capacity. 
 *  Allows the queue to pre-allocate a fixed amount of memory.
 *
 *  @param cls An audio player class that conforms to MLAudioBase.
 *         
 *  Example: @code [MLBasicAudioPlayer class] @endcode
 *
 *  @param capacity Size of the queue to be allocated. 
 *         Equivalent to the amount of audio files to be added.
 *         The queue will grow in size if this capacity reached.
 */
-(MLAudioPlayerQueue*) initWithClass:(__unsafe_unretained Class)cls andCapacity:(NSUInteger)capacity;

/**
 *  Calls implemented delegate methods when an event occurs.
 */
@property (nonatomic, weak) id<MLAudioPlayerQueueDelegate> delegate;

@end
