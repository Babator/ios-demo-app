//
//  ProgressView.m
//  Babator
//
//  Created by Andrey Kulinskiy on 6/11/15.
//  Copyright (c) 2015 Andrey Kulinskiy. All rights reserved.
//

#import "ProgressView.h"

@interface ProgressView ()

@property (nonatomic, strong) UIImageView* background;
@property (nonatomic, strong) UIView* progressLine;

@end

@implementation ProgressView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

#pragma mark -
#pragma mark Methods
- (void)setup {
    self.value = 0.0;
    [self addSubview:self.background];
    [self addSubview:self.progressLine];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.background.frame = CGRectMake(0, 0, self.width, self.height);
    self.progressLine.frame = CGRectMake(0, 0, self.width * self.value, self.height);
}

- (void)setValue:(CGFloat)value {
    _value = value;
    if (value < 0) {
        _value = 0;
    }
    [self setNeedsLayout];
}

#pragma mark -
#pragma mark Property
- (UIImageView *)background {
    if (!_background) {
        _background = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"progressbar_back"]];
    }
    return _background;
}

- (UIView *)progressLine {
    if (!_progressLine) {
        _progressLine = [[UIView alloc]initWithFrame:CGRectZero];
        _progressLine.backgroundColor = [Utils colorBlue];
    }
    return _progressLine;
}

@end
