//
//  VideoView.m
//  Babator
//
//  Created by Andrey Kulinskiy on 6/4/15.
//  Copyright (c) 2015 Andrey Kulinskiy. All rights reserved.
//

#import "VideoView.h"
#import "AKPlayerView.h"
#import "VideoPanelView.h"

@import AVFoundation;

@interface VideoView () <VideoPanelViewDelegate>

@property (nonatomic, strong) AKPlayerView* playerView;
@property (nonatomic, strong) VideoPanelView* panelView;

@end

@implementation VideoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    
    self.userInteractionEnabled = YES;
    
    [self addSubview:self.playerView];
    [self addSubview:self.panelView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playToEndTimeNotification:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(failedToPlayToEndTimeNotification:)
                                                 name:AVPlayerItemFailedToPlayToEndTimeNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(timeJumpedNotification:)
                                                 name:AVPlayerItemTimeJumpedNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playbackStalledNotification:)
                                                 name:AVPlayerItemPlaybackStalledNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(newAccessLogEntryNotification:)
                                                 name:AVPlayerItemNewAccessLogEntryNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(newErrorLogEntryNotification:)
                                                 name:AVPlayerItemNewErrorLogEntryNotification
                                               object:nil];
    
    UITapGestureRecognizer* tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tabToContent:)];
    [self addGestureRecognizer:tapGestureRecognizer];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.playerView.frame = self.bounds;
    self.panelView.frame = CGRectMake(0, self.height - 40, self.width, 40);
}

- (void)setUrl:(NSString*)url duration:(NSInteger)duration
{
    [super setUrl:url duration:duration];
}

- (void)loadVideoForURL:(NSString*)url {
    
//    NSURL* urlTmp = [NSURL URLWithString:@"http://n23.filecdn.to/ff/NDcxMjk4MGZmNmRmNDBiMGY2ZjE2OTJiM2YyYmU5ZTl8ZnN0b3wxMzQ4MjY0NTc0fDEwMDAwfDJ8MHw1fDIzfGUzY2FjMTY3NjY5OWJhZjI0ZjNlNmE4ZDQ0NTMzYWQxfDB8MjQ6aC40MjpzfDB8MjAxODU5NjYwNnwxNDMzMzE4MjE4LjUzMzk,/play_698j93w00plnrodv1itd0heuu.0.4278037390.2185543202.1433148971.mp4"];
    
    self.playerView.hidden = YES;
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:[NSURL URLWithString:url] options:nil];
    //AVURLAsset *asset = [AVURLAsset URLAssetWithURL:urlTmp options:nil];
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:asset];
    AVPlayer *player = [AVPlayer playerWithPlayerItem:playerItem];
    self.playerView.player = player;
}

- (void)videoPlay:(BOOL)isPlay {
    if (self.playerView.hidden) {
        self.playerView.hidden = NO;
    }
    
    self.panelView.isPlay = isPlay;
    
    if (isPlay) {
        [self.playerView.player play];
    }
    else {
        [self.playerView.player pause];
    }
}

- (void)showPanel:(BOOL)show {
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.panelView.alpha = (show) ? 1.0 : 0.0;
    } completion:^(BOOL finished){
        
    }];
}

#pragma mark -
#pragma mark Actions
- (void)tabToContent:(UITapGestureRecognizer*)recognizer {
    if (self.panelView.alpha < 1.0) {
        [self showPanel:YES];
    }
    else {
        [self showPanel:NO];
    }
}

#pragma mark -
#pragma mark Property
- (AKPlayerView *)playerView {
    if (!_playerView) {
        _playerView = [[AKPlayerView alloc]initWithFrame:CGRectZero];
        _playerView.backgroundColor = [UIColor blackColor];
        _playerView.hidden = YES;
        _playerView.userInteractionEnabled = NO;
    }
    return _playerView;
}

- (VideoPanelView *)panelView {
    if (!_panelView) {
        _panelView = [[VideoPanelView alloc]initWithFrame:CGRectZero];
        _panelView.delegate = self;
        _panelView.alpha = 0.0;
    }
    return _panelView;
}

- (AVPlayer*)player {
    return self.playerView.player;
}

- (void)setIsPlay:(BOOL)isPlay {
    _isPlay = isPlay;
    self.panelView.isPlay = isPlay;
    [self videoPlay:isPlay];
}

#pragma mark -
#pragma mark VideoPanelView Delegate
- (void)clickPlayForVideoPanelView:(VideoPanelView*)videoPanelView {
    [self videoPlay:YES];
    
//    Float64 dur = CMTimeGetSeconds(self.playerView.player.currentItem.duration);
//
//    dur -= 20;
//
//    CMTime newTime = CMTimeMakeWithSeconds(dur, 1);
//    [self.playerView.player seekToTime:newTime];
}

- (void)clickPauseForVideoPanelView:(VideoPanelView*)videoPanelView {
    [self videoPlay:NO];
}

- (void)clickBackForVideoPanelView:(VideoPanelView*)videoPanelView {
    NSLog(@"clickBackForVideoPanelView");
}

- (void)clickFullScreenForVideoPanelView:(VideoPanelView*)videoPanelView {
    [self.delegate fullScreenForVideoView:self];
}

#pragma mark -
#pragma mark Notifications
- (void)playToEndTimeNotification:(NSNotification*)notification {
    //NSLog(@"AVPlayerItemDidPlayToEndTimeNotification");
    self.playerView.hidden = YES;
}

- (void)failedToPlayToEndTimeNotification:(NSNotification*)notification {
    NSLog(@"AVPlayerItemFailedToPlayToEndTimeNotification");
}

- (void)timeJumpedNotification:(NSNotification*)notification {
    NSLog(@"AVPlayerItemTimeJumpedNotification");
}

- (void)playbackStalledNotification:(NSNotification*)notification {
    NSLog(@"AVPlayerItemPlaybackStalledNotification");
    //[self.playerLayer.player play];
    //self.btnPlay.selected = NO;
    [self videoPlay:NO];
}

- (void)newAccessLogEntryNotification:(NSNotification*)notification {
    NSLog(@"AVPlayerItemNewAccessLogEntryNotification");
    //[self.playerLayer.player play];
}

- (void)newErrorLogEntryNotification:(NSNotification*)notification {
    NSLog(@"AVPlayerItemNewErrorLogEntryNotification");
}



@end




