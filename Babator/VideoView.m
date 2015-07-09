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

@interface VideoView () <VideoPanelViewDelegate, AVAssetResourceLoaderDelegate>

@property (nonatomic, strong) AKPlayerView* playerView;
@property (nonatomic, strong) VideoPanelView* panelView;
@property (nonatomic, strong) NSTimer* sliderTimer;
@property (nonatomic, copy) NSString* urlVideo;
@property (nonatomic, assign) unsigned long totalSize;
@property (nonatomic, assign) BOOL isFirstCaching;

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
    
    self.infoView.hidden = YES;
    
    [self showPanel:YES];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.sliderTimer invalidate];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.playerView.frame = self.bounds;
    self.panelView.frame = CGRectMake(0, self.height - 36, self.width, 36);
}

- (void)setUrl:(NSString*)url title:(NSString*)title duration:(NSInteger)duration
{
    [super setUrl:url title:title duration:duration];
    [self.panelView setCurrentTime:0.0 duration:duration];
}

- (void)loadVideoForURL:(NSString*)url size:(unsigned long)size {
    
    self.urlVideo = url;
    self.totalSize = size;
    self.isFirstCaching = YES;
    
    self.panelView.slider.value = 0.0;
    [self.panelView setCurrentTime:0.0 duration:self.duration];
    self.panelView.slider.minimumValue = 0.0;
    [self.sliderTimer invalidate];
    self.sliderTimer = nil;
    
    self.playerView.hidden = YES;
    //NSLog(@"%@", [NSURL fileURLWithPath: url]);
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:[NSURL URLWithString:url] options:nil];
    
    //AVURLAsset *asset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath: url] options:nil];
    [asset.resourceLoader setDelegate:self queue:dispatch_get_main_queue()];
    
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:asset];
    AVPlayer *player = [AVPlayer playerWithPlayerItem:playerItem];
    
    //AVPlayer *player = [AVPlayer playerWithURL:[NSURL fileURLWithPath: url]];
    
    self.playerView.player = player;
    
    //[self performSelector:@selector(loadVideoForURL_helper) withObject:nil afterDelay:5.0];
}

- (BOOL)resourceLoader:(AVAssetResourceLoader *)resourceLoader shouldWaitForLoadingOfRequestedResource:(AVAssetResourceLoadingRequest *)loadingRequest
{
    //NSLog(@"shouldWaitForLoadingOfRequestedResource");
    
    //NSLog(@"%@", loadingRequest.request.URL);
    if (![[loadingRequest.request.URL absoluteString] isEqualToString:self.urlVideo]) {
        //NSLog(@"isn't Equal");
        return NO;
    }
    
    NSData* data = [NSData dataWithContentsOfFile:self.urlVideo];
    
//    NSLog(@"==================");
//    NSLog(@"Request: %@", [loadingRequest.request.URL absoluteString]);
//    NSLog(@"Data: %@", self.urlVideo);
    
    loadingRequest.contentInformationRequest.contentType = @"mp4";
    //loadingRequest.contentInformationRequest.contentLength = [data length];
    loadingRequest.contentInformationRequest.contentLength = self.totalSize;
    //loadingRequest.contentInformationRequest.contentLength = 1000000;
    loadingRequest.contentInformationRequest.byteRangeAccessSupported = YES;
    
//    NSLog(@"======================");
//    NSLog(@"requestedOffset: %lld", loadingRequest.dataRequest.requestedOffset);
//    NSLog(@"requestedLength: %ld", (long)loadingRequest.dataRequest.requestedLength);
//    NSLog(@"data.length: %ld", (long)data.length);
//    NSLog(@"totalSize: %ld", (long)self.totalSize);
    
    if (self.isFirstCaching) {
        data = [data subdataWithRange:NSMakeRange((NSUInteger)loadingRequest.dataRequest.requestedOffset,
                                                  (NSUInteger)loadingRequest.dataRequest.requestedLength)];
        self.isFirstCaching = NO;
    }
    else {
        
        NSUInteger loadSize = 300000;
        
        if (loadingRequest.dataRequest.requestedLength < loadSize) {
            loadSize = loadingRequest.dataRequest.requestedLength;
        }
        
        if (loadingRequest.dataRequest.requestedOffset + loadSize > data.length) {
            return NO;
        }
        
        data = [data subdataWithRange:NSMakeRange((NSUInteger)loadingRequest.dataRequest.requestedOffset,
                                                  (NSUInteger)loadSize)];
    }
    
//    data = [data subdataWithRange:NSMakeRange((NSUInteger)loadingRequest.dataRequest.requestedOffset,
//                                                                        (NSUInteger)loadingRequest.dataRequest.requestedLength)];
    
    [loadingRequest.dataRequest respondWithData:data];
    [loadingRequest finishLoading];
    return YES;
}

