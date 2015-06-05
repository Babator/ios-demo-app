//
//  ListVideosView.h
//  Babator
//
//  Created by Andrey Kulinskiy on 6/4/15.
//  Copyright (c) 2015 Andrey Kulinskiy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VideoItem;
@protocol ListVideosViewDelegate;

@interface ListVideosView : UIView

@property (nonatomic, weak) id<ListVideosViewDelegate> delegate;
@property (nonatomic, strong) NSArray* videos;

@end

@protocol ListVideosViewDelegate <NSObject>

- (void)listVideosView:(ListVideosView*)listVideosView selectItem:(VideoItem*)item;

@end
