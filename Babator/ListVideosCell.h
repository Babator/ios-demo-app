//
//  ListVideosCell.h
//  Babator
//
//  Created by Andrey Kulinskiy on 6/4/15.
//  Copyright (c) 2015 Andrey Kulinskiy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VideoItem;

@interface ListVideosCell : UITableViewCell

- (void)setData:(VideoItem*)item;

@end
