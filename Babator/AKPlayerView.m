//
//  AKPlayerView.m
//  Babator
//
//  Created by Andrey Kulinskiy on 6/3/15.
//  Copyright (c) 2015 Andrey Kulinskiy. All rights reserved.
//

#import "AKPlayerView.h"
#import <AVFoundation/AVFoundation.h>

@implementation AKPlayerView

+ (Class)layerClass {
    return [AVPlayerLayer class];
}

- (AVPlayer*)player {
    return [(AVPlayerLayer*)[self layer] player];
}

- (BOOL)isReadyForDisplay {
    return ((AVPlayerLayer*)[self layer]).readyForDisplay;
}

- (void)setPlayer:(AVPlayer *)player {
    [(AVPlayerLayer*)[self layer] setPlayer:player];
}

@end
