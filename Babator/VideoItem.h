//
//  VideoItem.h
//  Babator
//
//  Created by Andrey Kulinskiy on 6/3/15.
//  Copyright (c) 2015 Andrey Kulinskiy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoItem : NSObject

@property (nonatomic, assign) NSInteger videoID;
@property (nonatomic, assign) NSInteger durationSec;
@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSString* url;
@property (nonatomic, strong) NSString* imageUrl;
@property (nonatomic, strong) NSArray*  videos;

@end
