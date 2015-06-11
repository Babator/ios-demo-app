//
//  VideoPanelView.m
//  Babator
//
//  Created by Andrey Kulinskiy on 6/4/15.
//  Copyright (c) 2015 Andrey Kulinskiy. All rights reserved.
//

#import "VideoPanelView.h"
#import "ProgressView.h"

@interface VideoPanelView ()

@property (nonatomic, strong) UIButton* btnPlayPause;
@property (nonatomic, strong) UIButton* btnBack;
@property (nonatomic, strong) UIButton* btnFullScreen;
@property (nonatomic, strong) UIButton* btnShare;
@property (nonatomic, strong) UIButton* btnSetting;
@property (nonatomic, strong) UILabel* lblDuration;
@property (nonatomic, strong) ProgressView* progressView;

@end

@implementation VideoPanelView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.backgroundColor = [UIColor blackColor];
    [self addSubview:self.progressView];
    [self addSubview:self.btnPlayPause];
    [self addSubview:self.btnBack];
    [self addSubview:self.lblDuration];
    
    [self addSubview:self.btnShare];
    [self addSubview:self.btnSetting];
    [self addSubview:self.btnFullScreen];
    //[self addSubview:self.slider];
}

#pragma mark -
#pragma mark Methods
- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.progressView.frame = CGRectMake(0, 0, self.width, 6);
    CGFloat positionY = self.progressView.height;
    CGFloat heightControl = self.height - positionY;
    
    self.btnBack.frame = CGRectMake(10, positionY, heightControl, heightControl);
    self.btnPlayPause.frame = CGRectMake(self.btnBack.edgeX, positionY, heightControl, heightControl);
    
    [self.lblDuration sizeToFit];
    self.lblDuration.frame = CGRectMake(self.btnPlayPause.edgeX, (heightControl - self.lblDuration.height) / 2 + positionY, self.lblDuration.width, self.lblDuration.height);
    
    self.btnFullScreen.frame = CGRectMake(self.width - self.height - 10, positionY, heightControl, heightControl);
    self.btnSetting.frame = CGRectMake(self.btnFullScreen.originX - self.height, positionY, heightControl, heightControl);
    self.btnShare.frame = CGRectMake(self.btnSetting.originX - self.height, positionY, heightControl, heightControl);
    
    //self.slider.frame = CGRectMake(self.btnPlayPause.edgeX + 10, 0, self.btnFullScreen.frame.origin.x - self.btnPlayPause.edgeX - 20, self.height);
}

- (void)setCurrentTime:(Float64)currentTime duration:(Float64)duration {
    self.lblDuration.attributedText = [self createAttributedForCurrentTime:currentTime duration:duration];
    if (currentTime > 0.0) {
        self.progressView.value = currentTime / duration;
    }
    else {
        self.progressView.value = 0.0;
    }
}

- (NSAttributedString*)createAttributedForCurrentTime:(Float64)currentTime duration:(Float64)duration
{
    NSString* separator = @" / ";
    NSString* strCurrentTime = [Utils stringTimeFormatted:currentTime];
    NSString* strDuration = [Utils stringTimeFormatted:duration];
    NSString* fullText = [NSString stringWithFormat:@"%@%@%@", strCurrentTime, separator, strDuration];
    NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys: [UIFont boldSystemFontOfSize:16], NSFontAttributeName, [UIColor whiteColor], NSForegroundColorAttributeName, nil];
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:fullText attributes:attrs];
    
    NSRange range = NSMakeRange([strCurrentTime length], [separator length] + [strDuration length]);
    attrs = [NSDictionary dictionaryWithObjectsAndKeys: [UIFont boldSystemFontOfSize:16], NSFontAttributeName, [UIColor lightGrayColor], NSForegroundColorAttributeName, nil];
    [attributedText addAttributes:attrs range:range];
    
    return attributedText;
}

#pragma mark -
#pragma mark Actions
- (void)clickBtnPlayPausePlayer:(UIButton*)sender {
    sender.selected = !sender.selected;
    
    if (sender.selected) {
        [self.delegate clickPlayForVideoPanelView:self];
    }
    else {
        [self.delegate clickPauseForVideoPanelView:self];
    }
}

- (void)clickBtnBack:(UIButton*)sender {
    [self.delegate clickBackForVideoPanelView:self];
}

- (void)clickBtnFullScreen:(UIButton*)sender {
    [self.delegate clickFullScreenForVideoPanelView:self];
}

- (void)clickBtnShare:(UIButton*)sender {
    //NSLog(@"clickBtnShare");
}

- (void)clickBtnSettings:(UIButton*)sender {
    //NSLog(@"clickBtnSettings");
}

- (void)sliderValueChanged:(UISlider*)slider {
    [self.delegate moveSliderForVideoPanelView:self];
}

#pragma mark -
#pragma mark Property
- (UIButton *)btnPlayPause {
    if (!_btnPlayPause) {
        _btnPlayPause = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnPlayPause setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
        [_btnPlayPause setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateSelected];
        [_btnPlayPause addTarget:self action:@selector(clickBtnPlayPausePlayer:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnPlayPause;
}

- (UIButton *)btnBack {
    if (!_btnBack) {
        _btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnBack setImage:[UIImage imageNamed:@"prev"] forState:UIControlStateNormal];
        [_btnBack addTarget:self action:@selector(clickBtnBack:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnBack;
}

- (UIButton *)btnFullScreen {
    if (!_btnFullScreen) {
        _btnFullScreen = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnFullScreen setImage:[UIImage imageNamed:@"fullscreen"] forState:UIControlStateNormal];
        [_btnFullScreen addTarget:self action:@selector(clickBtnFullScreen:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnFullScreen;
}

- (UIButton *)btnShare {
    if (!_btnShare) {
        _btnShare = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnShare setImage:[UIImage imageNamed:@"open"] forState:UIControlStateNormal];
        [_btnShare addTarget:self action:@selector(clickBtnShare:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnShare;
}

- (UIButton *)btnSetting {
    if (!_btnSetting) {
        _btnSetting = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnSetting setImage:[UIImage imageNamed:@"volume"] forState:UIControlStateNormal];
        [_btnSetting addTarget:self action:@selector(clickBtnSettings:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnSetting;
}

- (UISlider*)slider {
    if (!_slider) {
        _slider = [[UISlider alloc]initWithFrame:CGRectZero];
        _slider.continuous = YES;
        [_slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _slider;
}

- (UILabel *)lblDuration {
    if (!_lblDuration) {
        _lblDuration = [[UILabel alloc]initWithFrame:CGRectZero];
        _lblDuration.backgroundColor = [UIColor clearColor];
        _lblDuration.textColor = [UIColor lightGrayColor];
        _lblDuration.font = [UIFont boldSystemFontOfSize:16];
        _lblDuration.textAlignment = NSTextAlignmentCenter;
        _lblDuration.text = @"00:00 / 00:00";
    }
    return _lblDuration;
}

- (ProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[ProgressView alloc]initWithFrame:CGRectZero];
    }
    return _progressView;
}

- (void)setIsPlay:(BOOL)isPlay {
    _isPlay = isPlay;
    self.btnPlayPause.selected = isPlay;
}

- (void)setSliderValue:(float)sliderValue {
    _sliderValue = sliderValue;
    self.slider.value = _sliderValue;
}


@end




