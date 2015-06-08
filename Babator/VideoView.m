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
@property (nonatomic, strong) NSTimer* sliderTimer;
@property (nonatomic, copy) NSString* urlVideo;

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidEnterBackgroundHandler:)
                                                 name:APP_DID_ENTER_BACKGROUND
                                               object:nil];
    
    UITapGestureRecognizer* tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tabToContent:)];
    [self addGestureRecognizer:tapGestureRecognizer];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.sliderTimer invalidate];
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

- (void)loadVideoForURL:(NSString*)url { // AVAssetResourceLoaderDelegate
    
    self.urlVideo = url;
    
//    NSURL* urlTmp = [NSURL URLWithString:@"http://n23.filecdn.to/ff/NDcxMjk4MGZmNmRmNDBiMGY2ZjE2OTJiM2YyYmU5ZTl8ZnN0b3wxMzQ4MjY0NTc0fDEwMDAwfDJ8MHw1fDIzfGUzY2FjMTY3NjY5OWJhZjI0ZjNlNmE4ZDQ0NTMzYWQxfDB8MjQ6aC40MjpzfDB8MjAxODU5NjYwNnwxNDMzMzE4MjE4LjUzMzk,/play_698j93w00plnrodv1itd0heuu.0.4278037390.2185543202.1433148971.mp4"];
    
    self.panelView.slider.value = 0.0;
    self.panelView.slider.minimumValue = 0.0;
    [self.sliderTimer invalidate];
    self.sliderTimer = nil;
    
    self.playerView.hidden = YES;
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:[NSURL URLWithString:url] options:nil];
    //AVURLAsset *asset = [AVURLAsset URLAssetWithURL:urlTmp options:nil];
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:asset];
    AVPlayer *player = [AVPlayer playerWithPlayerItem:playerItem];
    self.playerView.player = player;
}

- (void)videoPlay:(BOOL)isPlay {
    
    if (!self.urlVideo || [self.urlVideo length] == 0) {
        return;
    }
    
    if (self.playerView.hidden) {
        self.playerView.hidden = NO;
    }
    
    self.panelView.isPlay = isPlay;
    
    if (isPlay) {
        [self.playerView.player play];
        if (!self.sliderTimer) {
            self.sliderTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateSlider) userInfo:nil repeats:YES];
        }
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

- (void)updateSlider {
    
    self.panelView.slider.maximumValue = [self durationInSeconds];
    self.panelView.slider.value = [self currentTimeInSeconds];
}

- (Float64)durationInSeconds {
    Float64 dur = 0.0;
    CMTime time = self.player.currentItem.duration;
    if(time.flags == kCMTimeFlags_Valid) {
        dur = CMTimeGetSeconds(time);
    }
    return dur;
}


- (Float64)currentTimeInSeconds {
    Float64 dur = CMTimeGetSeconds([self.player currentTime]);
    return dur;
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

- (void)setIsHidePlayer:(BOOL)isHidePlayer {
    _isHidePlayer = isHidePlayer;
    self.playerView.hidden = isHidePlayer;
}

#pragma mark -
#pragma mark VideoPanelView Delegate
- (void)clickPlayForVideoPanelView:(VideoPanelView*)videoPanelView {
    [self videoPlay:YES];
}

- (void)clickPauseForVideoPanelView:(VideoPanelView*)videoPanelView {
    [self videoPlay:NO];
}

- (void)clickBackForVideoPanelView:(VideoPanelView*)videoPanelView {
    [self.delegate backForVideoView:self];
}

- (void)clickFullScreenForVideoPanelView:(VideoPanelView*)videoPanelView {
    [self.delegate fullScreenForVideoView:self];
}

- (void)moveSliderForVideoPanelView:(VideoPanelView*)videoPanelView {
    CMTime newTime = CMTimeMakeWithSeconds(videoPanelView.slider.value, 1);
    [self.player seekToTime:newTime];
}

#pragma mark -
#pragma mark Notifications
- (void)playToEndTimeNotification:(NSNotification*)notification {
    //NSLog(@"AVPlayerItemDidPlayToEndTimeNotification");
    [self videoPlay:NO];
    self.playerView.hidden = YES;
    CMTime newTime = CMTimeMakeWithSeconds(0, 1);
    [self.player seekToTime:newTime];

    [self.sliderTimer invalidate];
    self.sliderTimer = nil;
    self.panelView.slider.value = 0.0;
    self.panelView.slider.minimumValue = 0.0;
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
    [self videoPlay:YES];
}

- (void)newAccessLogEntryNotification:(NSNotification*)notification {
    NSLog(@"AVPlayerItemNewAccessLogEntryNotification");
    //[self.playerLayer.player play];
//    if (!self.sliderTimer) {
//        self.sliderTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateSlider) userInfo:nil repeats:YES];
//        self.panelView.slider.maximumValue = [self durationInSeconds];
//    }
}

- (void)newErrorLogEntryNotification:(NSNotification*)notification {
    NSLog(@"AVPlayerItemNewErrorLogEntryNotification");
}

- (void) applicationDidEnterBackgroundHandler:(NSNotification*) notification {
    self.panelView.isPlay = NO;
}



@end




