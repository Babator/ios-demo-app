//
//  Babator.h
//  Babator-iOS-SDK
//
//  Created by Nissim Pardo on 8/16/15.
//  Copyright (c) 2015 babator. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BBRecommendation.h"
#import "BBConfig.h"
#import "BBAdEventsDelegate.h"


@protocol BabatorAds <NSObject>

- (BOOL)shouldLoadAds:(NSString *)babatorContentURL;

@end

@protocol BabatorRecommendation  <NSObject>


@end

@interface Babator : NSObject <BBAdEventsDelegate>

//+ (Babator *)shared;

- (void)initializeWithAPIKey:(NSString *)apiKey;

/*
- (void)addListener:(id<BabatorDelegate>)listener;

- (void)removeListener:(id<BabatorDelegate>)listener;
*/
- (void)dismissBabator;

@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *userUUID;
@property (nonatomic) NSInteger recommenationsSize;
@property (nonatomic, weak, readwrite) UIView *playerView;
@property (nonatomic, strong) BBConfig *config;
@property (nonatomic, weak) id<BabatorAds> babatorAds;
@end
