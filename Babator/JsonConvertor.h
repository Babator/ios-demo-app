//
//  JsonConvertor.h
//  BCScheduling
//
//  Created by Andrey Kulinskiy on 4/10/14.
//  Copyright (c) 2014 Andrey Kulinskiy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseResponseModule.h"

@class UserIDResponseModule, VideoModule, VideosModule;

@interface JsonConvertor : NSObject

+ (NSInteger)integerFormData:(id) data;

// BaseResponseModule
+ (BaseResponseModule*)responseModuleFromDictionary:(NSDictionary *)dictionary;

// Login
//+ (User*)userFromDictionary:(NSDictionary *)dictionary;
+ (UserIDResponseModule*)userIDResponseModuleFromDictionary:(NSDictionary *)dictionary;
+ (VideoModule*)firstVideoModuleModuleFromDictionary:(NSDictionary *)dictionary;
+ (VideosModule*)videosModuleModuleFromDictionary:(NSDictionary *)dictionary;


@end



