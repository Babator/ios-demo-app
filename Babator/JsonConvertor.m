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
    for (NSDictionary* dicVideo in videos) {
        [addVideos addObject:[JsonConvertor videoItemFromDictionary:dicVideo]];
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
    for (NSDictionary* dicVideo in videos) {
        [addVideos addObject:[JsonConvertor videoItemFromDictionary:dicVideo]];
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

//+ (NSDictionary *)dictionaryFormLoginParams:(LoginParams*) loginParams
//{
//    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys: loginParams.userName, @"username",
//                                loginParams.password, @"password", nil];
//    return dictionary;
//}
//
//+ (LoginResult *)loginResultFromDictionary:(NSDictionary *)dictionary
//{
//    if (!dictionary || (id)dictionary == [NSNull null])
//        return nil;
//    
//    LoginResult * loginResult = [[LoginResult alloc]init];
//    loginResult.token = [dictionary objectForKey:@"token"];
//    loginResult.message = [dictionary objectForKey:@"message"];
//    loginResult.chains = [JsonConvertor chainsFromArray:[dictionary objectForKey:@"chains"]];
//    loginResult.user = [self userFromDictionary:[dictionary objectForKey:@"user"]];
//    loginResult.codeError = [JsonConvertor integerFormData:[dictionary objectForKey:@"code"]];
//    loginResult.messageError = [dictionary objectForKey:@"message"];
//    loginResult.accessLevel = [JsonConvertor accessLevelFromDictionary:[dictionary objectForKey:@"accessLevel"]];
//    loginResult.settingConfig = [JsonConvertor settingConfigFromDictionary:[dictionary objectForKey:@"scheduleSettings"]];
//    
//    return loginResult;
//}

//+ (NSArray*) chainsFromArray:(NSArray*)arrayData
//{
//    NSMutableArray* result = [NSMutableArray array];
//    
//    for (NSDictionary* jsonItem in arrayData)
//    {
//        Chain* chain = [JsonConvertor chainFromDictionary:jsonItem];
//        [result addObject:chain];
//    }
//    
//    return result;
//}
//
//+ (Chain*)chainFromDictionary:(NSDictionary*) dictionary
//{
//    if (!dictionary || (id)dictionary == [NSNull null])
//        return nil;
//    
//    Chain* chain = [[Chain alloc] init];
//    
//    chain.chainID = [[dictionary objectForKey:@"chain_id"]integerValue];
//    chain.countryCode  = [dictionary objectForKey:@"country_code"];
//    chain.createDate  = [Utils dateFromString:[dictionary objectForKey:@"create_date"]];
//    chain.creatorID = [[dictionary objectForKey:@"creator_id"]integerValue];
//    chain.emailSettings  = [dictionary objectForKey:@"email_settings"];
//    chain.logo  = [dictionary objectForKey:@"logo"];
//    chain.name  = [dictionary objectForKey:@"name"];
//    chain.descript  = [dictionary objectForKey:@"description"];
//    chain.codeError = [JsonConvertor integerFormData:[dictionary objectForKey:@"code"]];
//    chain.messageError = [dictionary objectForKey:@"message"];
//    chain.loginUrl = [dictionary objectForKey:@"loginUrl"];
//    
//    return chain;
//}

//+ (ShowWeekType)showWeekTypeFromString:(NSString*)string
//{
//    ShowWeekType result = ShowWeekType_Default;
//    if (!string || (id)string == [NSNull null]) {
//        return result;
//    }
//    
//    if ([string isEqualToString:@"current_week"]) {
//        result = ShowWeekType_CurrentWeek;
//    }
//    else if ([string isEqualToString:@"current_week_and_next"]) {
//        result = ShowWeekType_CurrentWeekAndNext;
//    }
//    
//    return result;
//}

//+ (NSString*)stringFromUserStatus:(UserStatus)userStatus
//{
//    NSString* result = @"";
//    
//    switch (userStatus) {
//        case UserStatus_None:
//            result = (id)[NSNull null];
//            break;
//        case UserStatus_Want:
//            result = @"want";
//            break;
//        case UserStatus_Can:
//            result = @"can";
//            break;
//        case UserStatus_Cant:
//            result = @"cant";
//            break;
//        case UserStatus_Exchange:
//            result = @"exchange";
//            break;
//        case UserStatus_CancelExchange:
//            result = @"cancel-exchange";
//            break;
//        case UserStatus_Cancel:
//            result = @"cancel";
//            break;
//    }
//    
//    return result;
//}


@end






