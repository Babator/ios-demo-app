//
//  JsonConvertor.m
//  BCScheduling
//
//  Created by Andrey Kulinskiy on 4/10/14.
//  Copyright (c) 2014 Andrey Kulinskiy. All rights reserved.
//

#import "JsonConvertor.h"
#import "UserIDResponseModule.h"
#import "VideoModule.h"
#import "VideosModule.h"

@implementation JsonConvertor

+ (id) NSNullOrItself: (id) object
{
    return (object)? object : [NSNull null];
}

+ (NSString*)stringFormData:(id) data
{
    if (!data || (id)data == [NSNull null])
        return @"";
    return data;
}

+ (NSInteger)integerFormData:(id) data
{
    if (!data || (id)data == [NSNull null])
        return 0;
    return [data integerValue];
}

+ (int)intFormData:(id) data
{
    if (!data || (id)data == [NSNull null])
        return 0;
    return [data intValue];
}

+ (BaseResponseModule*)responseModuleFromDictionary:(NSDictionary *)dictionary
{
    if (!dictionary || (id)dictionary == [NSNull null])
        return nil;
    
    BaseResponseModule * response = [[BaseResponseModule alloc]init];
    [JsonConvertor setDataForBaseResponseModule:response fromDictionary:dictionary];
    
    return response;
}

+ (void)setDataForBaseResponseModule:(BaseResponseModule*)baseResponseModule fromDictionary:(NSDictionary *)dictionary
{
    baseResponseModule.status = [JsonConvertor integerFormData:[dictionary objectForKey:@"status"]];
    baseResponseModule.errors = [dictionary objectForKey:@"errors"];
}

//+ (NSArray*)errorsFromArray:(NSArray*)array {
//    
//    
//}

#pragma mark - User ID
+ (UserIDResponseModule*)userIDResponseModuleFromDictionary:(NSDictionary *)dictionary
{
    if (!dictionary || (id)dictionary == [NSNull null])
        return nil;
    
    UserIDResponseModule* result = [[UserIDResponseModule alloc]init];
    [JsonConvertor setDataForBaseResponseModule:result fromDictionary:dictionary];
    
    NSDictionary* dicData = [dictionary objectForKey:@"data"];
    result.userID = [JsonConvertor stringFormData:[dicData objectForKey:@"userId"]];
    
    return result;
}

#pragma Videos
+ (VideoModule*)firstVideoModuleModuleFromDictionary:(NSDictionary *)dictionary {
    
    if (!dictionary || (id)dictionary == [NSNull null])
        return nil;
    
    VideoModule* result = [[VideoModule alloc]init];
    [JsonConvertor setDataForBaseResponseModule:result fromDictionary:dictionary];
    
    NSDictionary* dicData = [dictionary objectForKey:@"data"];
    VideoItem* videoItem = [JsonConvertor videoItemFromDictionary:[dicData objectForKey:@"video"]];
    
    NSArray* videos = [dicData objectForKey:@"videos"];
    NSMutableArray* addVideos = [NSMutableArray array];
    
    NSInteger index = 0;
    for (NSDictionary* dicVideo in videos) {
        if (index >= 10) {
            break;
        }
        [addVideos addObject:[JsonConvertor videoItemFromDictionary:dicVideo]];
        index ++;
    }

    videoItem.videos = addVideos;
    result.videoItem = videoItem;
    
    return result;
}

+ (VideosModule*)videosModuleModuleFromDictionary:(NSDictionary *)dictionary {
    
    if (!dictionary || (id)dictionary == [NSNull null])
        return nil;
    
    VideosModule* result = [[VideosModule alloc]init];
    [JsonConvertor setDataForBaseResponseModule:result fromDictionary:dictionary];
    
    NSDictionary* dicData = [dictionary objectForKey:@"data"];
    
    NSArray* videos = [dicData objectForKey:@"videos"];
    NSMutableArray* addVideos = [NSMutableArray array];
    
    
    NSInteger index = 0;
    for (NSDictionary* dicVideo in videos) {
        if (index >= 10) {
            break;
        }
        [addVideos addObject:[JsonConvertor videoItemFromDictionary:dicVideo]];
        index ++;
    }
    
    result.videos = addVideos;
    
    return result;
}

+ (VideoItem*)videoItemFromDictionary:(NSDictionary *)dictionary {
    
    if (!dictionary || (id)dictionary == [NSNull null])
        return nil;
    
    VideoItem* result = [[VideoItem alloc]init];
    result.videoID = [JsonConvertor integerFormData:[dictionary objectForKey:@"videoId"]];
    result.durationSec = [JsonConvertor integerFormData:[dictionary objectForKey:@"durationSec"]];
    result.title = [JsonConvertor stringFormData:[dictionary objectForKey:@"title"]];
    result.url = [JsonConvertor stringFormData:[dictionary objectForKey:@"url"]];
    result.imageUrl = [JsonConvertor stringFormData:[dictionary objectForKey:@"imageUrl"]];
    
    return result;
}


@end






