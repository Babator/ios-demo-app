//
//  BBConfig.h
//  BabatorUI
//
//  Created by Nissim Pardo on 15/06/2016.
//  Copyright © 2016 babatordemo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBConfig : NSObject
+ (BBConfig *)shared;

@property (nonatomic, copy) NSDictionary *params;
@property (nonatomic, readonly) BOOL shouldShowRecommendation;
@property (nonatomic, readonly) NSURL *UITagUrl;
@property (nonatomic) NSTimeInterval keepAliveInterval;
@property (nonatomic, readonly, copy) NSString *apiURL;
@end
