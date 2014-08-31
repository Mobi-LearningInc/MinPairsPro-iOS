//
//  MLBasicAudioPlayer.h
//  MinPairs
//
//  Created by Brandon on 2014-04-24.
//  Copyright (c) 2014 MobiLearning. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVAudioSession.h>
#import <AVFoundation/AVAudioPlayer.h>
#import "MLAudioBase.h"
#import "MLBaseAudioPlayerDelegate.h"

/**
 *  A basic audio player using the AVAudioPlayer internally.
 *  Conforms to MLAudioBase Protocol
 */
@interface MLBasicAudioPlayer : NSObject<MLAudioBase>

/**
 *  Calls implemented delegate methods when an event occurs.
 */
@property (nonatomic, weak) id <MLBaseAudioPlayerDelegate> delegate;


/**
 *  Determines if the current player's state is playing.
 *  @return True if audio is playing. False otherwise.
 */
-(bool) isPlaying;


/**
 *  Determines if the current player's state is paused.
 *  @return True if audio is playing. False otherwise.
 */
-(bool) isPaused;


/**
 *  Initialises the class's internal data.
 *  @return Returns the a pointer to the initialised instance.
 */
-(id<MLAudioBase>) init;

@end
