//
//  VideoView.h
//  Babator
//
//  Created by Andrey Kulinskiy on 6/4/15.
//  Copyright (c) 2015 Andrey Kulinskiy. All rights reserved.
//

#import "ThumbnailView.h"

@class AVPlayer;
@protocol VideoViewDelegate;

@interface VideoView : ThumbnailView

//@property (nonatomic, readonly) AVPlayer* player;
@property (nonatomic, weak) id<VideoViewDelegate> delegate;
@property (nonatomic, assign) BOOL isPlay;
@property (nonatomic, assign) BOOL isHidePlayer;

- (void)loadVideoForURL:(NSString*)url;

@end

@protocol VideoViewDelegate <NSObject>

- (void)fullScreenForVideoView:(VideoView*)videoView;
- (void)backForVideoView:(VideoView*)videoView;
- (void)playToEndTimeForVideoView:(VideoView*)videoView;

@end
