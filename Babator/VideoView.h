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

- (void)loadVideoForURL:(NSString*)url;

@end

@protocol VideoViewDelegate <NSObject>

- (void)fullScreenForVideoView:(VideoView*)videoView;

@end
