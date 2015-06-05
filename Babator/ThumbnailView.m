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

@end

@implementation ThumbnailView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.thumbnailView];
        [self addSubview:self.lblDuration];
        self.userInteractionEnabled = NO;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.thumbnailView.frame = self.bounds;
    
    CGFloat marginDurationRight = self.width / 15;
    CGFloat marginDurationBottom = self.height / 10;
    self.lblDuration.frame = CGRectMake(self.width - self.lblDuration.width - marginDurationRight, self.height - self.lblDuration.height - marginDurationBottom, self.lblDuration.width, self.lblDuration.height);
}

- (void)setUrl:(NSString*)url duration:(NSInteger)duration
{
    self.url = url;
    self.duration = duration;
    
    [self loadThumbnailForUrl:url];
    
    self.lblDuration.text = [self timeFormatted:self.duration];
    
    [self.lblDuration sizeToFit];
    
    CGRect rect = self.lblDuration.frame;
    rect.size.width += 8;
    rect.size.height += 4;
    self.lblDuration.frame = rect;
}

- (NSString *)timeFormatted:(NSInteger)totalSeconds
{
    
    NSInteger seconds = totalSeconds % 60;
    NSInteger minutes = (totalSeconds / 60) % 60;
    NSInteger hours = totalSeconds / 3600;
    
    NSString* strResult = @"";
    if (hours == 0) {
        strResult = [NSString stringWithFormat:@"%02ld:%02ld", (long)minutes, (long)seconds];
    }
    else {
        strResult = [NSString stringWithFormat:@"%02ld:%02ld:%02ld",(long)hours, (long)minutes, (long)seconds];
    }
    
    return strResult;
}

- (void)loadThumbnailForUrl:(NSString*)url {
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
- (UIImageView *)thumbnailView {
    if (!_thumbnailView) {
        _thumbnailView = [[UIImageView alloc]initWithFrame:CGRectZero];
        _thumbnailView.contentMode = UIViewContentModeScaleAspectFit;
        _thumbnailView.backgroundColor = [UIColor blackColor];
    }
    return _thumbnailView;
}

- (UILabel *)lblDuration
{
    if (!_lblDuration) {
        _lblDuration = [[UILabel alloc]initWithFrame:CGRectZero];
        _lblDuration.backgroundColor = [UIColor blackColor];
        _lblDuration.textColor = [UIColor whiteColor];
        _lblDuration.font = [UIFont systemFontOfSize:12];
        _lblDuration.textAlignment = NSTextAlignmentCenter;
        _lblDuration.text = @"00:00";
    }
    return _lblDuration;
}



@end



