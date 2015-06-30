//
//  BBTVideoItem.h
//  Babator
//
//  Created by Andrey Kulinskiy on 6/30/15.
//  Copyright (c) 2015 Andrey Kulinskiy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBTVideoItem : NSObject

// video id
@property (nonatomic, assign) NSInteger videoID;

// duration Seconds
@property (nonatomic, assign) NSInteger durationSec;

// title video
@property (nonatomic, strong) NSString* title;

// url to video
@property (nonatomic, strong) NSString* url;

// url to thumbnail
@property (nonatomic, strong) NSString* imageUrl;

// list of recommended videos. BBTVideoItem
@property (nonatomic, strong) NSArray*  videos;

@end
