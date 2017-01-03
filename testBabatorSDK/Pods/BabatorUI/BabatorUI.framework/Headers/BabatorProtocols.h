//
//  BabatorProtocols.h
//  BabatorUI
//
//  Created by Nissim Pardo on 06/11/2015.
//  Copyright © 2015 babator. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol BBRecommendation;


typedef NS_ENUM(NSInteger, BabatorRecommendationType) {
    BabatorRecommendationTypeList,
    BabatorRecommendationTypeCategory
};

@protocol BBVideoParams;
@protocol BBRecommendationViewDelegate <NSObject>

- (void)didSelecteRecommendation:(id<BBVideoParams>)videoParams;

@end

@protocol BBRecommendation
@property (nonatomic, readonly, copy) NSString *viewUUID;
@property (nonatomic, readonly, copy) NSArray *categories;
@property (nonatomic, copy) NSArray *videoList;
@property (nonatomic, copy) NSArray *videosArray;
@property (nonatomic, readonly, copy) NSNumber *status;
- (NSArray *)videosForCategory:(NSString *)category;
@end


@protocol BBRecommendationView <NSObject>

@property (nonatomic, strong, readonly) UIView *view;
@property (nonatomic, copy) id<BBRecommendation> recommendations;
@property (nonatomic, weak) id<BBRecommendationViewDelegate> delegate;

@end



@protocol BBVideoParams

@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, copy, readonly) NSString *videoId;
@property (nonatomic, copy, readonly) NSString *costumerVideoId;
@property (nonatomic, copy, readonly) NSURL *url;
@property (nonatomic, copy, readonly) NSNumber *durationSec;
@property (nonatomic, copy, readonly) NSURL *imageUrl;
@property (nonatomic, copy, readonly) NSURL *stripUrl;
@property (nonatomic, copy, readonly) NSNumber *pubDate;
@property (nonatomic, copy, readonly) NSNumber *percentValue;
@property (nonatomic, copy, readonly) NSString *category;
@property (nonatomic, copy, readonly) NSString *pageUrl;
@property (nonatomic, copy) UIImage *image;
@property (nonatomic) CGSize size;
@property (nonatomic) NSInteger index;

@end