- (BOOL)resourceLoader:(AVAssetResourceLoader *)resourceLoader shouldWaitForRenewalOfRequestedResource:(AVAssetResourceRenewalRequest *)renewalRequest {
    
    NSLog(@"shouldWaitForRenewalOfRequestedResource");
    return YES;
}

- (void)resourceLoader:(AVAssetResourceLoader *)resourceLoader didCancelLoadingRequest:(AVAssetResourceLoadingRequest *)loadingRequest {
    NSLog(@"didCancelLoadingRequest");
}

//- (void)loadVideoForURL_helper {
//    AVPlayer *player = [AVPlayer playerWithURL:[NSURL fileURLWithPath: self.urlVideo]];
//    [player seekToTime:self.playerView.player.currentTime];
//    self.playerView.player = player;
//    [self videoPlay:YES];
//    
//    //[self performSelector:@selector(loadVideoForURL_helper) withObject:nil afterDelay:3.0];
//}

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
        [self.playerView.player cancelPendingPrerolls];
    }
    
    [self hidePanelControl];
}

- (void)showPanel:(BOOL)show {
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.panelView.alpha = (show) ? 1.0 : 0.0;
    } completion:^(BOOL finished){
        
    }];
}

- (void)updateSlider {
    
    //self.panelView.slider.maximumValue = [self durationInSeconds];
    //self.panelView.slider.value = [self currentTimeInSeconds];
    [self.panelView setCurrentTime:[self currentTimeInSeconds] duration:[self durationInSeconds]];
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

- (void) hidePanelControl {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hidePanelControl_helper) object:nil];
    if (self.isPlay) {
        [self performSelector:@selector(hidePanelControl_helper) withObject:nil afterDelay:DELAY_PANEL_HIDDEN];
    }
}

- (void) hidePanelControl_helper {
    [self showPanel:NO];
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
    
    [self hidePanelControl];
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
    //[self videoPlay:YES];
    self.isPlay = YES;
}

- (void)clickPauseForVideoPanelView:(VideoPanelView*)videoPanelView {
    //[self videoPlay:NO];
    self.isPlay = NO;
}

- (void)clickBackForVideoPanelView:(VideoPanelView*)videoPanelView {
    [self.delegate backForVideoView:self];
    [self hidePanelControl];
}

- (void)clickFullScreenForVideoPanelView:(VideoPanelView*)videoPanelView {
    [self.delegate fullScreenForVideoView:self];
    [self hidePanelControl];
}

- (void)moveSliderForVideoPanelView:(VideoPanelView*)videoPanelView {
    CMTime newTime = CMTimeMakeWithSeconds(videoPanelView.slider.value, 1);
    [self.player seekToTime:newTime];
    [self hidePanelControl];
}

#pragma mark -
#pragma mark Notifications
- (void)playToEndTimeNotification:(NSNotification*)notification {
    NSLog(@"AVPlayerItemDidPlayToEndTimeNotification");
    //[self videoPlay:NO];
    self.isPlay = NO;
    [self showPanel:YES];
    self.playerView.hidden = YES;
    CMTime newTime = CMTimeMakeWithSeconds(0, 1);
    [self.player seekToTime:newTime];

    [self.sliderTimer invalidate];
    self.sliderTimer = nil;
    self.panelView.slider.value = 0.0;
    [self.panelView setCurrentTime:0.0 duration:self.duration];
    self.panelView.slider.minimumValue = 0.0;
    
    [self.delegate playToEndTimeForVideoView:self];
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
    //[self videoPlay:YES];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(videoPlay_helper) object:nil];
    [self performSelector:@selector(videoPlay_helper) withObject:nil afterDelay:2.0];
}

- (void)videoPlay_helper {
    //[self videoPlay:YES];
    self.isPlay = YES;
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




