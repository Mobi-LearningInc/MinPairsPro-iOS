//
//  MLBasicAudioPlayerDelegate.h
//  MinPairs
//
//  Created by Brandon on 2014-04-25.
//  Copyright (c) 2014 MobiLearning. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MLAudioBase;

/**
 *  A protocol defining event delegates for MLBasicAudioPlayer.
 */
@protocol MLBaseAudioPlayerDelegate <NSObject>

/**
 *  Called when the audio player is finished playing the current sound.
 *  @param sender The audio player that finished playing the sound.
 */
-(void) onMLAudioPlayerFinishPlaying:(id<MLAudioBase>)sender;
@end
