//
//  VideoPanelView.m
//  Babator
//
//  Created by Andrey Kulinskiy on 6/4/15.
//  Copyright (c) 2015 Andrey Kulinskiy. All rights reserved.
//

#import "VideoPanelView.h"

@interface VideoPanelView ()

@property (nonatomic, strong) UIButton* btnPlayPause;
@property (nonatomic, strong) UIButton* btnBack;
@property (nonatomic, strong) UIButton* btnFullScreen;

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
    self.backgroundColor = [Utils colorDarkBorder];
    [self addSubview:self.btnPlayPause];
    [self addSubview:self.btnBack];
    [self addSubview:self.btnFullScreen];
}

#pragma mark -
#pragma mark Methods
- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.btnBack.frame = CGRectMake(10, 0, 40, self.height);
    self.btnPlayPause.frame = CGRectMake(self.btnBack.edgeX + 10, 0, 40, self.height);
    self.btnFullScreen.frame = CGRectMake(self.width - 50, 0, 40, self.height);
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

- (void)setIsPlay:(BOOL)isPlay {
    _isPlay = isPlay;
    self.btnPlayPause.selected = isPlay;
}


@end




