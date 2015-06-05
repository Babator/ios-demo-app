//
//  VideoModule.h
//  Babator
//
//  Created by Andrey Kulinskiy on 6/3/15.
//  Copyright (c) 2015 Andrey Kulinskiy. All rights reserved.
//

#import "BaseResponseModule.h"
#import "VideoItem.h"

@interface VideoModule : BaseResponseModule

@property (nonatomic, strong) VideoItem* videoItem;

@end
