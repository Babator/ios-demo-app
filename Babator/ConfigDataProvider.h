//
//  ConfigDataProvider.h
//  BCScheduling
//
//  Created by Andrey Kulinskiy on 4/10/14.
//  Copyright (c) 2014 Andrey Kulinskiy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConfigDataProvider : NSObject

@property (nonatomic, strong) NSString* userID;
@property (nonatomic, strong) NSString* apiKey;

// Login
+ (NSString*)serverURL;
+ (NSString*)deviceId;

+ (void)setUserID:(NSString *)userID;
+ (NSString*)userID;

@end
