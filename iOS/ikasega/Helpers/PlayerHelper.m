//
//  PlayerHelper.m
//  ikasega
//
//  Created by Sergio Garcia on 6/11/14.
//  Copyright (c) 2014 Sergio Garcia. All rights reserved.
//

#import "PlayerHelper.h"

@import UIKit;
@import MediaPlayer;

NSString * const PlayerHelperDidChangeStateNotification = @"PlayerHelperDidChangeStateNotification";

@interface PlayerHelper() {
    
    NSMutableDictionary *currentTrack;
}

@end

@implementation PlayerHelper


+ (PlayerHelper *)sharedPlayer {
    
    static PlayerHelper *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[PlayerHelper alloc] init];
    });
    return _sharedInstance;
}

- (id)init {
    
    self = [super init];
    if (self) {
        [self enableMainControls:YES];
    }
    return self;
}

- (void)enableMainControls:(BOOL)enable {
    
    if (enable) {
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback
                                               error:nil];
        [[AVAudioSession sharedInstance] setActive:YES
                                             error:nil];
        [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
        //[self hola];
    } else {
         [[AVAudioSession sharedInstance] setActive:NO
                                              error:nil];
        [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    }
}

- (void)updateCurrentTrackInfoWithTitle:(NSString *)title author:(NSString *)author album:(NSString *)album {
    
    Class playingInfoCenter = NSClassFromString(@"MPNowPlayingInfoCenter");
    if (playingInfoCenter) {
        currentTrack = [[NSMutableDictionary alloc] init];
        
        [currentTrack setObject:title forKey:MPMediaItemPropertyTitle];
        [currentTrack setObject:author forKey:MPMediaItemPropertyArtist];
        [currentTrack setObject:album forKey:MPMediaItemPropertyAlbumTitle];
        
        [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:currentTrack];
        [self updateMPRemoteCommandCenterTimes];
    }
}

- (void)updateMPRemoteCommandCenterTimes {
    
    if (!currentTrack) {
        currentTrack = [[NSMutableDictionary alloc] init];
    }
    
    NSInteger seconds = floor(self.player.duration);
    [currentTrack setObject:[NSNumber numberWithInteger:seconds] forKey:MPMediaItemPropertyPlaybackDuration];
    
    NSInteger currentTime = floor(self.player.currentTime);
    [currentTrack setObject:[NSNumber numberWithInteger:currentTime] forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
    
    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:currentTrack];

}

-(void)skipBackwardEvent:(MPSkipIntervalCommandEvent *)skipEvent
{
    NSLog(@"Skip backward (%@) by %f type:%@", skipEvent.command, skipEvent.interval, skipEvent.command);
    [_player stop];
    if ((_player.currentTime - skipEvent.interval) > 0) {
        [_player setCurrentTime:_player.currentTime - skipEvent.interval];
    } else {
        [_player setCurrentTime:0];
    }
    [_player prepareToPlay];
    [_player play];
    [self updateMPRemoteCommandCenterTimes];
    
}

-(void)skipForwardEvent:(MPSkipIntervalCommandEvent *)skipEvent
{
    NSLog(@"Skip forward by %f", skipEvent.interval);
    BOOL state = _player.isPlaying;
    [_player stop];
    NSTimeInterval current = _player.currentTime;
    NSTimeInterval duration = _player.duration;
    if ((current + skipEvent.interval) < duration) {
        [_player setCurrentTime:(current + skipEvent.interval)];
        [_player prepareToPlay];
        if (state) {
            [_player play];
        }
        [self updateMPRemoteCommandCenterTimes];
    }
}

- (void)playOrPauseEvent:(MPSkipIntervalCommandEvent *)skipEvent {}

- (void)remoteControlReceivedWithEvent:(UIEvent *)receivedEvent {
    
    if (receivedEvent.type == UIEventTypeRemoteControl) {
        //Check again type
        switch (receivedEvent.subtype) {
            case UIEventSubtypeRemoteControlPreviousTrack:
                NSLog(@"UIEventSubtypeRemoteControlPreviousTrack");
                break;
                
            case UIEventSubtypeRemoteControlNextTrack:
                NSLog(@"UIEventSubtypeRemoteControlNextTrack");
                break;
                
            case UIEventSubtypeRemoteControlPlay:
                NSLog(@"UIEventSubtypeRemoteControlPlay");
                [_player play];
                _playing = YES;
                break;
            case UIEventSubtypeRemoteControlPause:
                NSLog(@"UIEventSubtypeRemoteControlPause");
                [_player pause];
                _playing = NO;
                break;
                
            case UIEventSubtypeRemoteControlStop:
                NSLog(@"UIEventSubtypeRemoteControlStop");
                [_player stop];
                _playing = NO;
                break;
            default:
                NSLog(@"Unhandled type: %d", receivedEvent.subtype);
                break;
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:PlayerHelperDidChangeStateNotification object:nil];
    }
}



@end
