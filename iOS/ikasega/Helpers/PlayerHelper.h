//
//  PlayerHelper.h
//  ikasega
//
//  Created by Sergio Garcia on 6/11/14.
//  Copyright (c) 2014 Sergio Garcia. All rights reserved.
//

@import AVFoundation;
@import UIKit;

extern NSString * const PlayerHelperDidChangeStateNotification;

@interface PlayerHelper : NSObject

+ (PlayerHelper *)sharedPlayer;

@property (strong, nonatomic) AVAudioPlayer *player;
@property (readonly, getter=isPlaying) BOOL playing;

- (void)remoteControlReceivedWithEvent:(UIEvent *)receivedEvent;
- (void)enableMainControls:(BOOL)enable;
- (void)updateCurrentTrackInfoWithTitle:(NSString *)title author:(NSString *)author album:(NSString *)album;

@end
