//
//  MLAudioPlayerQueueDelegate.h
//  MinPairs
//
//  Created by Brandon on 2014-04-25.
//  Copyright (c) 2014 MobiLearning. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 *  A protocol defining event delegates for MLAudioPlayerQueue.
 */
@protocol MLAudioPlayerQueueDelegate <NSObject>


/**
 *  Called when the audio queue finishes playing a sound.
 *  @param ID Identifier of the file that is finished playing.
 */
-(void) onMLAudioPlayerQueueFinishPlaying:(NSUInteger)ID;


/**
 *  Called when the audio queue finishes playing all sounds.
 */
-(void) onMLAudioPlayerQueueComplete;

@end