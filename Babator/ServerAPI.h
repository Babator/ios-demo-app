//
//  ServerAPI.h
//  BCScheduling
//
//  Created by Andrey Kulinskiy on 4/10/14.
//  Copyright (c) 2014 Andrey Kulinskiy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JsonConvertor.h"
#import "VideoModule.h"
#import "VideosModule.h"

@class UserIDResponseModule;

@interface ServerAPI : NSObject

- (void)setWebserviceURL:(NSString *)webserviceURL;
- (void)setToken:(NSString *)token;

#pragma mark- Server API Methods
- (void)userIdForApiKey:(NSString *)apiKey
                success:(void (^)(UserIDResponseModule *request))successBlock
                failure:(FaultHandler)failureBlock;

- (void)firstVideoSuccess:(void (^)(VideoModule *request))successBlock
                  failure:(FaultHandler)failureBlock;

- (void)videosForVideoID:(NSInteger)videoID
                success:(void (^)(VideosModule *request))successBlock
                failure:(FaultHandler)failureBlock;

@end
