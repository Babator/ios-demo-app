//
//  ThumbnailView.m
//  Babator
//
//  Created by Andrey Kulinskiy on 6/3/15.
//  Copyright (c) 2015 Andrey Kulinskiy. All rights reserved.
//

#import "ThumbnailView.h"

@interface ThumbnailView ()

@property (nonatomic, strong) NSString* url;
@property (nonatomic, assign) NSInteger duration;
@property (nonatomic, strong) UIView* substrate;

@end

@implementation ThumbnailView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.substrate];
        [self.substrate addSubview:self.thumbnailView];
        [self addSubview:self.infoView];
        [self.infoView addSubview:self.lblTitle];
        [self.infoView addSubview:self.lblDuration];
        self.userInteractionEnabled = NO;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.substrate.frame = self.bounds;
    self.thumbnailView.frame = self.substrate.bounds;
    /*
    CGFloat marginDurationRight = self.width / 15;
    CGFloat marginDurationBottom = self.height / 10;
    self.lblDuration.frame = CGRectMake(self.width - self.lblDuration.width - marginDurationRight, self.height - self.lblDuration.height - marginDurationBottom, self.lblDuration.width, self.lblDuration.height);
     */
    self.infoView.frame = CGRectMake(0, self.height - 30, self.width, 30);
    self.lblDuration.frame = CGRectMake(self.infoView.width - self.lblDuration.width - 10, (self.infoView.height - self.lblDuration.height) / 2, self.lblDuration.width, self.lblDuration.height);
    self.lblTitle.frame = CGRectMake(10, 0, self.lblDuration.originX - 15, self.infoView.height);
}

- (void)setUrl:(NSString*)url title:(NSString*)title duration:(NSInteger)duration
{
    self.url = url;
    self.duration = duration;
    
    [self loadThumbnailForUrl:url];
    self.lblTitle.text = title;
    self.lblDuration.text = [Utils stringTimeFormatted:self.duration];
    
    [self.lblDuration sizeToFit];
    [self setNeedsLayout];
    
//    CGRect rect = self.lblDuration.frame;
//    rect.size.width += 8;
//    rect.size.height += 4;
//    self.lblDuration.frame = rect;
}

- (void)loadThumbnailForUrl:(NSString*)url {
    self.thumbnailView.image = nil;
    if (url) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (image) {
                    self.thumbnailView.image = image;
                }
            });
        });
    }
}

#pragma mark -
#pragma mark Actions

#pragma mark -
#pragma mark Property
- (UIView *)substrate {
    if (!_substrate) {
        _substrate = [[UIView alloc]initWithFrame:CGRectZero];
        _substrate.layer.masksToBounds = YES;
    }
    return _substrate;
}

- (UIImageView *)thumbnailView {
    if (!_thumbnailView) {
        _thumbnailView = [[UIImageView alloc]initWithFrame:CGRectZero];
        _thumbnailView.contentMode = UIViewContentModeScaleAspectFill;
        _thumbnailView.backgroundColor = [UIColor blackColor];
    }
    return _thumbnailView;
}

- (UILabel *)lblDuration {
    if (!_lblDuration) {
        _lblDuration = [[UILabel alloc]initWithFrame:CGRectZero];
        _lblDuration.backgroundColor = [UIColor clearColor];
        _lblDuration.textColor = [UIColor lightGrayColor];
        _lblDuration.font = [UIFont systemFontOfSize:16];
        _lblDuration.textAlignment = NSTextAlignmentCenter;
        _lblDuration.text = @"00:00";
    }
    return _lblDuration;
}

- (UILabel *)lblTitle {
    if (!_lblTitle) {
        _lblTitle = [[UILabel alloc]initWithFrame:CGRectZero];
        _lblTitle.backgroundColor = [UIColor clearColor];
        _lblTitle.textColor = [UIColor whiteColor];
        _lblTitle.font = [UIFont boldSystemFontOfSize:16];
        //_lblTitle.textAlignment = NSTextAlignmentCenter;
        _lblTitle.text = @"";
    }
    return _lblTitle;
}

- (UIView*)infoView {
    if (!_infoView) {
        _infoView = [[UIView alloc] initWithFrame:CGRectZero];
        _infoView.backgroundColor = [UIColor clearColor];
        UIView* background = [[UIView alloc] initWithFrame:_infoView.bounds];
        background.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        background.backgroundColor = [UIColor blackColor];
        background.alpha = 0.72;
        [_infoView addSubview:background];
    }
    return _infoView;
}



@end



