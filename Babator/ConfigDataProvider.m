//
//  ConfigDataProvider.m
//  BCScheduling
//
//  Created by Andrey Kulinskiy on 4/10/14.
//  Copyright (c) 2014 Andrey Kulinskiy. All rights reserved.
//

#import "ConfigDataProvider.h"

@implementation ConfigDataProvider

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

+ (NSString*)deviceId
{
    NSString* result = [[NSUserDefaults standardUserDefaults] stringForKey:DEVICE_ID];
    
    if (!result) {
        
        result = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        [[NSUserDefaults standardUserDefaults] setObject:result forKey:DEVICE_ID];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    return result;
}

+ (NSString *)serverURL
{
    return @"http://api.babator.com";
    //return @"http://private-anon-ff38900b4-babatorapi.apiary-mock.com";
    //return [ConfigDataProvider getServerUrl];
}

#pragma - mark User ID
+ (void)setUserID:(NSString *)userID
{
    [[NSUserDefaults standardUserDefaults] setObject:userID forKey:USER_ID];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)userID
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:USER_ID];
}

//+(void)setServerUrl:(NSString*)serverUrl
//{
//    [[NSUserDefaults standardUserDefaults] setObject:serverUrl forKey:SERVER_URL_CONFIG];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//}
//
//+(NSString*)getServerUrl
//{
//    NSString* result = [[NSUserDefaults standardUserDefaults] stringForKey:SERVER_URL_CONFIG];
//    if (!result) {
//        result = PROD_SERVER_URL;
//    }
//    return result;
//}


@end




