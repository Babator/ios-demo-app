//
//  ThumbnailView.h
//  Babator
//
//  Created by Andrey Kulinskiy on 6/3/15.
//  Copyright (c) 2015 Andrey Kulinskiy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThumbnailView : UIView

@property (nonatomic, readonly) NSString* url;
@property (nonatomic, readonly) NSInteger duration;
@property (nonatomic, strong) UIImageView* thumbnailView;
@property (nonatomic, strong) UILabel* lblDuration;

- (void)setUrl:(NSString*)url duration:(NSInteger)duration;

@end
