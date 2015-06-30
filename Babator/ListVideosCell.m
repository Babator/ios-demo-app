//
//  ListVideosCell.m
//  Babator
//
//  Created by Andrey Kulinskiy on 6/4/15.
//  Copyright (c) 2015 Andrey Kulinskiy. All rights reserved.
//

#import "ListVideosCell.h"
#import "BBTVideoItem.h"
#import "ThumbnailView.h"

#define MarginLeft 10
#define MarginRight 10
#define MarginTopBottom 5

@interface ListVideosCell ()

@property (nonatomic, strong)UILabel* lblTitle;
@property (nonatomic, strong)ThumbnailView* thumbnailView;

@end

@implementation ListVideosCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self addSubview:self.thumbnailView];
        //[self addSubview:self.lblTitle];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.thumbnailView.frame = CGRectMake(0, MarginTopBottom, self.width, self.height - MarginTopBottom * 2);
    //self.thumbnailView.frame = CGRectMake(MarginLeft, MarginTopBottom, 100, self.height - MarginTopBottom * 2);
    //self.lblTitle.frame = CGRectMake(self.thumbnailView.edgeX + 10, MarginTopBottom, self.width - self.thumbnailView.edgeX - 10 - MarginRight, self.thumbnailView.height);
}

#pragma mark -
#pragma mark Methods
- (void)setData:(BBTVideoItem*)item
{
    [self.thumbnailView setUrl:[Utils urlHDVideoForUrl:item.imageUrl] title:item.title duration:item.durationSec];
    self.lblTitle.text = item.title;
}

#pragma mark -
#pragma mark Propertys
- (ThumbnailView *)thumbnailView {
    if (!_thumbnailView) {
        _thumbnailView = [[ThumbnailView alloc]initWithFrame:CGRectZero];
        //_thumbnailView.thumbnailView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _thumbnailView;
}

- (UILabel *)lblTitle
{
    if (!_lblTitle) {
        _lblTitle = [[UILabel alloc]initWithFrame:CGRectZero];
        _lblTitle.backgroundColor = [UIColor clearColor];
        _lblTitle.textColor = [Utils colorLightText];
        _lblTitle.font = [UIFont systemFontOfSize:16];
        _lblTitle.numberOfLines = 3;
        //_lblTitle.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return _lblTitle;
}



@end




